import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})


socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("marty", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


document.getElementById("hello").addEventListener("click", e => {
  channel.push("hello", {})
})

let celebrateSelect = document.getElementById("celebrate-time")
document.getElementById("celebrate").addEventListener("click", e => {
  channel.push("celebrate", {duration: celebrateSelect.value})
})

const directions = ["forward", "back", "left", "right"]

for (let d of directions) {
  let button = document.getElementById(`move-${d}`)
  button.addEventListener("click", e => {
    channel.push("walk", {direction: d})
  })
}


let connectedElement = document.getElementById("connected")
let batteryElement = document.getElementById("battery")

let connectedState = martyState => {
  connectedElement.innerHTML = "Connected"
  if(martyState.battery != null) {
    batteryElement.innerHTML = martyState.battery.toFixed(3)
  }
}

let disconnectedState = () => {
  connectedElement.innerHTML = "Disconnected"
  batteryElement.innerHTML = "?"
}

channel.on("marty_state", martyState => {
  if(martyState["connected?"]) {
    connectedState(martyState)
  }  else {
    disconnectedState()
  }
})


export default socket
