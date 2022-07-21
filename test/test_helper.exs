Mox.defmock(MiniRiskManager.Ports.ModelPortMock, for: MiniRiskManager.Ports.ModelPort)
Mox.defmock(TeslaMock, for: Tesla.Adapter)

{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MiniRiskManager.Repo, :manual)
