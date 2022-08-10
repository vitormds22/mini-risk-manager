defmodule MiniRiskManagerWeb.ErrorView do
  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".

  @spec render(String.t(), map()) :: map()
  def render("400.json", _assigns) do
    %{type: "srn:error:invalid"}
  end

  def render("500.json", _assigns) do
    %{type: "srn:error:internal_server_error"}
  end

  @spec template_not_found(String.t(), map()) :: map()
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
