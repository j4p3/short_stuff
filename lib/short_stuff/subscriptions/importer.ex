defmodule ShortStuff.Subscriptions.Importer do
  alias ShortStuff.Subscriptions.Subscriber
  alias ShortStuff.Repo
  require Logger

  def import_file(:s3, bucket, file) do
    Logger.debug("ShortStuff.Subscriptions.Importer.import_file")
    stream_s3_file(bucket, file)
    ShortStuff.Subscriptions.BulkActions.sync_external_subscriptions()
    # CSV formats conflict
    # ShortStuff.Subscriptions.BulkActions.bulk_import_to_ses(bucket, file)
  end

  def stream_s3_file(bucket, file) do
    Logger.debug("ShortStuff.Subscriptions.Importer.stream_s3_file")

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
    Logger.debug("ShortStuff.Subscriptions.Importer.stream_to_repo")
    datetime = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    result =
      stream
      |> CSV.decode(headers: true)
      |> Stream.map(fn {:ok, s} -> s end)
      |> Stream.map(&Map.take(&1, ["Email Address", "Phone Number"]))
      |> Stream.map(&add_email(&1))
      |> Stream.map(&add_phone(&1))
      |> Stream.map(&Map.take(&1, [:email, :phone]))
      |> Stream.map(&format_phone(&1))
      |> Stream.map(&add_timestamps(&1, datetime))
      |> Stream.chunk_every(1000)
      |> Enum.each(fn rows ->
        Logger.debug("ShortStuff.Subscriptions.Importer.stream_to_repo - inserting chunk")
        Repo.insert_all(Subscriber, rows, on_conflict: :nothing)
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

  defp format_phone(%{phone: phone_number} = record) do
    case ExPhoneNumber.parse(phone_number, "US") do
      {:ok, phone_number} ->
        Map.merge(record, %{phone: ExPhoneNumber.format(phone_number, :e164)})

      {:error, _error} ->
        {_, trimmed_record} = Map.pop(record, :phone)
        trimmed_record
    end
  end

  defp format_phone(record), do: record

  defp add_timestamps(record, datetime) do
    Map.merge(record, %{
      inserted_at: datetime,
      updated_at: datetime
    })
  end

  def split_lines(chunk, acc) do
    [last_line | lines] =
      (acc <> chunk)
      |> String.split("\n")
      |> Enum.reverse()

    {Enum.reverse(lines), last_line}
  end
end
