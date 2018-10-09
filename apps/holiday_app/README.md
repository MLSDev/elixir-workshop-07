# HolidayApp

Internal MLSDev Elixir Workshop #06 - Chat


## Up and running

* Clone project
* `mix deps.get`
* Setup `.env` with auth providers credentials (see `.env.example` for reference)
* Setup `config/*.exs` files (pay attention to secret config examples)
* `mix ecto.setup` # create, migrate and seed database
* `mix test`
* `source .env`
* `iex -S mix phx.server`
* Open [http://localhost:4000](http://localhost:4000) in your browser


## Docs

* `mix docs`
* `open doc/index.html`


## Coverage

* `mix test --cover`

HTML output:
* `mix coveralls.html`
* `open cover/excoveralls.html`


## Seeds

Check `priv/repo/seeds.exs` file


## Commits and branches

* Initial commit
  - Copy of last commit of the [previous](https://github.com/MLSDev/elixir-workshop-05) Elixir Workshop

* [**webpack**](https://github.com/MLSDev/elixir-workshop-06/tree/webpack) branch
  - Replace Brunch with Webpack
  - Getting ready for Phoenix 1.4

* [**chat**](https://github.com/MLSDev/elixir-workshop-06/tree/chat) branch
  - Simple chat on Holidays using [Phoenix Channels](https://hexdocs.pm/phoenix/channels.html)

* [**resource**](https://github.com/MLSDev/elixir-workshop-06/tree/resource) branch
  - Attempt to extract ResourceController from User and Holiday controllers
