defmodule ShortStuff.Repo.Migrations.CreateBulkImports do
  use Ecto.Migration

  def change do
    create table(:bulk_imports) do
      add :bucket_name, :string
      add :file_path, :string

      timestamps()
    end
  end
end
