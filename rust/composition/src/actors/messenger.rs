//! Generic Message for my SC setup

use derive_new::new;
use mobc::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
#[derive(new, Debug)]
pub struct Message {
    pub command: String,
    pub param_a: f64,
    pub param_b: f64,
}

#[derive(new)]
pub struct Messenger {
    pool: mobc::Pool<OscSenderManager>,
}

impl Actor for Messenger {}

#[async_trait]
impl Handler<Message> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, message: Message) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        dbg!(&message);
        socket
            .send((message.command, (message.param_a, message.param_b)))
            .await
            .expect("couldn't send osc message");
    }
}

#[message]
#[derive(Debug)]
pub struct Dingg(pub i32);

#[async_trait]
impl Handler<Dingg> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, message: Dingg) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        dbg!(&message);
        socket
            .send(("/ding", (message.0,)))
            .await
            .expect("couldn't send osc message");
    }
}

#[message]
#[derive(new, Debug)]
pub struct Piercee {
    scale: i32,
    length: i32,
}

#[async_trait]
impl Handler<Piercee> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, pierce: Piercee) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/piercing", (pierce.scale, pierce.length)))
            .await
            .expect("couldn't send osc message");
    }
}

#[message]
#[derive(new, Debug)]
pub struct Continue {
    seed: i32,
    other: i32,
}

#[async_trait]
impl Handler<Continue> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, cont: Continue) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/continue", (cont.seed, cont.other)))
            .await
            .expect("couldn't send osc message");
    }
}
