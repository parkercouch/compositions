use std::time::Duration;
use async_std::stream::StreamExt;
use async_std::task;
use async_osc::{prelude::*, OscSocket, OscPacket, OscType, Error, Result};

use structopt::StructOpt;

#[derive(Debug, StructOpt)]
#[structopt(name = "example", about = "An example of StructOpt usage.")]
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

    /// Which port to connect to (SC listening port)
    #[structopt(short = "p", long = "port", default_value = "57120")]
    port: u32,
}

#[async_std::main]
async fn main() -> async_osc::Result<()> {
    let opt = Opt::from_args();

    let socket = OscSocket::bind("127.0.0.1:8080").await?;
    socket.connect(format!("{}:{}", "127.0.0.1", opt.port)).await?;

    if opt.debug {
        println!("Options: {:#?}", opt);
        println!("Connection: {:#?}", socket);
    }

    for i in 1..=opt.notes {
        task::sleep(Duration::from_millis(opt.wait)).await;
        socket.send(("/ding", (i,))).await?;
    }

    Ok(())
}

