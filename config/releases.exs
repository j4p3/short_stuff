# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

hostname = System.fetch_env!("HOSTNAME")
asset_host = System.fetch_env!("ASSET_HOST")
port = System.get_env("PORT", "4000")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")
db_name = System.fetch_env!("DB_NAME")
secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
signing_salt = System.fetch_env!("SIGNING_SALT")

allowed_hosts = [
  "//dualstack.shortstuff-prod-92946469.us-west-1.elb.amazonaws.com",
  "//dualstack.shortstuff-prod-92946469.us-west-1.elb.amazonaws.com:#{port}",
  "//prod.isthesqueezesquoze.com",
  "//prod.isthesqueezesquoze.com:#{port}",
  "//dev.isthesqueezesquoze.com",
  "//dev.isthesqueezesquoze.com:#{port}",
  "//isthesqueezesquoze.com",
  "//isthesqueezesquoze.com:#{port}",
  "//localhost:#{port}"
]


config :short_stuff, ShortStuff.Repo,
  # ssl: true,
  url: "ecto://#{db_user}:#{db_password}@#{db_host}/#{db_name}",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :short_stuff, ShortStuffWeb.Endpoint,
  url: [host: hostname, port: port],
  static_url: [host: asset_host],
  http: [
    port: String.to_integer(port),
    transport_options: [socket_opts: [:inet6]]
  ],
  check_origin: allowed_hosts,
  secret_key_base: secret_key_base,
  live_view: [signing_salt: signing_salt]

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :short_stuff, ShortStuffWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
