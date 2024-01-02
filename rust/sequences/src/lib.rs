use delux_proto::sequencer::{
    self,
    server::{Sequencer, SequencerServer},
    Note, SequenceRequest,
};
use futures::stream::StreamExt;
use tonic::Response as TonicResponse;

///
pub fn create_server() -> SequencerServer<impl Sequencer> {
    SequencerServer::new(SequencerImpl::default())
}

#[derive(Default)]
struct SequencerImpl {}

#[tonic::async_trait]
impl Sequencer for SequencerImpl {
    type GenerateSequenceStream = sequencer::NoteStream;

    async fn generate_sequence(
        &self,
        request: tonic::Request<SequenceRequest>,
    ) -> sequencer::Response<Self::GenerateSequenceStream> {
        tracing::info!("Got a request from {:?}", request.remote_addr());
        let (_metadata, _extensions, sequence_request) = request.into_parts();
        tracing::debug!("sequence length {:?}", sequence_request.length);

        let notes = futures::stream::iter(1..sequence_request.length)
            .map(|i| Note {
                freq: (i * 20) as f64,
                length: 1.0,
                amp: 0.5,
            })
            .map(Ok);

        Ok(TonicResponse::new(Box::pin(notes)))
    }
}
