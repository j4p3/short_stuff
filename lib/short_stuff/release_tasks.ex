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

  def ensure_admin_created() do
    case Application.ensure_all_started(@app) do
      {:ok, _} ->
        if ShortStuff.Users.User |> ShortStuff.Repo.all() |> length() == 0 do
          create_admin()
        else
          IO.puts("ensure_admin_created detected existing admin")
        end

      _ ->
        IO.puts("ensure_admin_created failed to load on start")
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp create_admin() do
    IO.puts("create_admin retrieving admin credentials from env")
    admin_email = System.fetch_env!("ADMIN_USER")
    admin_password = System.fetch_env!("ADMIN_PASSWORD")

    %ShortStuff.Users.User{}
    |> ShortStuff.Users.User.changeset(%{
      email: admin_email,
      password: admin_password,
      password_confirmation: admin_password,
      role: "admin"
    })
    |> ShortStuff.Repo.insert()
    |> handle_user_creation()
  end

  defp handle_user_creation({:ok, user}),
    do: IO.puts("admin user #{user.email} created successfully")

  defp handle_user_creation({:error, changeset}) do
    IO.puts("admin user creation failed")
    IO.inspect(changeset.errors)
  end
end
