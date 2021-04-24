defmodule ShortStuff.SES do
  @spec broadcast(ShortStuff.Subscriptions.Message) :: :ok
  def broadcast(message) do
    ShortStuff.Subscriptions.email_subscribers_stream()
    |> Stream.each(&enqueue_email(&1.email, message.content))
    |> Stream.run()
  end

  @spec send_email(String.t(), String.t()) :: any()
  def send_email(email_address, message) do
    destination = %{ToAddresses: [email_address]}
    content = %{Simple: %{Body: %{Text: %{Data: message}}}}
    list = %{ContactListName: "shortstuff", TopicName: "gme"}

    ExAws.SES.send_email_v2(destination, content, "jp@isthesqueezesquoze.com",
      list_management: list
    )
  end

  defp enqueue_email(subscriber_email, message) do
    ShortStuff.RateLimiter.make_request(
      :ses,
      {
        __MODULE__,
        :send_email,
        [subscriber_email, message]
      },
      {
        __MODULE__,
        :handle_result,
        [subscriber_email]
      }
    )
  end

  defp handle_result(email), do: {:ok, "Sent email to #{email}"}
end
