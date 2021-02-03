import Config

hostname = System.get_env("HOSTNAME", "localhost")
asset_host = System.get_env("ASSET_HOST", "localhost")
port = System.get_env("PORT", 4000)
db_user = System.get_env("DB_USER", "postgres")
db_password = System.get_env("DB_PASSWORD", "postgres")
db_host = System.get_env("DB_HOST", "localhost")
db_name = System.get_env("DB_NAME", "short_stuff_dev")
secret_key_base = System.get_env("SECRET_KEY_BASE", "59yAnQWMFQyF6Kc7r4KmzpWN6EBsAGIcwBlNar1vX9ntgBdZlBiAGm5GmKQrzdYb")
signing_salt = System.get_env("SIGNING_SALT", "EkjLCEWYBdSDxA+CKuufN0/nKyOF7Wq5")

allowed_hosts = [
  "//localhost",
  "//localhost:#{port}",
]

# Configure your database
config :short_stuff, ShortStuff.Repo,
  username: db_user,
  password: db_password,
  database: db_name,
  hostname: db_host,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :short_stuff, ShortStuffWeb.Endpoint,
  url: [host: hostname],
  static_url: [host: asset_host],
  http: [port: port],
  debug_errors: true,
  code_reloader: true,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/short_stuff_web/(live|views)/.*(ex)$",
      ~r"lib/short_stuff_web/templates/.*(eex)$"
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
