//! Blah

use derive_new::new;
use mobc::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
#[derive(new)]
pub struct Blah {
    scale: f32,
    length: i32,
}

#[derive(new)]
pub struct Blaher {
    pool: mobc::Pool<OscSenderManager>,
}

impl Actor for Blaher {}

#[async_trait]
impl Handler<Blah> for Blaher {
    async fn handle(&mut self, _ctx: &mut Context<Self>, blah: Blah) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/blah", (blah.scale, blah.length)))
            .await
            .expect("couldn't send osc message");
    }
}
