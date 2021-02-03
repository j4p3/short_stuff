defmodule ShortStuffWeb.LayoutView do
  use ShortStuffWeb, :view

  @port_removal_pattern ~r/(^.*):/

  @doc """
  As in "Is the squeeze squozen yet?"
  """
  @spec squeeze_status_answer :: bitstring
  def squeeze_status_answer() do
    if ShortStuff.Shorts.are_squeezed?(), do: "yes", else: "no"
  end

  @spec static_url_without_port(atom | %{:__struct__ => atom, optional(any) => any}, bitstring) ::
          bitstring
  def static_url_without_port(conn, asset) do
    Routes.static_url(conn, asset)
    |> extract_substring(@port_removal_pattern)
  end

  @spec extract_substring(bitstring, %Regex{}) :: bitstring
  defp extract_substring(target_string, regex_pattern) do
    Regex.run(regex_pattern, target_string, capture: :all_but_first)
    |> List.first()
  end
end
