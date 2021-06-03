//! osc

use derive_new::new;
use mobc::{async_trait, Manager};

pub async fn create_osc_connection_pool(
    send_port: u32,
    recv_port: u32,
) -> anyhow::Result<(mobc::Pool<OscSenderManager>, async_osc::OscSocket)> {
    let listener_socket = async_osc::OscSocket::bind(format!("127.0.0.1:{}", recv_port)).await?;
    let manager = OscSenderManager::new(send_port);
    let sender_pool = mobc::Pool::builder().max_open(20).build(manager);
    Ok((sender_pool, listener_socket))
}

#[derive(new)]
pub struct OscSenderManager {
    send_port: u32,
}

#[async_trait]
impl Manager for OscSenderManager {
    type Connection = async_osc::OscSender;
    type Error = async_osc::Error;

    async fn connect(&self) -> Result<Self::Connection, Self::Error> {
        // We are only sending so bind to whatever port is available
        let socket = async_osc::OscSocket::bind("127.0.0.1:0").await?;
        socket
            .connect(format!("{}:{}", "127.0.0.1", self.send_port))
            .await?;

        Ok(socket.sender())
    }

    async fn check(&self, conn: Self::Connection) -> Result<Self::Connection, Self::Error> {
        Ok(conn)
    }
}
