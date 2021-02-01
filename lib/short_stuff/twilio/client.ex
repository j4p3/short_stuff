defmodule Twilio.Client do
  use Tesla

  @api_version "v1"
  @services_path "Services"
  @notifications_path "Notifications"
  @bindings_path "Bindings"
  @service_id "ISb54d8f2d3286a8e48a1e15b46f99e398"

  plug Tesla.Middleware.BaseUrl, "https://notify.twilio.com"
  plug Tesla.Middleware.BasicAuth, %{username: "AC90d8a6a8c2d311e28e76ebf0e1da05d8", password: "48dfd5866b5f732a5e49b444d02c82ea"}
  plug Tesla.Middleware.Json

  def broadcast(message) do
    post(path(@notifications_path), %{
      ToBinding: %{binding_type: "sms"},
      Tag: "all",
      Body: message
    })
  end

  defp path(endpoint) do
    "/#{@api_version}/#{@services_path}/#{@service_id}/#{endpoint}"
  end
end
