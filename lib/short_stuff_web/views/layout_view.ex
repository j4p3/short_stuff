defmodule ShortStuffWeb.LayoutView do
  use ShortStuffWeb, :view

  @doc """
  As in "Is the squeeze squozen yet?"
  """
  @spec squeeze_status_answer :: bitstring
  def squeeze_status_answer() do
    if ShortStuff.Shorts.are_squeezed?(), do: "yes", else: "no"
  end

  def static_url_without_port(conn, asset) do
    Routes.static_url(conn, asset)
    |> extract_substring()
  end

  # Conditionally render style on homepage
  def render("style.root.html", assigns) do
    if assigns[:live_action] == :index do
      ~E"""
        <link
        phx-track-static
        rel="stylesheet"
        type="text/css"
        href="<%= static_url_without_port(assigns[:conn], "/css/app.css") %>"/>
      """
    end
  end

  # Remove the port from the asset URL in production environments
  defp extract_substring(target_string) do
    if System.get_env("MIX_ENV") != "dev" do
      "https" <> Regex.replace(
        ~r/^http(:\/\/.*):\d*(.*)$/,
      target_string,
      "\\g{1}\\g{2}"
    )
    else
      target_string
    end
  end
end
