defmodule ShortStuff.Repo.Migrations.ModifyInfosFields do
  use Ecto.Migration

  def change do
    alter table(:infos) do
      modify :short_interest_description, :text
      modify :note, :text
      remove :notes
    end
  end
end
