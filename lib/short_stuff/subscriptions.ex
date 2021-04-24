defmodule ShortStuff.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  require Logger

  alias ShortStuff.Repo
  alias ShortStuff.Subscriptions.Subscriber
  alias ShortStuff.Subscriptions.Message

  @doc """
  Broadcast or narrowcase message to subscribers via third party senders.
  """
  @spec send_message(%ShortStuff.Subscriptions.Message{}) ::
          {:ok, %ShortStuff.Subscriptions.Message{}}
  def send_message(message) do
    message
    |> get_message_recipients()
    |> call_message_senders()
  end

  defp get_message_recipients(message = %Message{target_id: nil}) do
    {:ok, :all, message}
  end

  defp get_message_recipients(message = %Message{target_id: target_id}) do
    case get_subscriber!(target_id) do
      subscriber = %Subscriber{} ->
        {:ok, subscriber, message}

      error = %Ecto.NoResultsError{} ->
        {:error, error}
    end
  end

  defp call_message_senders({:ok, subscriber = %Subscriber{}, message = %Message{}}) do
    if subscriber.email && subscriber.email_active do
      IO.puts("calling SES for #{subscriber.email}")
      ShortStuff.SES.send_email(subscriber.email, message.content)
    end

    if subscriber.phone && subscriber.phone_active do
      IO.puts("calling Twilio for #{subscriber.phone}")

      Twilio.client()
      |> Twilio.send(message.content, subscriber.id)
    end

    {:ok, message}
  end

  defp call_message_senders({:ok, :all, message = %Message{}}) do
    IO.puts("calling Twilio and SES for all subscribers")

    Twilio.client()
    |> Twilio.broadcast(message.content)

    ShortStuff.SES.broadcast(message)
    {:ok, message}
  end

  def sync_subscriber_phone(%{id: id, phone: phone} = %Subscriber{}) do
    Twilio.client()
    |> Twilio.create_binding(id, phone)
  end

  def sync_subscriber_email(%{id: id, email: email} = %Subscriber{}) do
    list_name = "shortstuff_" <> System.get_env("MIX_ENV")
    topic_name = "gme_" <> System.get_env("MIX_ENV")

    ExAws.SES.create_contact(list_name, email,
      attributes: "#{id}",
      topic_preferences: [%{TopicName: topic_name, SubscriptionStatus: "OPT_IN"}]
    )
    |> ExAws.request(debug_requests: true)
    |> IO.inspect()
  end

  @doc """
  Returns the list of subscribers.

  ## Examples

      iex> list_subscribers()
      [%Subscriber{}, ...]

  """
  def list_subscribers do
    Repo.all(Subscriber)
  end

  def email_subscribers_stream do
    ShortStuff.Subscriptions.Subscriber
    |> where([s], not is_nil(s.email))
    |> where(email_active: false)
    |> ShortStuff.Repo.stream()
  end

  def list_subscribers_with_phones do
    ShortStuff.Subscriptions.Subscriber
    |> where([s], not is_nil(s.phone))
    |> ShortStuff.Repo.all()
  end

  def list_subscribers_with_emails do
    ShortStuff.Subscriptions.Subscriber
    |> where([s], not is_nil(s.email))
    |> ShortStuff.Repo.all()
  end

  @doc """
  Gets a single subscriber.

  Raises `Ecto.NoResultsError` if the Subscriber does not exist.

  ## Examples

      iex> get_subscriber!(123)
      %Subscriber{}

      iex> get_subscriber!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscriber!(id), do: Repo.get!(Subscriber, id)

  @doc """
  Creates a subscriber.

  ## Examples

      iex> create_subscriber(%{field: value})
      {:ok, %Subscriber{}}

      iex> create_subscriber(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscriber(attrs \\ %{}) do
    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> unique_constraint(:email, name: :subscribers_email_index)
    |> unique_constraint(:phone, name: :subscribers_phone_index)
    |> update_change(:email, &String.downcase/1)
    |> Repo.insert()
    |> process_subscription()
  end

  defp process_subscription({:ok, subscriber}) do
    if subscriber.email,
      do: Task.start(__MODULE__, :sync_subscriber_email, [subscriber.id, subscriber.email])

    if subscriber.phone,
      do: Task.start(__MODULE__, :sync_subscriber_phone, [subscriber.id, subscriber.phone])

    {:ok, subscriber}
  end

  defp process_subscription(error_body) do
    error_body
  end

  def activate_phone(subscriber) do
    update_subscriber(subscriber, %{phone_active: true})
  end

  def deactivate_phone(subscriber) do
    update_subscriber(subscriber, %{phone_active: false})
  end

  def activate_email(subscriber) do
    update_subscriber(subscriber, %{email_active: true})
  end

  def deactivate_email(subscriber) do
    update_subscriber(subscriber, %{email_active: false})
  end

  @doc """
  Updates a subscriber.

  ## Examples

      iex> update_subscriber(subscriber, %{field: new_value})
      {:ok, %Subscriber{}}

      iex> update_subscriber(subscriber, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscriber(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> Subscriber.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscriber.

  ## Examples

      iex> delete_subscriber(subscriber)
      {:ok, %Subscriber{}}

      iex> delete_subscriber(subscriber)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscriber(%Subscriber{} = subscriber) do
    Repo.delete(subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscriber changes.

  ## Examples

      iex> change_subscriber(subscriber)
      %Ecto.Changeset{data: %Subscriber{}}

  """
  def change_subscriber(%Subscriber{} = subscriber, attrs \\ %{}) do
    Subscriber.changeset(subscriber, attrs)
  end

  def create_message(attrs \\ %{}) do
    IO.inspect(attrs)

    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
