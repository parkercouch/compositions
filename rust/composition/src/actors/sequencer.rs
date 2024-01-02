//! Reach out to sequencer service

use std::sync::Arc;

use async_std::stream::StreamExt;
use derive_new::new;
use mobc::async_trait;
use xactor::*;

use super::messenger::{Message, Messenger};

#[message]
#[derive(new)]
pub struct Sequence {
    ///
    pub length: u8,
}

#[derive(new)]
pub struct Sequencer {
    osc_messenger: Addr<Messenger>,
    tokio_runtime: Arc<tokio::runtime::Runtime>,
}

impl Actor for Sequencer {}

use delux_proto::sequencer::{client, SequenceRequest};

#[async_trait]
impl Handler<Sequence> for Sequencer {
    async fn handle(&mut self, _ctx: &mut Context<Self>, sequence: Sequence) {
        println!("from outside spawned sequencer task");
        let osc_messenger = self.osc_messenger.clone();
        let mut note_stream = self.tokio_runtime.block_on(async move {
            println!("from inside spawned sequencer task");
            let mut sequencer = client::SequencerClient::connect("grpc://127.0.0.1:3000")
                .await
                .expect("couldn't connect to sequencer service");
            println!("connected to sequencer service");

            let request = SequenceRequest {
                name: "test".into(),
                length: sequence.length as i32,
            };

            let note_stream = sequencer
                .generate_sequence(request)
                .await
                .expect("sequencer service couldn't generate sequence")
                .into_inner();

            println!("got sequence");
            note_stream
        });

        while let Some(Ok(note)) = note_stream.next().await {
            println!("sending sequencer note to sc: {:?} {:?}", note.length, note.freq);
            osc_messenger
                .send(Message::new("/piercing", vec![note.length, note.freq]))
                .expect("couldn't send osc message");
        }
    }
}
