defmodule ShortStuff.Shorts.Squeeze do
  @stdv_si 10

  def are_squeezed? do
    high_day_delta?()
  end

  def si_delta() do
    case ShortStuff.Shorts.Info.last_two do
      [now, prev] ->
        prev.short_interest - now.short_interest
      [_] ->
        0
      [] ->
        0
    end
  end

  defp high_day_delta?() do
    si_delta() > @stdv_si
  end
end
