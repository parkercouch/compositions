mod debugging;

#[tokio::main]
async fn main() {
    debugging::enable_tracing();

    let addr = std::net::SocketAddr::from(([127, 0, 0, 1], 3000));
    tracing::debug!("listening on {}", addr);
    hyper::Server::bind(&addr)
        .serve(tower::make::Shared::new(sequencer::create_server()))
        .await
        .expect("sequencer server crashed");
}
