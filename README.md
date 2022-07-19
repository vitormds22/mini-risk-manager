# MiniRiskManager

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## To do list

  * Criar projeto com mix phx.new :heavy_check_mark:
  * Configurar credo e dialyzer :heavy_check_mark:
  * Criar tabela audits :heavy_check_mark:
  * Criar model audit :heavy_check_mark:
  * Criar port/adpter ModelPort :man_technologist:
  * Criar port/adpter BalanceBlockerPort
  * Criar aggregator para audit
  * Criar repository para audit
  * Criar command para bloquear saldo
  * Criar job para bloquear saldo
  * Criar command para validar o risco
  * Criar rota de serviço