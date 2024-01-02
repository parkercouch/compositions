use async_osc::prelude::*;
use async_osc::{OscPacket, OscType};
use async_std::task;
use composition::actors::messenger::{Message, Messenger};
use composition::messages::blah::Blah;
use composition::messages::cont::Continue;
use composition::messages::ding::Ding;
use composition::messages::pierce::Pierce;
use composition::osc::{create_osc_connection_pool, load_sc_scripts};
use futures::StreamExt;
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
    notes: i32,

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

    let (osc_sender_pool, mut osc_listener) =
        create_osc_connection_pool(opt.send_port, opt.recv_port).await?;

    let messenger_addr = Supervisor::start(move || Messenger::new(osc_sender_pool.clone())).await?;

    // test send
    if opt.debug {
        for i in 1..=opt.notes {
            task::sleep(std::time::Duration::from_millis(opt.wait)).await;
            messenger_addr.send(Ding(i))?;
        }

        task::sleep(std::time::Duration::from_millis(opt.wait)).await;
        messenger_addr.send(Pierce::new(3, 20))?;

        task::sleep(std::time::Duration::from_secs(2)).await;
        messenger_addr.send(Blah::new(0.5, 15))?;

        task::sleep(std::time::Duration::from_secs(2)).await;
        messenger_addr.send(Message::new("/any", vec![0.5, 15.]))?;
    }

    // recv loop - TODO: move into other thread or maybe it's own actor?
    while let Some(packet) = osc_listener.next().await {
        let (packet, peer_addr) = packet?;
        eprintln!("Receive from {}: {:?}", peer_addr, packet);
        match packet {
            OscPacket::Bundle(_) => {}
            OscPacket::Message(message) => match message.as_tuple() {
                ("/hello", &[OscType::String(ref msg)]) => {
                    println!("Hello: {}", msg);
                }
                ("/dong", &[OscType::Int(scale)]) => {
                    println!("Dong: {}", scale);
                    println!("Dinging: {}", scale * 2);
                    messenger_addr.send(Ding(scale * 2))?;
                }
                ("/pierce", &[OscType::Int(scale), OscType::Int(length)]) => {
                    messenger_addr.send(Pierce::new(scale, length))?;
                }
                ("/start", &[OscType::Int(seed), OscType::Int(other)]) => {
                    let messenger_addr = messenger_addr.clone();
                    spawn(async move {
                        println!("Start: {}", seed);
                        messenger_addr
                            .send(Pierce::new(seed / 2, other * 2))
                            .unwrap();
                        for i in 1..=seed * 2 {
                            task::sleep(std::time::Duration::from_millis(other as u64)).await;
                            messenger_addr.send(Ding(i)).unwrap();
                        }
                        messenger_addr
                            .send(Continue::new(seed - 2, other + 1))
                            .unwrap();
                    });
                }
                _ => {}
            },
        }
    }

    Ok(())
}
