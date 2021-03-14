defmodule ShortStuff.Subscriptions.BulkActions do
  import Ecto.Query

  def backfill_sending_records() do
    {:ok, twilio_pid} = Task.start(__MODULE__, :backfill_twilio_bindings, [])
    {:ok, ses_pid} = Task.start(__MODULE__, :backfill_ses_contacts, [])
    {:ok, [twilio_pid, ses_pid]}
  end

  def backfill_twilio_bindings() do
    twilio_stream =
      ShortStuff.Subscriptions.Subscriber
      |> where([s], not is_nil(s.phone))
      |> where(phone_active: false)
      |> ShortStuff.Repo.stream()

    ShortStuff.Repo.transaction(fn ->
      twilio_stream
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

  def backfill_ses_contacts() do
    :ok
  end
end
