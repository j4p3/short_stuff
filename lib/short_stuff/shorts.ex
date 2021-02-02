defmodule ShortStuff.Shorts do
  @moduledoc """
  The Shorts context.
  """

  import Ecto.Query, warn: false
  alias ShortStuff.Repo

  alias ShortStuff.Shorts.Info

  @stdv_si 10

  def are_squeezed? do
    # This would call high_day_delta?() to generate an answer
    # But the consequences of leaving this to a simple algorithm are now too high
    # It should only be adjusted manually
    false
  end

  def si_delta() do
    case last_two_infos() do
      [now, prev] ->
        prev.short_interest - now.short_interest
      [_] ->
        0
      [] ->
        0
    end
  end

  defp high_day_delta?() do
    si_delta() > @stdv_si
  end

  def last_info() do
    Info
    |> last(:updated_at)
    |> Repo.one
  end

  def last_two_infos do
    Info
    |> order_by(desc: :updated_at)
    |> limit(2)
    |> Repo.all
  end

  @doc """
  Returns the list of infos.

  ## Examples

      iex> list_infos()
      [%Info{}, ...]

  """
  def list_infos do
    Repo.all(Info)
  end

  @doc """
  Gets a single info.

  Raises `Ecto.NoResultsError` if the Info does not exist.

  ## Examples

      iex> get_info!(123)
      %Info{}

      iex> get_info!(456)
      ** (Ecto.NoResultsError)

  """
  def get_info!(id), do: Repo.get!(Info, id)

  @doc """
  Creates a info.

  ## Examples

      iex> create_info(%{field: value})
      {:ok, %Info{}}

      iex> create_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_info(attrs \\ %{}) do
    %Info{}
    |> Info.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a info.

  ## Examples

      iex> update_info(info, %{field: new_value})
      {:ok, %Info{}}

      iex> update_info(info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_info(%Info{} = info, attrs) do
    info
    |> Info.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a info.

  ## Examples

      iex> delete_info(info)
      {:ok, %Info{}}

      iex> delete_info(info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_info(%Info{} = info) do
    Repo.delete(info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking info changes.

  ## Examples

      iex> change_info(info)
      %Ecto.Changeset{data: %Info{}}

  """
  def change_info(%Info{} = info, attrs \\ %{}) do
    Info.changeset(info, attrs)
  end
end
