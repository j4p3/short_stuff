defmodule ShortStuffWeb.LayoutView do
  use ShortStuffWeb, :view

  @doc """
  As in "Is the squeeze squozen yet?"
  """
  def squeeze_status_answer() do
    if ShortStuff.Shorts.Squeeze.are_squeezed?(), do: "yes", else: "no"
  end
end
