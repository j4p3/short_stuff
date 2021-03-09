defmodule ShortStuff.Subscriptions.BulkCreate do
  alias ShortStuff.Subscriptions.Subscriber
  alias ShortStuff.Repo

  def stream_s3_file(bucket, file) do
    ExAws.S3.download_file(bucket, file, :memory)
    |> ExAws.stream!()
    |> Stream.transform("", &split_lines/2)
    |> stream_to_repo()
  end

  def stream_local_file(file_location) do
    file_location
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> stream_to_repo()
  end

  def stream_to_repo(stream) do
    datetime = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    result = stream
    |> CSV.decode(headers: true)
    |> Stream.map(fn {:ok, s} -> s end)
    |> Stream.map(&Map.take(&1, ["Email Address", "Phone Number"]))
    |> Stream.map(&add_email(&1))
    |> Stream.map(&add_phone(&1))
    |> Stream.map(&Map.take(&1, [:email, :phone]))
    |> Stream.map(&add_timestamps(&1, datetime))
    |> Stream.chunk_every(1000)
    |> Enum.each(fn rows ->
      Repo.insert_all(Subscriber, rows, [on_conflict: :nothing])
    end)

    result
  end

  defp add_email(%{"Email Address" => nil} = record) do
    record
  end
  defp add_email(%{"Email Address" => email} = record) do
    Map.merge(record, %{email: email})
  end
  defp add_phone(%{"Phone Number" => nil} = record) do
    record
  end
  defp add_phone(%{"Phone Number" => ""} = record) do
    record
  end
  defp add_phone(%{"Phone Number" => phone} = record) do
    Map.merge(record, %{phone: phone})
  end

  defp add_timestamps(record, datetime) do
    Map.merge(record, %{
      inserted_at: datetime,
      updated_at: datetime
    })
  end

  def split_lines(chunk, acc) do
    [last_line | lines] =
      acc <> chunk
      |> String.split("\n")
      |> Enum.reverse()
	  {Enum.reverse(lines) ,last_line}
  end

  def chunk_fun(chunk, acc) do
    IO.puts("\n\n\nchunk_fun")
    IO.puts("chunk")
    IO.inspect(chunk)
    IO.puts("acc")
    IO.inspect(acc)
    split_chunk(acc, chunk) || split_chunk(chunk, "")
  end

  def split_chunk("", _append_remaining), do: nil
  def split_chunk(string, append_remaining) do
    case String.split(string, "\n", parts: 2) do
      [l] ->
        {:cont, l}
      [l, remaining] ->
        {:cont, l, remaining <> append_remaining}
    end
  end

  @spec after_fun(any) :: {:cont, <<>>} | {:cont, any, <<>>}
  def after_fun(""), do: {:cont, ""}
  def after_fun(acc), do: {:cont, acc, ""}
end
