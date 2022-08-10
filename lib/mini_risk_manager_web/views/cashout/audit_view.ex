defmodule MiniRiskManagerWeb.Cashout.AuditView do
  use MiniRiskManagerWeb, :view

  def render("200.json", %{result: result}), do: %{is_valid: result}
end
