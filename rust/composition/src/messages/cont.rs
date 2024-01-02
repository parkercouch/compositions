//! Cont

use async_trait::async_trait;
use derive_new::new;
use xactor::*;

use crate::actors::messenger::Messenger;

#[message]
#[derive(new, Debug)]
pub struct Continue {
    seed: i32,
    other: i32,
}

#[async_trait]
impl Handler<Continue> for Messenger {
    async fn handle(&mut self, _ctx: &mut Context<Self>, cont: Continue) {
        self.get_sender()
            .await
            .send(("/continue", (cont.seed, cont.other)))
            .await
            .expect("couldn't send osc message");
    }
}
