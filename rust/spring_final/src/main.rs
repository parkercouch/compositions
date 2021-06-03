use async_osc::prelude::*;
use async_osc::{OscPacket, OscType};
use async_std::task;
use async_trait::async_trait;
use futures::StreamExt;
use mobc::Manager;
use std::result::Result;
use structopt::StructOpt;
use xactor::*;

mod ding;

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

    let (osc_sender_pool, mut osc_listener) = create_osc_connection_pool(&opt).await?;

    let addr = Supervisor::start(move || Dinger::new(osc_sender_pool.clone())).await?;

    // Test send
    for i in 1..=opt.notes {
        task::sleep(std::time::Duration::from_millis(opt.wait)).await;
        addr.send(Ding(i))?;
    }

    // Test recv
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
                    addr.send(Ding(scale * 2))?;
                }
                _ => {}
            },
        }
    }

    Ok(())
}

async fn create_osc_connection_pool(
    opt: &Opt,
) -> anyhow::Result<(mobc::Pool<OscSenderManager>, async_osc::OscSocket)> {
    let listener_socket =
        async_osc::OscSocket::bind(format!("127.0.0.1:{}", opt.recv_port)).await?;
    let manager = OscSenderManager::new(opt.send_port);
    let sender_pool = mobc::Pool::builder().max_open(20).build(manager);
    Ok((sender_pool, listener_socket))
}

#[message]
struct Ding(i32);

use derive_new::new;

#[derive(new)]
struct Dinger {
    pool: mobc::Pool<OscSenderManager>,
}

impl Actor for Dinger {}

#[async_trait]
impl Handler<Ding> for Dinger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, ding: Ding) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/ding", (ding.0,)))
            .await
            .expect("couldn't send osc message");
    }
}

#[derive(new)]
struct OscSenderManager {
    send_port: u32,
}

#[async_trait]
impl Manager for OscSenderManager {
    type Connection = async_osc::OscSender;
    type Error = async_osc::Error;

    async fn connect(&self) -> Result<Self::Connection, Self::Error> {
        // We are only sending so bind to whatever port is available
        let socket = async_osc::OscSocket::bind("127.0.0.1:0").await?;
        socket
            .connect(format!("{}:{}", "127.0.0.1", self.send_port))
            .await?;

        Ok(socket.sender())
    }

    async fn check(&self, conn: Self::Connection) -> Result<Self::Connection, Self::Error> {
        Ok(conn)
    }
}
