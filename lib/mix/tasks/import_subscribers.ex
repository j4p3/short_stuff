defmodule Mix.Tasks.ImportSubscribers do
  @moduledoc """
  Import subscribers from a CSV in an S3 bucket
  """
  use Mix.Task

  def run([bucket, filename]) do
    Mix.Task.run("app.start")
    Mix.Task.run(ShortStuff.Subscriptions.Importer.stream_s3_file(bucket, filename))
  end
end
