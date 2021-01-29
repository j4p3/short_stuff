defmodule ShortStuff.ShortsTest do
  use ShortStuff.DataCase

  alias ShortStuff.Shorts

  describe "infos" do
    alias ShortStuff.Shorts.Info

    @valid_attrs %{borrow_availability: 42, notes: %{}, short_interest: 42, source: "some source", updated_at: ~N[2010-04-17 14:00:00]}
    @update_attrs %{borrow_availability: 43, notes: %{}, short_interest: 43, source: "some updated source", updated_at: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{borrow_availability: nil, notes: nil, short_interest: nil, source: nil, updated_at: nil}

    def info_fixture(attrs \\ %{}) do
      {:ok, info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Shorts.create_info()

      info
    end

    test "list_infos/0 returns all infos" do
      info = info_fixture()
      assert Shorts.list_infos() == [info]
    end

    test "get_info!/1 returns the info with given id" do
      info = info_fixture()
      assert Shorts.get_info!(info.id) == info
    end

    test "create_info/1 with valid data creates a info" do
      assert {:ok, %Info{} = info} = Shorts.create_info(@valid_attrs)
      assert info.borrow_availability == 42
      assert info.notes == %{}
      assert info.short_interest == 42
      assert info.source == "some source"
      assert info.updated_at == ~N[2010-04-17 14:00:00]
    end

    test "create_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shorts.create_info(@invalid_attrs)
    end

    test "update_info/2 with valid data updates the info" do
      info = info_fixture()
      assert {:ok, %Info{} = info} = Shorts.update_info(info, @update_attrs)
      assert info.borrow_availability == 43
      assert info.notes == %{}
      assert info.short_interest == 43
      assert info.source == "some updated source"
      assert info.updated_at == ~N[2011-05-18 15:01:01]
    end

    test "update_info/2 with invalid data returns error changeset" do
      info = info_fixture()
      assert {:error, %Ecto.Changeset{}} = Shorts.update_info(info, @invalid_attrs)
      assert info == Shorts.get_info!(info.id)
    end

    test "delete_info/1 deletes the info" do
      info = info_fixture()
      assert {:ok, %Info{}} = Shorts.delete_info(info)
      assert_raise Ecto.NoResultsError, fn -> Shorts.get_info!(info.id) end
    end

    test "change_info/1 returns a info changeset" do
      info = info_fixture()
      assert %Ecto.Changeset{} = Shorts.change_info(info)
    end
  end
end
