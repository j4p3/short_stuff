defmodule ShortStuff.Users do
  alias ShortStuff.Users.User

  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "admin"})
    |> ShortStuff.Repo.insert()
  end

  def set_admin_role(user) do
    user
    |> User.changeset_role(%{role: "admin"})
    |> ShortStuff.Repo.update()
  end
end
