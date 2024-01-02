//! Generic Message for my SC setup

use derive_new::new;
use async_trait::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
#[derive(Debug)]
pub struct Message {
    command: String,
    params: Vec<f64>,
}

impl Message {
    pub fn new(command: impl Into<String>, params: Vec<impl Into<f64>>) -> Self {
        Self {
            command: command.into(),
            params: params.into_iter().map(Into::into).collect(),
        }
    }
}

#[derive(new)]
pub struct Messenger {
    osc_sender: mobc::Pool<OscSenderManager>,
}

impl Messenger {
    pub async fn get_sender(&self) -> mobc::Connection<OscSenderManager> {
        self.osc_sender
            .get()
            .await
            .expect("osc connection pool failed")
    }
}

impl Actor for Messenger {}

#[async_trait]
impl Handler<Message> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, message: Message) {
        self.get_sender()
            .await
            .send((message.command, message.params))
            .await
            .expect("couldn't send osc message");
    }
}
