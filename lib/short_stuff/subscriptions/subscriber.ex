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
    |> validate_required([:email, :phone, :email_active, :phone_active])
  end
end
