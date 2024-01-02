//! pierce

use async_trait::async_trait;
use derive_new::new;
use xactor::*;

use crate::actors::messenger::Messenger;

#[message]
#[derive(new, Debug)]
pub struct Pierce {
    scale: i32,
    length: i32,
}

#[async_trait]
impl Handler<Pierce> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, pierce: Pierce) {
        self.get_sender()
            .await
            .send(("/piercing", (pierce.scale, pierce.length)))
            .await
            .expect("couldn't send osc message");
    }
}
