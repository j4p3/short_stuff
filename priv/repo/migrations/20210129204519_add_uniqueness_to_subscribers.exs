defmodule ShortStuff.Repo.Migrations.AddUniquenessToSubscribers do
  use Ecto.Migration

  def change do
    create unique_index(:subscribers, [:phone])
    create unique_index(:subscribers, [:email])
  end
end
