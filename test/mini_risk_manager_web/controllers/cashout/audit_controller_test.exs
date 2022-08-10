defmodule MiniRiskManagerWeb.Cashout.AuditControllerTest do
  use MiniRiskManagerWeb.ConnCase

  import Mox
  setup :verify_on_exit!

  describe "POST /api/cashout" do
    test "when the params is valid return model_response", %{conn: conn} do
      params = string_params_for(:mini_risk_manager_audit_input_params)

      expect(
        MiniRiskManager.Ports.ModelPortMock,
        :call_model,
        fn _ ->
          {:ok, %{is_valid: true}}
        end
      )

      assert %{"is_valid" => true} =
               json_response(post(conn, Routes.audit_path(conn, :validate, params)), :ok)
    end

    test "when the params is invalid return error", %{conn: conn} do
      assert %{"type" => "srn:error:invalid"} =
               json_response(post(conn, Routes.audit_path(conn, :validate, %{})), :bad_request)
    end

    test "when the params is invalid return error and request failed", %{conn: conn} do
      params = string_params_for(:mini_risk_manager_audit_input_params)

      expect(
        MiniRiskManager.Ports.ModelPortMock,
        :call_model,
        fn _ ->
          {:error, :request_failed}
        end
      )

      assert %{"type" => "srn:error:internal_server_error"} =
               json_response(
                 post(conn, Routes.audit_path(conn, :validate, params)),
                 :internal_server_error
               )
    end
  end
end
