defmodule ShortStuffWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :short_stuff

  plug HealthCheck

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_short_stuff_key",
    signing_salt: "UVdCd1fu"
  ]

  socket "/socket", ShortStuffWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Admin interface
  plug Plug.Static,
    at: "/kaffy",
    from: :kaffy,
    gzip: false,
    only: ~w(assets)

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :short_stuff,
    gzip: true,
    only: ~w(css fonts images js favicon.ico robots.txt),
    headers: [{"access-control-allow-origin", "*.isthesqueezesquoze.com"}]

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :short_stuff
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug :x_clacks_overhead
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug Pow.Plug.Session, otp_app: :short_stuff
  plug ShortStuffWeb.Router

  def x_clacks_overhead(conn, _opts) do
    conn
    |> Plug.Conn.put_resp_header("X-Clacks-Overhead", "GNU Terry Pratchett")
  end
end
