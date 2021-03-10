defmodule ShortStuff.Subscriptions.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :target_id, :integer

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    IO.inspect(attrs)

    message
    |> cast(attrs, [:content, :target_id])
  end
end
