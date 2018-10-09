defmodule HolidayAppWeb.ViewHelpers do
  use Phoenix.HTML

  alias HolidayApp.Users.{User, Role, UserPolicy}
  alias HolidayApp.Holidays.HolidayPolicy

  def nav_link(conn, text, opts) do
    active = (Keyword.get(opts, :to) == conn.request_path)

    ~E"""
      <li class="nav-item <%= if active, do: ~s(active) %>">
        <%= link text, Keyword.merge(opts, class: "nav-link") %>
      </li>
    """
  end

  def alert(message, class \\ :info) do
    ~E"""
      <div class="alert alert-<%= to_string(class) %> alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    """
  end

  def flash_alert(conn, key, class \\ :info) do
    message = Phoenix.Controller.get_flash(conn, key)
    if message, do: alert(message, class)
  end

  def current_path?(conn, path) do
    conn.request_path == path
  end

  def current_token(conn) do
    HolidayAppWeb.Guardian.Plug.current_token(conn)
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end
  
  def logged_in?(conn) do
    current_user(conn) != nil
  end

  def admin?(conn) do
    user = current_user(conn)
    user && Role.role?(user, :admin)
  end

  def is_current_user?(conn, user) do
    user == current_user(conn)
  end

  def can_update_user?(conn, user) do
    Bodyguard.permit?(
      UserPolicy,
      :update,
      current_user(conn),
      user: user
    )
  end

  def user_display_name(%User{name: name}) when not is_nil(name), do: name
  def user_display_name(%User{email: email}), do: email

  def can_create_holiday?(conn) do
    check_holiday_policy(conn, nil, :create)
  end

  def can_update_holiday?(conn, holiday) do
    check_holiday_policy(conn, holiday, :update)
  end

  def can_delete_holiday?(conn, holiday) do
    check_holiday_policy(conn, holiday, :delete)
  end

  defp check_holiday_policy(conn, holiday, action) do
    Bodyguard.permit?(
      HolidayPolicy,
      action,
      current_user(conn),
      holiday: holiday
    )
  end
end
