defmodule Mix.Tasks.Notify do
  use Mix.Task
  @moduledoc """
  Notifies subscribers with a given message.
  """

  def run(_args) do
    Mix.Task.run("app.start")
    ShortStuff.Shorts.list_infos()
    |> IO.inspect()
  end
end
