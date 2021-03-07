defmodule ShortStuff.Shorts.InfoAdmin do
  import Ecto.Query

  def widgets(schema, _conn) do
    latest = latest(schema)

    [
      %{
        type: "tidbit",
        title: "Latest update",
        content: "#{ShortStuff.Shorts.datetime_format(latest.updated_at)}",
        icon: "book",
        order: 1,
        width: 4
      },
      %{
        type: "tidbit",
        title: "Latest status",
        content: "is squoze: #{if latest.is_squoze, do: "yes", else: "no"}",
        icon: (if latest.is_squoze, do: "exclamation-circle", else: "minus-circle"),
        order: 2,
        width: 4
      },
      %{
        type: "tidbit",
        title: "Latest interest",
        content: "#{latest.short_interest}m",
        icon: "chart-line",
        order: 3,
        width: 4
      }
    ]
  end

  defp latest(schema) do
    schema
    |> last(:updated_at)
    |> ShortStuff.Repo.one()
  end
end
