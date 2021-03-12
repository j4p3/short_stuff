defmodule ShortStuff.Subscriptions.BulkActions do
  import Ecto.Query

  def create_bindings() do
    stream =
      ShortStuff.Subscriptions.Subscriber
      |> where([s], not is_nil(s.phone))
      |> where(phone_active: false)
      |> ShortStuff.Repo.stream()

    ShortStuff.Repo.transaction(fn ->
      stream
      |> Stream.each(fn subscriber ->
        IO.puts("Enqueueing binding for subscriber #{subscriber.id}")
        ShortStuff.RateLimiter.make_request(
          :twilio,
          {
            ShortStuff.Subscriptions,
            :create_subscriber_binding,
            [subscriber]
          },
          {
            ShortStuff.Subscriptions,
            :activate_phone,
            [subscriber]
          }
        )
      end)
      |> Stream.run()
    end)
  end

  def create_ses_records() do
    :ok
  end
end
