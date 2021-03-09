defmodule ShortStuff.Subscriptions.BulkImport do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bulk_imports" do
    field :bucket_name, :string
    field :file_path, :string

    timestamps()
  end

  @doc false
  def changeset(bulk_import, attrs) do
    IO.inspect(attrs)

    bulk_import
    |> cast(attrs, [:bucket_name, :file_path])
  end
end
