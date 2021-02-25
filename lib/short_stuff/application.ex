defmodule ShortStuff.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    ShortStuff.Diagnostics.run()

    children = [
      # Start the Ecto repository
      ShortStuff.Repo,
      # Start the Telemetry supervisor
      ShortStuffWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ShortStuff.PubSub},
      ShortStuffWeb.Presence,
      # Start the Endpoint (http/https)
      ShortStuffWeb.Endpoint,
      # Start async task supervisor
      # {Task.Supervisor, ShortStuff.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShortStuff.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShortStuffWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
