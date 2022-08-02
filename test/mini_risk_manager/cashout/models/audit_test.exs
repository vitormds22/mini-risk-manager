defmodule MiniRiskManager.Cashout.Models.AuditTest do
  @moduledoc false

  use MiniRiskManager.DataCase, async: true

  alias MiniRiskManager.Cashout.Models.Audit
  alias MiniRiskManager.Cashout.Models.Audit.InputParams

  @err_cant_be_blank "can't be blank"

  setup do
    params = string_params_for(:mini_risk_manager_audit)

    %{params: params}
  end

  describe "create_changeset/1" do
    test "when missing required attrs return a invalid changeset" do
      changeset = Audit.create_changeset(%{})

      assert errors_on(changeset) == %{
               input_params: [@err_cant_be_blank],
               is_valid: [@err_cant_be_blank],
               model_input: [@err_cant_be_blank],
               model_response: [@err_cant_be_blank]
             }
    end

    test "when passed all required attrs return a valid changeset", %{params: params} do
      assert {:ok, %Audit{input_params: input_params} = audit} =
               params
               |> Audit.create_changeset()
               |> Repo.insert()

      assert audit.is_valid == params["is_valid"]
      assert audit.model_input == params["model_input"]
      assert audit.model_response == params["model_response"]

      assert input_params.account.balance == params["input_params"]["account"]["balance"]
      assert input_params.amount == params["input_params"]["amount"]

      assert %InputParams{} = input_params
    end

    test "with invalid types" do
      params = %{
        is_valid: "string",
        model_input: "string",
        model_response: "string",
        input_params: "string"
      }

      changeset = Audit.create_changeset(params)

      assert errors_on(changeset) == %{
               input_params: ["is invalid"],
               is_valid: ["is invalid"],
               model_input: ["is invalid"],
               model_response: ["is invalid"]
             }
    end

    test "when not change operation columns", %{params: params} do
      params = Map.put(params, "input_params", nil)
      %Ecto.Changeset{changes: changes} = Audit.create_changeset(params)

      refute Map.has_key?(changes, :operation_id)
      refute Map.has_key?(changes, :operation_type)
    end

    test "when change operation columns", %{params: %{"input_params" => input_params} = params} do
      %Ecto.Changeset{changes: changes} = Audit.create_changeset(params)

      assert changes.operation_id == input_params["operation_id"]
      assert changes.operation_type == input_params["operation_type"]
    end

    test "when operation id and type is unique", %{params: params} do
      params
      |> Audit.create_changeset()
      |> Repo.insert()

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  operation_id:
                    {"has already been taken",
                     [
                       constraint: :unique,
                       constraint_name: "audits_operation_id_operation_type_index"
                     ]}
                ],
                valid?: false
              }} =
               params
               |> Audit.create_changeset()
               |> Repo.insert()
    end
  end
end
