pub mod sequencer {
    tonic::include_proto!("sequencer");

    pub use sequencer_server as server;
    pub use sequencer_client as client;

    pub type NoteStream = std::pin::Pin<Box<dyn futures::Stream<Item = Result<Note, tonic::Status>> + Send>>;
    pub type Response<T> = Result<tonic::Response<T>, tonic::Status>;
}
