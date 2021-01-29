defmodule ShortStuff.Repo do
  use Ecto.Repo,
    otp_app: :short_stuff,
    adapter: Ecto.Adapters.Postgres
end
