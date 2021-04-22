defmodule ShortStuffWeb.SubscribeFormComponent do
  use ShortStuffWeb, :live_component
  alias ShortStuff.Subscriptions

  # @impl true
  # def handle_event("validate", %{"subscriber" => subscriber_params}, socket) do
  #   changeset =
  #     %Subscriptions.Subscriber{}
  #     |> Subscriptions.change_subscriber(subscriber_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, changeset: changeset)}
  # end

  @impl true
  def handle_event("subscribe", %{"subscriber" => subscriber_params}, socket) do
    subscriber_params
    |> Enum.filter(fn {_, v} -> v != "" end)
    |> Enum.into(%{})
    |> Subscriptions.create_subscriber()
    |> handle_result(socket)
  end

  defp handle_result({:ok, _subscriber}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "subscribed, talk to you soon")
     |> assign(subscribe_active: false)
     |> push_redirect(to: socket.assigns.return_to)}
  end

  defp handle_result({:error, %Ecto.Changeset{} = changeset}, socket) do
    {:noreply,
     socket
     |> put_flash(:warning, "that didn't work. hit me up on twitter.")
     |> assign(changeset: changeset)}
  end
end
