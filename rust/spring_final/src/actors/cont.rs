//! Cont

use derive_new::new;
use mobc::async_trait;
use xactor::*;

use crate::osc::OscSenderManager;

#[message]
#[derive(new)]
pub struct Continue {
    seed: i32,
    other: i32,
}

#[derive(new)]
pub struct Continuer {
    pool: mobc::Pool<OscSenderManager>,
}

impl Actor for Continuer {}

#[async_trait]
impl Handler<Continue> for Continuer {
    async fn handle(&mut self, _ctx: &mut Context<Self>, cont: Continue) {
        let socket = self.pool.get().await.expect("osc connection pool failed");
        socket
            .send(("/continue", (cont.seed, cont.other,)))
            .await
            .expect("couldn't send osc message");
    }
}
