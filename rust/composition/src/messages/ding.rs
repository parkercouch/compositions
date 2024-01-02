//! Ding

use async_trait::async_trait;
use xactor::*;

use crate::actors::messenger::Messenger;

#[message]
#[derive(Debug, Clone)]
pub struct Ding(pub i32);

#[async_trait]
impl Handler<Ding> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, message: Ding) {
        self.get_sender()
            .await
            .send(("/ding", (message.0,)))
            .await
            .expect("couldn't send osc message");
    }
}
