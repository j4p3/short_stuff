defmodule ShortStuff.RateLimiter do
  @callback make_request(rate_limiter_key :: atom(), request_handler :: tuple(), response_handler :: tuple()) :: :ok

  def make_request(rate_limiter_key, request_handler, response_handler) do
    get_rate_limiter(rate_limiter_key).make_request(rate_limiter_key, request_handler, response_handler)
  end

  def get_rate_limiter(rate_limiter_key), do: get_rate_limiter_config(rate_limiter_key, :rate_limiter)
  def get_requests_per_timeframe(rate_limiter_key), do: get_rate_limiter_config(rate_limiter_key, :timeframe_max_requests)
  def get_timeframe_unit(rate_limiter_key), do: get_rate_limiter_config(rate_limiter_key, :timeframe_units)
  def get_timeframe(rate_limiter_key), do: get_rate_limiter_config(rate_limiter_key, :timeframe)

  def calculate_refresh_rate(num_requests, time, timeframe_units) do
    floor(convert_time_to_milliseconds(timeframe_units, time) / num_requests)
  end

  def convert_time_to_milliseconds(:hours, time), do: :timer.hours(time)
  def convert_time_to_milliseconds(:minutes, time), do: :timer.minutes(time)
  def convert_time_to_milliseconds(:seconds, time), do: :timer.seconds(time)
  def convert_time_to_milliseconds(:milliseconds, milliseconds), do: milliseconds

  defp get_rate_limiter_config(rate_limiter_key, config_key) do
    Application.get_env(:short_stuff, rate_limiter_key)
    |> Keyword.get(config_key)
  end
end
