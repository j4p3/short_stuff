defmodule ShortStuff.Shorts.Info do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "infos" do
    field :short_interest, :integer
    field :short_interest_description, :string
    field :borrow_availability, :integer, default: 0
    field :note, :string
    field :source, :string, default: nil
    field :borrow_rate, :string

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

  def last do
    __MODULE__
    |> last
    |> ShortStuff.Repo.one
  end

  def last_two do
    __MODULE__
    |> order_by(desc: :updated_at)
    |> limit(2)
    |> ShortStuff.Repo.all
  end
end
