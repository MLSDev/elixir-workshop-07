defmodule HolidayAppWeb.Channels.UserSocketTest do
  use HolidayAppWeb.ChannelCase, async: true

  alias HolidayAppWeb.UserSocket
  alias Guardian.Phoenix.Socket

  setup do
    user = insert(:user)
    {:ok, token, _claims} = HolidayAppWeb.Guardian.encode_and_sign(user)
    {:ok, token: token, user: user}
  end

  test "connect(params, socket) authenticates user with token", %{token: token} do
    {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert Socket.authenticated?(socket)
  end

  test "connect(params, socket) rejects user with invalid token" do
    assert :error == connect(UserSocket, %{"token" => "invalid_token"})
  end

  test "connect(params, socket) rejects user with no token" do
    assert :error == connect(UserSocket, %{})
  end

  test "id(socket) returns socket id based on user id", %{token: token, user: user} do
    {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert "user_socket:#{user.id}" == UserSocket.id(socket)
  end
end
