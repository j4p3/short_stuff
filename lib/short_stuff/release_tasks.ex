defmodule ShortStuff.ReleaseTasks do
  @app :short_stuff

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def create_admin(email, password) do
    %ShortStuff.Users.User{}
    |> ShortStuff.Users.User.changeset(%{
      email: email,
      password: password,
      password_confirmation: password
    })
    |> ShortStuff.Repo.insert()
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
