defmodule HolidayApp.ResourceContext do
  @callback list_resources(params :: map() | nil) :: [any()]
  @callback get_resource!(id :: String.t() | number()) :: any()
  @callback create_resource(attrs :: map()) :: {:ok, any()} | {:error, any()}
  @callback update_resource(struct :: struct(), attrs :: map()) :: {:ok, any()} | {:error, any()}
  @callback delete_resource(struct :: struct()) :: {:ok, any()} | {:error, any()}
  @callback change_resource(struct :: struct()) :: struct()

  @optional_callbacks list_resources: 1,
    "get_resource!": 1,
    create_resource: 1,
    update_resource: 2,
    delete_resource: 1,
    change_resource: 1
end
