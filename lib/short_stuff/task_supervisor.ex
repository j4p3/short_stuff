# defmodule ShortStuff.TaskSupervisor do
#   def create_phone(phone) do
#     Task.Supervisor.start(
#       __MODULE__,
#       ShortStuff.Subscriptions,
#       :create_phone,
#       [phone],
#       [restart: :temporary]
#     )
#   end

#   def create_email(email) do
#     Task.Supervisor.start_child(
#       __MODULE__,
#       ShortStuff.Subscriptions,
#       :create_email,
#       [email],
#       [restart: :temporary]
#     )
#   end
# end
