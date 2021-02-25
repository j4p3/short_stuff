defmodule ShortStuff.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias ShortStuff.Repo

  alias ShortStuff.Subscriptions.Subscriber

  @doc """
  Returns the list of subscribers.

  ## Examples

      iex> list_subscribers()
      [%Subscriber{}, ...]

  """
  def list_subscribers do
    Repo.all(Subscriber)
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
    if subscriber.email, do: Task.start(__MODULE__, :create_email, [subscriber.id, subscriber.email])
    if subscriber.phone, do: Task.start(__MODULE__, :create_phone, [subscriber.id, subscriber.phone])
    {:ok, subscriber}
  end
  defp process_subscription(error_body) do
    error_body
  end

  @doc """
  Async create an external phone record
  """
  def create_phone(subscriber_id, subscriber_phone) do
    Twilio.client()
    |> Twilio.create_binding(subscriber_id, subscriber_phone)
    |> Twilio.log_response()
  end

  @doc """
  Async create an external email record
  """
  def create_email(subscriber_id, _subscriber_email) do
    IO.puts(subscriber_id)
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
end
