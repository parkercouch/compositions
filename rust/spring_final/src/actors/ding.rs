//! Ding

use derive_new::new;
use mobc::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
pub struct Ding(pub i32);

#[derive(new)]
pub struct Dinger {
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
