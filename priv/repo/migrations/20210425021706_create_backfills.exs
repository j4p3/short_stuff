defmodule ShortStuff.Repo.Migrations.CreateBackfills do
  use Ecto.Migration

  def change do
    create table(:backfills) do
      add :attribute, :string

      timestamps()
    end
  end
end
