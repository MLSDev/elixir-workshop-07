import { Socket } from "phoenix"

class Chat {
  constructor() {
    this.socket = null
    this.channel = null
  }

  start() {
    let token = $("meta[name=user_token]").attr("content")
    if (!token)
      return;

    let holidayId = $("#holiday").data("id")
    if (!holidayId)
      return;

    this.socket = this.connectSocket(token)

    let topic = "holiday:" + holidayId
    this.channel = this.socket.channel(topic, {})

    let chatInput = $("#chat-input")

    chatInput.keypress((event) => {
      if (event.keyCode === 13) {
        this.channel.push("new_msg", {body: chatInput.val()})
        chatInput.val("")
      }
    })

    this.channel.on("new_msg", payload => {
      this.appendMessage(`[${payload.user}] ${payload.body}`)
    })

    this.channel.on("user_joined", payload => {
      this.appendMessage(`<i>[${payload.user}] joined!</i>`)
    })

    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  connectSocket(token) {
    let socket = new Socket("/socket", {
      params: {token: token},
      logger: (kind, msg, data) => { console.log(`${kind} : ${msg}`, data) }
    });
    socket.onError(() => console.log("There was an error with the connection!"));
    socket.onClose(() => console.log("Connection dropped"));

    socket.connect();
    return socket;
  }

  appendMessage(message) {
    $("#messages").append(`
      <li class="unstyled">
        ${message}
      </li>
    `)
    $("#messages-wrapper").animate({
      scrollTop: $('#messages-wrapper')[0].scrollHeight - $('#messages-wrapper')[0].clientHeight
    }, 100)
  }
}

export default Chat
