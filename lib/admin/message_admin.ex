defmodule ShortStuff.Subscriptions.MessageAdmin do
  def after_save(_conn, message) do
    {:ok, _pid} = Task.start(ShortStuff.Subscriptions, :send_message, [message])
    {:ok, message}
  end
end
