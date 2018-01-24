let img = document.getElementById("cam")
let socket = null


const connectToWebsocket = img => {
  let l = window.location
  let url = `ws://${l.hostname}:4500`

  socket = new WebSocket(url)
  socket.onopen = () => {
    console.log("open")
  }

  socket.onclose = () => {
    console.log("close", socket)
  }

  socket.onerror = errorEvent => {
    console.log("error", errorEvent)
  }

  socket.onmessage = messageEvent => {

    let imageUrl = URL.createObjectURL(messageEvent.data);
    img.src = imageUrl
  }
}

if (img != null) {
  connectToWebsocket(img)
  setInterval(() => {
    if (socket != null && socket.readyState == 3) {
      connectToWebsocket(img)
    }
  }, 5000)
}
