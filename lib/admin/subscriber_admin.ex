defmodule ShortStuff.Subscriptions.SubscriberAdmin do
  import Ecto.Query

  def widgets(schema, _conn) do
    [
      %{
        type: "tidbit",
        title: "Subscribers",
        content: count(schema),
        icon: "book",
        order: 4,
        width: 4
      },
      %{
        type: "tidbit",
        title: "Emails",
        content: email_count(schema),
        icon: "exclamation-circle",
        order: 5,
        width: 4
      },
      %{
        type: "tidbit",
        title: "Phones",
        content: phone_count(schema),
        icon: "exclamation-circle",
        order: 6,
        width: 4
      }
    ]
  end

  defp count(schema) do
    schema
    |> select(count())
    |> ShortStuff.Repo.one()
  end

  defp email_count(schema) do
    schema
    |> where([s], not is_nil(s.email))
    |> select(count())
    |> ShortStuff.Repo.one()
  end

  defp phone_count(schema) do
    schema
    |> where([s], not is_nil(s.phone))
    |> select(count())
    |> ShortStuff.Repo.one()
  end
end
