defmodule ShortStuff.Shorts.Squeeze do
  @stdv_si 10

  def are_squeezed? do
    high_day_delta?()
  end

  def si_delta() do
    [now, prev] = ShortStuff.Shorts.Info.last_two
    prev.short_interest - now.short_interest
  end

  defp high_day_delta?() do
    si_delta() > @stdv_si
  end
end
