defmodule ShortStuff.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias ShortStuff.RateLimiter

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
      {Task.Supervisor, name: RateLimiter.TaskSupervisor},
      Supervisor.child_spec(
        {
          RateLimiter.get_rate_limiter(:twilio),
          %{
            timeframe_max_requests: RateLimiter.get_requests_per_timeframe(:twilio),
            timeframe_units: RateLimiter.get_timeframe_unit(:twilio),
            timeframe: RateLimiter.get_timeframe(:twilio),
            key: :twilio
          }
        },
        id: :twilio
      ),
      Supervisor.child_spec(
        {
          ShortStuff.RateLimiter.get_rate_limiter(:ses_emails),
          %{
            timeframe_max_requests: RateLimiter.get_requests_per_timeframe(:ses_emails),
            timeframe_units: RateLimiter.get_timeframe_unit(:ses_emails),
            timeframe: RateLimiter.get_timeframe(:ses_emails),
            key: :ses_emails
          }
        },
        id: :ses_emails
      ),
      Supervisor.child_spec(
        {
          ShortStuff.RateLimiter.get_rate_limiter(:ses_contacts),
          %{
            timeframe_max_requests: RateLimiter.get_requests_per_timeframe(:ses_contacts),
            timeframe_units: RateLimiter.get_timeframe_unit(:ses_contacts),
            timeframe: RateLimiter.get_timeframe(:ses_contacts),
            key: :ses_contacts
          }
        },
        id: :ses_contacts
      )
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
