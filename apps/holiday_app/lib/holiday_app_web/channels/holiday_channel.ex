defmodule HolidayAppWeb.HolidayChannel do
  use HolidayAppWeb, :channel

  alias Guardian.Phoenix.Socket

  def join("holiday:" <> _holiday_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{}, socket}
  end

  def handle_in("new_msg", %{"body" => body} = _params, socket) do
    user = Socket.current_resource(socket)
    broadcast! socket, "new_msg", %{user: user.email, body: body}
    {:reply, :ok, socket}
  end

  def handle_info(:after_join, socket) do
    user = Socket.current_resource(socket)
    broadcast! socket, "user_joined", %{user: user.email}
    {:noreply, socket}
  end
end
