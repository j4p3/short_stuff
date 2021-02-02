defmodule Twilio.Client do
  use Tesla

  @api_version "v1"
  @services_path "Services"
  @notifications_path "Notifications"
  @bindings_path "Bindings"
  @service_id "asdf"

  plug Tesla.Middleware.BaseUrl, "https://notify.twilio.com"
  plug Tesla.Middleware.BasicAuth, %{username: "asdf", password: "asdf"}
  plug Tesla.Middleware.JSON

  def broadcast(message) do
    post(path(@notifications_path), %{
      ToBinding: %{binding_type: "sms"},
      Tag: "all",
      Body: message
    })
  end

  def path(endpoint) do
    "/#{@api_version}/#{@services_path}/#{@service_id}/#{endpoint}"
  end
end
