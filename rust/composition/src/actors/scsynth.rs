//! SCSynth process

use std::process::Stdio;

use async_std::{process::Child, task::JoinHandle};

use async_trait::async_trait;
use xactor::*;

#[message]
pub struct Start {
    pub load_path: String,
    pub send_port: u32,
}

#[derive(Default)]
pub struct SCSynth {
    sclang: Option<JoinHandle<Child>>,
}

impl Actor for SCSynth {}

#[async_trait]
impl Handler<Start> for SCSynth {
    async fn handle(&mut self, _ctx: &mut Context<Self>, opt: Start) -> () {
        if self.sclang.is_some() {
            panic!("scsynth process already started");
        };

        self.sclang = Some(spawn(async move {
            load_sc_scripts(opt.send_port, opt.load_path)
        }));
    }
}

fn load_sc_scripts(send_port: u32, path: String) -> Child {
    async_std::process::Command::new("sclang")
        .arg("-r")
        .arg("-D")
        .arg("-u")
        .arg(send_port.to_string())
        .arg(path)
        .stdin(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .expect("scsynth failed to start")
}
