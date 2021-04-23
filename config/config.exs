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
  static_url: [host: System.get_env("ASSET_HOST", "localhost")],
  check_origin: true,
  secret_key_base:
    System.get_env(
      "SECRET_KEY_BASE",
      "+sSUimX8sdtLZImF0GtRkU5W92+0U6XreOukf3HbBPu87S7wZ06LzEdc4pQc3V4Z"
    ),
  render_errors: [view: ShortStuffWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShortStuff.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SALT", "//oj0BhE")]

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

# Authentication
config :short_stuff, :pow,
  user: ShortStuff.Users.User,
  repo: ShortStuff.Repo,
  web_module: ShortStuffWeb

config :tesla, :adapter, Tesla.Adapter.Hackney

config :ex_aws,
  region: "us-west-1"

config :short_stuff, :twilio,
  rate_limiter: ShortStuff.RateLimiters.LeakyBucket,
  timeframe_max_requests: 100,
  timeframe_units: :seconds,
  timeframe: 1

config :short_stuff, :ses,
  rate_limiter: ShortStuff.RateLimiters.LeakyBucket,
  timeframe_max_requests: 12,  # rate limit for mail sending is 14/s
  timeframe_units: :seconds,
  timeframe: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
IO.puts("Overriding config settings with #{Mix.env()}.exs")
import_config "#{Mix.env()}.exs"
