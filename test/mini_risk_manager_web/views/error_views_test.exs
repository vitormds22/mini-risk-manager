defmodule MiniRiskManagerWeb.ErrorViewsTest do
  use MiniRiskManagerWeb.ConnCase, async: true

  import Phoenix.View

  describe "render/2" do
    test "with 400.json return a message" do
      assert render(MiniRiskManagerWeb.ErrorView, "400.json", []) == %{
             type: "srn:error:invalid"
           }
    end

    test "with 500.json return a message" do
      assert render(MiniRiskManagerWeb.ErrorView, "500.json", []) == %{
             type: "srn:error:internal_server_error"
           }
    end
  end
end
