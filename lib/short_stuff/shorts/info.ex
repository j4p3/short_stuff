defmodule ShortStuff.Shorts.Info do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "infos" do
    field :borrow_availability, :integer
    field :notes, {:array, :string}
    field :short_interest, :integer
    field :source, :string

    timestamps()
  end

  @doc false
  def changeset(info, attrs) do
    info
    |> cast(attrs, [:short_interest, :borrow_availability, :source, :notes])
    |> validate_required([:short_interest, :borrow_availability, :source, :notes])
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
