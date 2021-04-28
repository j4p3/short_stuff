defmodule ShortStuff.Subscriptions.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :email_active, :boolean, default: false
    field :phone, :string
    field :phone_active, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
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
    |> validate_parsable()
    |> update_change(:phone, &string_to_record/1)
    |> validate_phone_number()
    |> update_change(:phone, &record_to_string/1)
  end

  def validate_required_attributes(changeset, %{phone_active: _}), do: changeset
  def validate_required_attributes(changeset, %{email_active: _}), do: changeset

  def validate_required_attributes(changeset, _attrs) do
    changeset
    |> add_error(:email, "either phone or email is required")
  end

  defp validate_parsable(changeset) do
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
    case ExPhoneNumber.parse(phone_string, "US") do
      {:ok, phone_number} ->
        phone_number

      {:error, _error} ->
        nil
    end
  end

  defp record_to_string(%ExPhoneNumber.Model.PhoneNumber{} = phone_record) do
    ExPhoneNumber.format(phone_record, :e164)
  end

  defp record_to_string(nil), do: nil

  defp validate_phone_number(changeset) do
    if Enum.empty?(changeset.errors) do
      validate_change(changeset, :phone, fn _, phone ->
        if phone do
          case ExPhoneNumber.is_valid_number?(phone) do
            true ->
              []

            false ->
              [phone: "invalid phone number"]
          end
        else
          [phone: "invalid phone number"]
        end
      end)
    else
      changeset
    end
  end
end
