defmodule HolidayAppWeb.UserView do
  use HolidayAppWeb, :view

  alias HolidayApp.Users.User

  def photo_url(%User{photo_url: nil}), do: "/images/no-photo.png"
  def photo_url(%User{photo_url: photo_url}), do: photo_url

  def provider(%User{provider: provider}), do: humanize(provider)

  def role(%User{role: role}), do: humanize(role)
end
