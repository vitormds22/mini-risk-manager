defmodule MiniRiskManagerAdapters.Tesla do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Refactor.LongQuoteBlocks

  defmacro __using__(base_url) do
    quote location: :keep do
      use Tesla
      require Logger

      plug Tesla.Middleware.BaseUrl, unquote(base_url)
      plug Tesla.Middleware.JSON

      alias MiniRiskManager.Ports.Types.ModelResponse
      alias MiniRiskManager.Ports.Types.ModelInput
    end
  end
end
