import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})


socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("marty", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

let speedSelect = document.getElementById("speed")
let stepsSelect = document.getElementById("steps")

let kickSpeedSelect = document.getElementById("kick-speed")
let kickTwistSelect = document.getElementById("kick-twist")


document.getElementById("hello").addEventListener("click", e => {
  channel.push("hello", {})
})

document.getElementById("celebrate").addEventListener("click", e => {
  channel.push("celebrate", {speed: speedSelect.value})
})

let kick  = foot => {
  let kickSpeed = kickSpeedSelect.value
  let kickTwist = kickTwistSelect.value
  channel.push("kick", {foot: foot, speed: kickSpeed, twist: kickTwist})
}

let circleDance = side => {
  let speed = speedSelect.value
  channel.push("circle_dance", {side: side, speed: speed})
}

document.getElementById("kick-left").addEventListener("click", e => {
  kick("left")
})

document.getElementById("kick-right").addEventListener("click", e => {
  kick("right")
})

document.getElementById("tap-left").addEventListener("click", e => {
  channel.push("tap_foot", {foot: "left"})
})

document.getElementById("tap-right").addEventListener("click", e => {
  channel.push("tap_foot", {foot: "right"})
})

document.getElementById("circle-left").addEventListener("click", e => {
  circleDance("left")
})

document.getElementById("circle-right").addEventListener("click", e => {
  circleDance("right")
})



const directions = ["forward-left", "forward", "forward-right",
                    "side-left", "side-right",
                    "back-left", "back", "back-right"]

for (let d of directions) {
  let button = document.getElementById(`move-${d}`)
  button.addEventListener("click", e => {
    channel.push("walk", {
      direction: d,
      speed: speedSelect.value,
      steps: stepsSelect.value
    })
  })
}

document.getElementById("move-stop").addEventListener("click", e => {
  channel.push("stop", {})
})


let connectedElement = document.getElementById("connected")
let batteryElement = document.getElementById("battery")
let chatElement = document.getElementById("chat")

let connectedState = martyState => {
  connectedElement.innerHTML = "Connected"
  if(martyState.battery != null) {
    batteryElement.innerHTML = martyState.battery.toFixed(3)
  }
}

let disconnectedState = () => {
  connectedElement.innerHTML = "Disconnected"
  batteryElement.innerHTML = "?"
  chatElement.innerHTML = ""
}

channel.on("marty_state", martyState => {
  if(martyState["connected?"]) {
    connectedState(martyState)
  }  else {
    disconnectedState()
  }
})

channel.on("marty_chat", chat => {
  chatElement.innerHTML = chat.msg
})
