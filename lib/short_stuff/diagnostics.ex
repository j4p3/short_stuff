defmodule ShortStuff.Diagnostics do
  def run() do
    IO.puts("ShortStuff.Diagnostics environment")
    IO.puts("============================")
    IO.puts("MIX_ENV: #{System.get_env("MIX_ENV")}")
    IO.puts("SECRET_KEY_BASE: #{present("SECRET_KEY_BASE")}")
    IO.puts("SIGNING_SALT: #{present("SIGNING_SALT")}")
    IO.puts("DB_PASSWORD: #{present("DB_PASSWORD")}")
    IO.puts("DB_NAME: #{System.get_env("DB_NAME")}")
    IO.puts("DB_USER: #{System.get_env("DB_USER")}")
    IO.puts("DB_HOST: #{System.get_env("DB_HOST")}")
    IO.puts("ADMIN_USER: #{System.get_env("ADMIN_USER")}")
    IO.puts("ADMIN_PASSWORD: #{present("ADMIN_PASSWORD")}")
    IO.puts("============================")
  end

  defp present(key) do
    if System.get_env(key), do: "present", else: ""
  end
end
