//! Blah

use async_trait::async_trait;
use derive_new::new;
use xactor::*;

use crate::actors::messenger::Messenger;

#[message]
#[derive(new)]
pub struct Blah {
    scale: f32,
    length: i32,
}

#[async_trait]
impl Handler<Blah> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, blah: Blah) {
        self.get_sender()
            .await
            .send(("/blah", (blah.scale, blah.length)))
            .await
            .expect("couldn't send osc message");
    }
}
