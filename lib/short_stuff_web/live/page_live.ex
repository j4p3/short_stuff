defmodule ShortStuffWeb.PageLive do
  use ShortStuffWeb, :live_view
  use Timex

  @presence_topic "presence"

  # Lifecycle functions & live event handlers
  @impl true
  def mount(_params, _session, socket) do
    # ShortStuffWeb.Presence.track(self(), @presence_topic, socket.id, %{})
    # ShortStuffWeb.Endpoint.subscribe(@presence_topic)
    # present =
    #   ShortStuffWeb.Presence.list(@presence_topic)
    #   |> map_size()

    {:ok,
     assign(socket,
       short_info: ShortStuff.Shorts.last_info(),
      #  present: present,
       subscribe_active: false,
       squeeze_status: status_answer(ShortStuff.Shorts.are_squeezed?())
     )}
  end

  @impl true
  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        %{assigns: %{present: present}} = socket
      ) do
        new_present = present + map_size(joins) - map_size(leaves)
    {:noreply, assign(socket, present: new_present)}
  end

  @impl true
  def handle_event("init_subscribe", _value, socket) do
    IO.puts("received init_subscribe")
    {:noreply, assign(socket, subscribe_active: true)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.puts("received handle_params")
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    IO.puts("received apply_action")
    assign(socket, subscribe_active: false)
  end

  # Template helpers

  def did_it_or_not(verb) do
    if ShortStuff.Shorts.are_squeezed?(), do: "#{verb}", else: "#{verb} not"
  end

  def date_format(datetime) do
    {:ok, human_string} = datetime
    |> Timex.Timezone.convert("America/New_York")
    |> Timex.format("%A, %B %d", :strftime)
    human_string
  end

  def datetime_format(datetime) do
    {:ok, human_string} = datetime
    |> Timex.Timezone.convert("America/New_York")
    |> Timex.format("%H:%M %m/%d", :strftime)
    human_string
  end

  defp status_answer(status), do: if status, do: "yes", else: "no"
end
