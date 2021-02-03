import Config

# These values will be overwritten in be release.exs with task-provided values
hostname = System.get_env("HOSTNAME", "localhost")
asset_host = System.get_env("ASSET_HOST", "localhost")
db_user = System.get_env("DB_USER", "postgres")
db_password = System.get_env("DB_PASSWORD", "postgres")
db_host = System.get_env("DB_HOST", "localhost")
db_name = System.get_env("DB_NAME", "short_stuff_dev")
secret_key_base = System.get_env("SECRET_KEY_BASE", "59yAnQWMFQyF6Kc7r4KmzpWN6EBsAGIcwBlNar1vX9ntgBdZlBiAGm5GmKQrzdYb")
signing_salt = System.get_env("SIGNING_SALT", "EkjLCEWYBdSDxA+CKuufN0/nKyOF7Wq5")

config :short_stuff, ShortStuff.Repo,
  # ssl: true,
  username: db_user,
  password: db_password,
  database: db_name,
  hostname: db_host,
  # url: "ecto://#{db_user}:#{db_password}@#{db_host}/#{db_name}",
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
#
config :short_stuff, ShortStuffWeb.Endpoint,
  url: [host: hostname],
  static_url: [host: asset_host],
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  live_view: [signing_salt: signing_salt]

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :short_stuff, ShortStuffWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :short_stuff, ShortStuffWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Finally import the config/prod.secret.exs which loads secrets
# and configuration from environment variables.
# (Disabled so as to not require credentials at build time)
# import_config "prod.secret.exs"
