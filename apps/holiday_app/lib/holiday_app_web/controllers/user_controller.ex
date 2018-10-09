defmodule HolidayAppWeb.UserController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Users
  alias HolidayApp.Users.{User, UserPolicy}

  use HolidayAppWeb.ResourceController,
    schema: User,
    context: Users

  plug HolidayAppWeb.Plugs.Authorize,
    policy: UserPolicy,
    params_fun: &(__MODULE__.fetch_params/2)

  @impl true
  def delete(conn, _params), do: conn

  def fetch_params(_conn, %{"id" => id}) do
    [user: Users.get_resource!(id)]
  end
  def fetch_params(_, _), do: []
end
