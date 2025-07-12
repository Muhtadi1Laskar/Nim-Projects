import asyncnet, asyncdispatch, strutils

proc handleConnection(sock: AsyncSocket) {.async.} =
  let syn: string = await sock.recvLine()
  if syn.strip() == "SYN":
    echo "Server received SYN from the client"
    await sleepAsync(1000)

    echo "Server sending SYN-ACK to the client"
    await sock.send("SYN-ACK\n")

    let ack: string = await sock.recvLine()
    if ack.strip() == "ACK":
      echo "Server received ACK from the client"
    else:
      echo "Invalid response from client: ", ack.strip()

proc startServer() {.async.} =
  let server: AsyncSocket = newAsyncSocket()
  await server.bindAddr(Port(8080))
  server.listen()

  echo "Server started. Listening on :8080"

  while true:
    let client: AsyncSocket = await server.accept()
    asyncCheck handleConnection(client)

proc startClient() {.async.} =
  await sleepAsync(1000)  # Ensure server is up

  let client: AsyncSocket = newAsyncSocket()
  await client.connect("127.0.0.1", Port(8080))

  echo "Client sending SYN to the server"
  await client.send("SYN\n")

  let synAck: string = await client.recvLine()
  if synAck.strip() == "SYN-ACK":
    echo "Client received SYN-ACK from the server"
    await sleepAsync(1000)

    echo "Client sending ACK to the server"
    await client.send("ACK\n")

    echo "Handshake complete. Connection established"
  else:
    echo "Invalid response from the server: ", synAck.strip()

when isMainModule:
  asyncCheck startServer()
  asyncCheck startClient()
  runForever()
