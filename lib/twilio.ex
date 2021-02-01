defmodule Twilio do
  @moduledoc """
  A binding is a Twilio record describing a phone number's subscription to a notification service.
  """
  @api_version "v1"
  @services_path "Services"

  def create_binding(client, user) do
    Tesla.post(client, uri("Bindings"),
    body: %{
      Identity: user.id,
      BindingType: "sms",
      Address: user.phone,
      Tags: ["shortstuff"]
    })
  end

  def broadcast(client, message) do
    Tesla.post(client, uri("Notifications"),
    body: %{
      ToBinding: %{binding_type: "sms"},
      Tag: "all",
      Body: message
    })
  end

  def client() do
    creds = %{
      account_id: System.fetch_env!("TWILIO_ACCOUNT_ID"),
      auth_token: System.fetch_env!("TWILIO_AUTH_TOKEN")
    }

    auth_string = "#{Map.get(creds, :account_id)}:#{Map.get(creds, :auth_token)}"

    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://notify.twilio.com"},
      Tesla.Middleware.JSON,
      # Tesla.Middleware.FormUrlencoded,
      {Tesla.Middleware.Headers,
       [
         {
           "Authorization",
           "Basic #{Base.encode64(auth_string)}"
         }
       ]}
    ])
  end

  defp uri(endpoint) do
    notify_service_id = System.fetch_env!("TWILIO_NOTIFY_SERVICE_ID")
    "/#{@api_version}/#{@services_path}/#{notify_service_id}/#{endpoint}"
  end
end
