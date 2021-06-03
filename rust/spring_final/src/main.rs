use async_osc::prelude::*;
use async_osc::{OscPacket, OscType};
use async_std::task;
use futures::StreamExt;
use spring_final::actors::ding::{Ding, Dinger};
use spring_final::actors::pierce::{Pierce, Piercer};
use spring_final::osc::create_osc_connection_pool;
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
}

#[xactor::main]
async fn main() -> anyhow::Result<()> {
    let opt = Opt::from_args();

    let (osc_sender_pool, mut osc_listener) =
        create_osc_connection_pool(opt.send_port, opt.recv_port).await?;

    // TODO: how to remove excess clones?
    let osc_sender = osc_sender_pool.clone();
    let ding_addr = Supervisor::start(move || Dinger::new(osc_sender.clone())).await?;
    let osc_sender = osc_sender_pool.clone();
    let pierce_addr = Supervisor::start(move || Piercer::new(osc_sender.clone())).await?;

    // send
    for i in 1..=opt.notes {
        task::sleep(std::time::Duration::from_millis(opt.wait)).await;
        ding_addr.send(Ding(i))?;
    }

    task::sleep(std::time::Duration::from_millis(opt.wait)).await;
    pierce_addr.send(Pierce::new(3, 20))?;

    // recv loop - TODO: move into other thread or maybe it's own actor?
    while let Some(packet) = osc_listener.next().await {
        let (packet, peer_addr) = packet?;
        eprintln!("Receive from {}: {:?}", peer_addr, packet);
        match packet {
            OscPacket::Bundle(_) => {}
            OscPacket::Message(message) => match message.as_tuple() {
                ("/hello", &[OscType::String(ref msg)]) => {
                    eprintln!("Hello: {}", msg);
                }
                ("/dong", &[OscType::Int(scale)]) => {
                    eprintln!("Dong: {}", scale);
                    eprintln!("Dinging: {}", scale * 2);
                    ding_addr.send(Ding(scale * 2))?;
                }
                ("/start", &[OscType::Int(seed)]) => {
                    eprintln!("Start: {}", seed);
                    pierce_addr.send(Pierce::new(seed / 2, seed * 2))?;
                }
                _ => {}
            },
        }
    }

    Ok(())
}
