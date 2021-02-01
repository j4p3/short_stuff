defmodule ShortStuff.Repo.Migrations.AddAttrsToInfos do
  use Ecto.Migration

  def change do
    alter table(:infos) do
      add :note, :string
      add :borrow_rate, :string
      add :short_interest_description, :string
    end
  end
end
