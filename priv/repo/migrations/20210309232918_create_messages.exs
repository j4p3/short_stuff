defmodule ShortStuff.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :target_id, :integer

      timestamps()
    end
  end
end
