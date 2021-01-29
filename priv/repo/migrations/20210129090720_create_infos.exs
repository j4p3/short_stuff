defmodule ShortStuff.Repo.Migrations.CreateInfos do
  use Ecto.Migration

  def change do
    create table(:infos) do
      add :short_interest, :integer
      add :borrow_availability, :integer
      add :source, :string
      add :notes, {:array, :string}

      timestamps()
    end

  end
end
