defmodule HolidayAppWeb.UserSocket do
  use Phoenix.Socket

  alias Guardian.Phoenix.Socket

  channel "holiday:*", HolidayAppWeb.HolidayChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket)

  def connect(%{"token" => token}, socket) do
    case Socket.authenticate(socket, HolidayAppWeb.Guardian, token) do
      {:ok, socket} ->
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  def id(socket) do
    user = Socket.current_resource(socket)
    "user_socket:#{user.id}"
  end
end
