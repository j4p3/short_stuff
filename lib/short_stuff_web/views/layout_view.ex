defmodule ShortStuffWeb.LayoutView do
  use ShortStuffWeb, :view

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
    |> extract_substring()
  end

  # Remove the port from the asset URL in production environments
  defp extract_substring(target_string) do
    if System.get_env("MIX_ENV") != "dev" do
      Regex.replace(
      ~r/^(.*):\d*(.*)$/,
      target_string,
      "\\g{1}\\g{2}"
    )
    else
      target_string
    end
  end
end
