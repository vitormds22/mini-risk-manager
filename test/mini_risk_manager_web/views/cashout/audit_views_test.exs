defmodule MiniRiskManagerWeb.Cashout.AuditViewsTest do
  use MiniRiskManagerWeb.ConnCase, async: true

  alias MiniRiskManagerWeb.Cashout.AuditView

  test "render 200.json and return is_valid" do
    assert %{is_valid: true} == AuditView.render("200.json",%{result: true})
  end
end
