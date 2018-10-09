defmodule HolidayAppWeb.ResourceController do
  @moduledoc """
  """

  @callback index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback new(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback edit(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  @callback delete(Plug.Conn.t(), map()) :: Plug.Conn.t()

  @optional_callbacks index: 2,
    new: 2,
    create: 2,
    show: 2,
    edit: 2,
    update: 2,
    delete: 2

  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    context = Keyword.get(opts, :context)

    quote do
      @behaviour HolidayAppWeb.ResourceController

      action_fallback HolidayAppWeb.FallbackController

      def index(conn, params) do
        resources = unquote(context).list_resources(params)
        render(conn, :index, resources: resources)
      end

      def new(conn, _params) do
        changeset = unquote(context).change_resource(%unquote(schema){})
        render(conn, :new, changeset: changeset)
      end

      def create(conn, params) do
        resource_params = params[resource_name()]
        case unquote(context).create_resource(resource_params) do
          {:ok, resource} ->
            conn
            |> put_flash(:info, "#{humanized_resource_name()} created successfully.")
            |> redirect(to: resource_path(conn, :show, resource))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :new, changeset: changeset)
        end
      end

      def show(conn, %{"id" => id} = _params) do
        resource = unquote(context).get_resource!(id)
        render(conn, :show, resource: resource)
      end

      def edit(conn, %{"id" => id}) do
        resource = unquote(context).get_resource!(id)
        changeset = unquote(context).change_resource(resource)
        render(conn, :edit, resource: resource, changeset: changeset)
      end

      def update(conn, %{"id" => id} = params) do
        resource = unquote(context).get_resource!(id)
        resource_params = params[resource_name()]

        case unquote(context).update_resource(resource, resource_params) do
          {:ok, resource} ->
            conn
            |> put_flash(:info, "#{humanized_resource_name()} updated successfully.")
            |> redirect(to: resource_path(conn, :show, resource))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, :edit, resource: resource, changeset: changeset)
        end
      end

      def delete(conn, %{"id" => id}) do
        resource = unquote(context).get_resource!(id)
        {:ok, _resource} = unquote(context).delete_resource(resource)

        conn
        |> put_flash(:info, "#{humanized_resource_name()} deleted successfully.")
        |> redirect(to: resource_path(conn, :index))
      end

      def resource_name do
        Phoenix.Naming.resource_name(unquote(schema))
      end

      def humanized_resource_name do
        Phoenix.Naming.humanize(resource_name())
      end

      def resource_path(conn, action, resource) do
        apply(
          HolidayAppWeb.Router.Helpers,
          String.to_atom("#{resource_name()}_path"),
          [conn, action, resource]
        )
      end

      def resource_path(conn, action) do
        apply(
          HolidayAppWeb.Router.Helpers,
          String.to_atom("#{resource_name()}_path"),
          [conn, action]
        )
      end

      defoverridable HolidayAppWeb.ResourceController
    end
  end
end
