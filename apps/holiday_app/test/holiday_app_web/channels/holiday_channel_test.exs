defmodule HolidayAppWeb.HolidayChannelTest do
  use HolidayAppWeb.ChannelCase, async: true

  setup do
    user = insert(:user, %{email: "mail@server.com"})
    holiday = insert(:holiday)
    socket = connect_user(user)
    {:ok, socket: socket, user: user, holiday: holiday}
  end

  describe "join" do
    test "replies with empty response", %{socket: socket, holiday: holiday} do
      assert {:ok, %{}, _socket} = subscribe_and_join(socket, "holiday:#{holiday.id}", %{})
    end

    test "broadcasts 'user_joined' message", %{socket: socket, holiday: holiday} do
      {:ok, %{}, _socket} = subscribe_and_join(socket, "holiday:#{holiday.id}", %{})
      assert_broadcast "user_joined", %{user: "mail@server.com"}
    end
  end

  describe "new_msg" do
    setup %{socket: socket, holiday: holiday} do
      {:ok, %{}, socket} = subscribe_and_join(socket, "holiday:#{holiday.id}", %{})
      {:ok, %{socket: socket}}
    end

    test "broadcasts 'new_msg' and replies :ok", %{socket: socket} do
      ref = push socket, "new_msg", %{"body" => "hello world"}
      assert_reply ref, :ok, _socket
      assert_broadcast "new_msg", %{user: "mail@server.com", body: "hello world"}
    end
  end

  defp connect_user(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(HolidayAppWeb.Guardian, user)
    {:ok, socket} = connect(HolidayAppWeb.UserSocket, %{token: token})
    socket
  end
end
