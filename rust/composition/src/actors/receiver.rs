//! Deals with incoming packets, recv loop

use async_osc::{prelude::OscMessageExt, OscPacket, OscSocket, OscType};
use async_std::task;
use async_trait::async_trait;
use derive_new::new;
use futures::stream::StreamExt;
use xactor::*;

use crate::messages::{cont::Continue, ding::Ding, pierce::Pierce};

use super::messenger::Messenger;

#[derive(new)]
pub struct Receiver {
    osc_listener: OscSocket,
    messenger: Addr<Messenger>,
}

impl Receiver {}

impl Actor for Receiver {}

#[message(result = "Result<()>")]
#[derive(Debug)]
pub struct Listen;

#[async_trait]
impl Handler<Listen> for Receiver {
    async fn handle(&mut self, _ctx: &mut Context<Self>, _message: Listen) -> Result<()> {
        while let Some(packet) = self.osc_listener.next().await {
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
                        self.messenger.send(Ding(scale * 2))?;
                    }
                    ("/pierce", &[OscType::Int(scale), OscType::Int(length)]) => {
                        self.messenger.send(Pierce::new(scale, length))?;
                    }
                    ("/start", &[OscType::Int(seed), OscType::Int(other)]) => {
                        let messenger_addr = self.messenger.clone();
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
}
