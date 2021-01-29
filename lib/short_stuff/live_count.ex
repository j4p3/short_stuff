defmodule ShortStuff.LiveCount do
  @moduledoc """
  A simple actor to keep track of live user count
  """
  use GenServer
  def init(_) do
    {:ok, 0}
  end

  def handle_call(:retrieve, _caller, count) do
    {:reply, count, count}
  end

  def handle_call(:increment, _caller, count) do
    {:noreply, count + 1, count + 1}
  end

  def handle_cast(:decrement, count) do
    {:noreply, (if count > 0, do: count - 1, else: 0)}
  end

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @spec increment :: integer
  def increment() do
    GenServer.call(__MODULE__, :increment)
  end

  @spec decrement :: :ok
  def decrement() do
    GenServer.cast(__MODULE__, :decrement)
  end
end
