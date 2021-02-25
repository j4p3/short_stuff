defmodule Twilio do
  require Logger
  @api_version "v1"
  @services_path "Services"

  def create_binding(client, subscriber_id, subscriber_phone) do
    Tesla.post(client, uri("Bindings"),
    %{
      Identity: subscriber_id,
      BindingType: "sms",
      Address: subscriber_phone,
      Tags: ["shortstuff"]
    })
  end

  def broadcast(client, message) do
    body = %{
      Tag: "shortstuff",
      ToBinding: %{binding_type: "sms"},
      Body: message
    }
    Tesla.post(client, uri("Notifications"), body)
  end

  def client(opts \\ %{}) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://notify.twilio.com"},
      {Tesla.Middleware.BasicAuth, Map.merge(%{username: System.fetch_env!("TWILIO_ACCOUNT_ID"), password: System.fetch_env!("TWILIO_AUTH_TOKEN")}, opts)},
      {Tesla.Middleware.FormUrlencoded, encode: &Plug.Conn.Query.encode/1, decode: &Plug.Conn.Query.decode/1}
    ])
  end

  def log_response({:ok, response}) do
    Logger.info("Twilio responded with #{response.status}")
  end

  def log_response({:error, response}) do
    Logger.warn(("Twilio failed with #{response.status}"))
  end

  defp uri(endpoint) do
    notify_service_id = System.fetch_env!("TWILIO_NOTIFY_SERVICE_ID")
    "/#{@api_version}/#{@services_path}/#{notify_service_id}/#{endpoint}"
  end
end
