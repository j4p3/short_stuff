defmodule ShortStuff.Subscriptions.BackfillAdmin do
  require Logger

  def after_save(_conn, backfill) do
    Logger.debug("ShortStuff.Subscriptions.Backfill.after_save")
    {:ok, _pid} = Task.start(ShortStuff.Subscriptions.BulkActions, :backfill, [backfill.attribute])
    {:ok, backfill}
  end
end
