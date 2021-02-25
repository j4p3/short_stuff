defmodule ShortStuff.Subscriptions.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :email_active, :boolean, default: true
    field :phone, :string
    field :phone_active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
    IO.inspect(attrs)

    subscriber
    |> cast(attrs, [:email, :phone, :email_active, :phone_active])
    |> validate_required_attributes(attrs)
  end

  def validate_required_attributes(changeset, %{"email" => _}) do
    changeset
    |> validate_required([:email])
  end

  def validate_required_attributes(changeset, %{"phone" => _}) do
    changeset
    |> validate_required([:phone])
    |> IO.inspect()
    |> validate_parsable()
    |> IO.inspect()
    |> update_change(:phone, &string_to_record/1)
    |> IO.inspect()
    |> validate_phone_number()
    |> IO.inspect()
    |> update_change(:phone, &record_to_string/1)
    |> IO.inspect()
  end

  def validate_required_attributes(changeset, _attrs) do
    changeset
    |> add_error(:email, "either phone or email is required")
  end

  defp validate_parsable(changeset) do
    IO.puts("validate_parsable")

    validate_change(changeset, :phone, fn _, phone ->
      case ExPhoneNumber.parse(phone, "US") do
        {:ok, _phone} ->
          []

        {:error, error} ->
          [phone: error]
      end
    end)
  end

  defp string_to_record(phone_string) do
    IO.puts("string_to_record")

    case ExPhoneNumber.parse(phone_string, "US") do
      {:ok, phone_number} ->
        phone_number

      {:error, _error} ->
        phone_string
    end
  end

  defp record_to_string(%ExPhoneNumber.Model.PhoneNumber{} = phone_record) do
    IO.puts("record_to_string")
    ExPhoneNumber.format(phone_record, :e164)
  end
  defp record_to_string(phone_string), do: phone_string

  defp validate_phone_number(changeset) do
    IO.puts("validate_phone_number")

    if Enum.empty?(changeset.errors) do
      validate_change(changeset, :phone, fn _, phone ->
        case ExPhoneNumber.is_valid_number?(phone) do
          true ->
            []
          false ->
            [phone: "invalid phone number"]
        end
      end)
    else
      changeset
    end
  end
end
