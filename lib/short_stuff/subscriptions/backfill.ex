defmodule ShortStuff.Subscriptions.Backfill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "backfills" do
    field :attribute, Ecto.Enum, values: [:email, :phone]

    timestamps()
  end

  @doc false
  def changeset(backfill, attrs) do
    IO.inspect(attrs)

    backfill
    |> cast(attrs, [:attribute])
  end
end
