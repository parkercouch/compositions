use std::sync::Arc;

use async_std::task;
use composition::actors::messenger::{Message, Messenger};
use composition::actors::receiver::{Listen, Receiver};
use composition::actors::sequencer::{Sequence, Sequencer};
use composition::messages::blah::Blah;
use composition::messages::ding::Ding;
use composition::messages::pierce::Pierce;
use composition::osc::{create_osc_connection_pool, load_sc_scripts};
use structopt::StructOpt;
use xactor::*;

#[derive(Debug, StructOpt)]
#[structopt(name = "composition", about = "dynamic generative composition")]
struct Opt {
    /// Activate debug mode
    #[structopt(short, long)]
    debug: bool,

    /// Wait time
    #[structopt(short = "w", long = "wait", default_value = "100")]
    wait: u64,

    /// How many notes
    #[structopt(short = "n", long = "notes", default_value = "10")]
    notes: u8,

    /// Which port to send OSC messages to (SC listening port)
    #[structopt(short = "s", long = "send_port", default_value = "57120")]
    send_port: u32,

    /// Which port to listen for OSC messages on
    #[structopt(short = "r", long = "recv_port", default_value = "8080")]
    recv_port: u32,

    /// scd file to load into new server
    #[structopt(short = "l", long = "load_path")]
    load_path: Option<String>,
}

#[xactor::main]
async fn main() -> anyhow::Result<()> {
    let opt = Opt::from_args();
    let port = opt.send_port;

    if let Some(load_path) = opt.load_path {
        let _sclang = spawn(async move {
            let child = load_sc_scripts(port, load_path);
            task::sleep(std::time::Duration::from_millis(500)).await;
            child
        });
    }

    let (osc_sender_pool, osc_listener) =
        create_osc_connection_pool(opt.send_port, opt.recv_port).await?;

    let messenger_addr = Supervisor::start(move || Messenger::new(osc_sender_pool.clone())).await?;

    let sequencer_addr = {
        let handle = Arc::new(tokio::runtime::Runtime::new()?);
        let addr = messenger_addr.clone();
        Supervisor::start(move || Sequencer::new(addr.clone(), handle.clone())).await?
    };

    // test send
    if opt.debug {
        sequencer_addr.send(Sequence::new(opt.notes))?;

        for i in 1..=opt.notes {
            task::sleep(std::time::Duration::from_millis(opt.wait)).await;
            messenger_addr.send(Ding(i.into()))?;
        }

        task::sleep(std::time::Duration::from_millis(opt.wait)).await;
        messenger_addr.send(Pierce::new(3, 20))?;

        task::sleep(std::time::Duration::from_secs(2)).await;
        messenger_addr.send(Blah::new(0.5, 15))?;

        task::sleep(std::time::Duration::from_secs(2)).await;
        messenger_addr.send(Message::new("/any", vec![0.5, 15.]))?;
    }

    Receiver::new(osc_listener, messenger_addr)
        .start()
        .await?
        .call(Listen)
        .await?
}
