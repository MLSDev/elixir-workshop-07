defmodule HolidayAppWeb.HolidayController do
  use HolidayAppWeb, :controller

  alias HolidayApp.Holidays
  alias HolidayApp.Holidays.{Holiday, HolidayPolicy}  

  use HolidayAppWeb.ResourceController,
    schema: Holiday,
    context: Holidays

  plug HolidayAppWeb.Plugs.Authorize,
    policy: HolidayPolicy,
    params_fun: &(__MODULE__.fetch_params/2)

  @impl true
  def index(conn, params) do
    start_date = params["start_date"]
    end_date = params["end_date"]
    {:ok, holidays, start_date, end_date} = Holidays.list_holidays(start_date, end_date)
    render(conn, :index, resources: holidays, start_date: start_date, end_date: end_date)
  end

  def fetch_params(_conn, %{"id" => id}) do
    [holiday: Holidays.get_resource!(id)]
  end
  def fetch_params(_, _), do: []
end
