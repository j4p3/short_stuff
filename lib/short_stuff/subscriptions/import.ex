defmodule ShortStuff.Subscriptions.BulkCreate do
  alias ShortStuff.Subscriptions.Subscriber
  alias ShortStuff.Repo

  def ingest_file(file) do
    datetime = DateTime.utc_now()
    |> NaiveDateTime.truncate(:second)

    file
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode(headers: true)
    |> Stream.map(fn {:ok, s} -> s end)
    # |> Enum.take(2)
    |> Stream.map(&Map.take(&1, ["Email Address", "Phone Number"]))
    |> Stream.map(
      &%{
        email: Map.get(&1, "Email Address"),
        phone: Map.get(&1, "Phone Number"),
        inserted_at: datetime,
        updated_at: datetime
      }
    )
    |> Stream.chunk_every(1000)
    |> Enum.each(fn rows ->
      Repo.insert_all(Subscriber, rows, [on_conflict: :nothing])
    end)
  end
end
