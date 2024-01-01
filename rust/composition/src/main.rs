use async_osc::prelude::*;
use async_osc::{OscPacket, OscType};
use async_std::task;
use futures::StreamExt;
use composition::actors::blah::{Blah, Blaher};
use composition::actors::cont::{Continue, Continuer};
use composition::actors::ding::{Ding, Dinger};
use composition::actors::messenger::{Messenger, Message, Dingg};
use composition::actors::pierce::{Pierce, Piercer};
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
            println!("IN,BEFORE: sclang/scsynth started");
            task::sleep(std::time::Duration::from_millis(500)).await;
            println!("IN,AFTER: sclang/scsynth started");
            child
        });
        println!("OUT: sclang/scsynth started");
    }

    let (osc_sender_pool, mut osc_listener) =
        create_osc_connection_pool(opt.send_port, opt.recv_port).await?;

    // TODO: how to remove excess clones?
    let osc_sender = osc_sender_pool.clone();
    let ding_addr = Supervisor::start(move || Dinger::new(osc_sender.clone())).await?;
    let osc_sender = osc_sender_pool.clone();
    let pierce_addr = Supervisor::start(move || Piercer::new(osc_sender.clone())).await?;
    let osc_sender = osc_sender_pool.clone();
    let blah_addr = Supervisor::start(move || Blaher::new(osc_sender.clone())).await?;
    let osc_sender = osc_sender_pool.clone();
    let continue_addr = Supervisor::start(move || Continuer::new(osc_sender.clone())).await?;
    let osc_sender = osc_sender_pool.clone();
    let messenger_addr = Supervisor::start(move || Messenger::new(osc_sender.clone())).await?;

    // test send
    if opt.debug {
        for i in 1..=opt.notes {
            task::sleep(std::time::Duration::from_millis(opt.wait)).await;
            ding_addr.send(Ding(i))?;
        }

        task::sleep(std::time::Duration::from_millis(opt.wait)).await;
        pierce_addr.send(Pierce::new(3, 20))?;

        task::sleep(std::time::Duration::from_secs(2)).await;
        blah_addr.send(Blah::new(0.5, 15))?;
    }

    // recv loop - TODO: move into other thread or maybe it's own actor?
    //  realizing that there probably needs to be an App type to hold all the addresses
    //  or maybe use DI via `shaku` crate. Explore this to clean this up.
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
                    ding_addr.send(Ding(scale * 2))?;
                }
                ("/pierce", &[OscType::Int(scale), OscType::Int(length)]) => {
                    // pierce_addr.send(Pierce::new(scale, length))?;
                    messenger_addr.send(Message::new("/piercing".into(), scale.into(), length.into()))?;
                }
                ("/start", &[OscType::Int(seed), OscType::Int(other)]) => {
                    let ding_addr = ding_addr.clone();
                    let _pierce_addr = pierce_addr.clone();
                    let continue_addr = continue_addr.clone();
                    let messenger_addr = messenger_addr.clone();
                    spawn(async move {
                        println!("Start: {}", seed);
                        // pierce_addr.send(Pierce::new(seed / 2, other * 2)).unwrap();
                        messenger_addr.send(Message::new("/piercing".into(), (seed / 2) as f64, (other * 2) as f64)).unwrap();
                        for i in 1..=seed * 2 {
                            task::sleep(std::time::Duration::from_millis(other as u64)).await;
                            messenger_addr.send(Dingg(i)).unwrap();
                            ding_addr.send(Ding(i)).unwrap();
                        }
                        continue_addr
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
