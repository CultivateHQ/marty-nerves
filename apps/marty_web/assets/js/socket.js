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




export default socket
