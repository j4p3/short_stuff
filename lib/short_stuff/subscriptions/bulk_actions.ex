defmodule ShortStuff.Subscriptions.BulkActions do
  import Ecto.Query

  def backfill_sending_records() do
    {:ok, twilio_pid} = Task.start(__MODULE__, :backfill_phone, [])
    {:ok, ses_pid} = Task.start(__MODULE__, :backfill_email, [])
    {:ok, [twilio_pid, ses_pid]}
  end

  def backfill_phone() do
    twilio_stream =
      ShortStuff.Subscriptions.Subscriber
      |> where([s], not is_nil(s.phone))
      |> where(phone_active: false)
      |> ShortStuff.Repo.stream()

    ShortStuff.Repo.transaction(fn ->
      twilio_stream
      |> Stream.each(&enqueue_phone(&1))
      |> Stream.run()
    end)
  end

  def backfill_email() do
    email_stream =
      ShortStuff.Subscriptions.Subscriber
      |> where([s], not is_nil(s.email))
      |> where(email_active: false)
      |> ShortStuff.Repo.stream()

    ShortStuff.Repo.transaction(fn ->
      email_stream
      |> Stream.each(&enqueue_email(&1))
      |> Stream.run()
    end)
  end

  defp enqueue_phone(subscriber) do
    ShortStuff.RateLimiter.make_request(
      :twilio,
      {
        ShortStuff.Subscriptions,
        :create_subscriber_phone,
        [subscriber]
      },
      {
        ShortStuff.Subscriptions,
        :activate_phone,
        [subscriber]
      }
    )
  end

  defp enqueue_email(subscriber) do
    ShortStuff.RateLimiter.make_request(
      :ses,
      {
        ShortStuff.Subscriptions,
        :create_subscriber_email,
        [subscriber]
      },
      {
        ShortStuff.Subscriptions,
        :activate_email,
        [subscriber]
      }
    )
  end
end
