defmodule ShortStuff.Repo.Migrations.AddSqueezeStatusToInfos do
  use Ecto.Migration

  def change do
    alter table(:infos) do
      add :is_squoze, :boolean
    end
  end
end
