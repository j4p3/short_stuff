defmodule ShortStuff.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :role, :string, null: false, default: "user"

    pow_user_fields()

    timestamps()
  end

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end

  def set_admin_role(user) do
    user
    |> __MODULE__.changeset_role(%{role: "admin"})
    |> ShortStuff.Repo.update()
  end
end
