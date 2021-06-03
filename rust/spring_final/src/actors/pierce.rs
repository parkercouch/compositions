//! pierce

use derive_new::new;
use mobc::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
#[derive(new)]
pub struct Pierce {
    scale: i32,
    length: i32,
}

#[derive(new)]
pub struct Piercer {
    pool: mobc::Pool<OscSenderManager>,
}

impl Actor for Piercer {}

#[async_trait]
impl Handler<Pierce> for Piercer {
    async fn handle(&mut self, _ctx: &mut Context<Self>, pierce: Pierce) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/piercing", (pierce.scale, pierce.length)))
            .await
            .expect("couldn't send osc message");
    }
}
