defmodule ShortStuff.Subscriptions.BulkActions do
  import Ecto.Query
  require Logger

  def sync_external_subscriptions() do
    Logger.debug("ShortStuff.Subscriptions.BulkActions.sync_external_subscriptions")
    {:ok, twilio_pid} = Task.start(__MODULE__, :sync_phones_to_twilio, [])
    {:ok, ses_pid} = Task.start(__MODULE__, :sync_emails_to_ses, [])
    {:ok, [twilio_pid, ses_pid]}
  end

  def sync_phones_to_twilio() do
    Logger.debug("ShortStuff.Subscriptions.BulkActions.sync_phones_to_twilio")
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

  def sync_emails_to_ses() do
    Logger.debug("ShortStuff.Subscriptions.BulkActions.sync_emails_to_ses")
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
        :sync_subscriber_phone,
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
        :sync_subscriber_email,
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
