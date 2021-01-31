# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :short_stuff,
  ecto_repos: [ShortStuff.Repo]

# Configures the endpoint
config :short_stuff, ShortStuffWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+sSUimX8sdtLZImF0GtRkU5W92+0U6XreOukf3HbBPu87S7wZ06LzEdc4pQc3V4Z",
  render_errors: [view: ShortStuffWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShortStuff.PubSub,
  live_view: [signing_salt: "//oj0BhE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Admin interface
config :kaffy,
  otp_app: :short_stuff,
  ecto_repo: ShortStuff.Repo,
  router: ShortStuffWeb.Router

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
