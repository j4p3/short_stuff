defmodule ShortStuff.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email, :string
      add :phone, :string
      add :email_active, :boolean, default: false, null: false
      add :phone_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
