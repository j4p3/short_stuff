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
    result = Subscriptions.create_subscriber(subscriber_params)

    case result do
      {:ok, _subscriber} ->
        {:noreply,
         socket
         |> put_flash(:info, "subscribed, talk to you soon")
         |> assign(subscribe_active: false)
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("creation failed")
        IO.inspect(changeset)
        {:noreply,
         socket
         |> put_flash(:warning, "that didn't work. hit me up on twitter.")
         |> assign(
           changeset: changeset
         )}
    end
  end
end
