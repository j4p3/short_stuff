defmodule ShortStuff.Shorts.Info do
  use Ecto.Schema
  import Ecto.Changeset

  schema "infos" do
    field :short_interest, :integer
    field :short_interest_description, :string
    field :borrow_availability, :integer, default: 0
    field :note, :string
    field :source, :string, default: nil
    field :borrow_rate, :string
    field :is_squoze, :boolean

    timestamps()
  end

  @doc false
  def changeset(info, attrs) do
    info
    |> cast(attrs, [
        :short_interest,
        :short_interest_description,
        :borrow_availability,
        :note,
        :source,
        :borrow_rate
      ])
    |> validate_required([
      :short_interest,
      :borrow_availability,
      :source
      ])
  end
end
