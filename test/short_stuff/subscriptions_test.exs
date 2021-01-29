defmodule ShortStuff.SubscriptionsTest do
  use ShortStuff.DataCase

  alias ShortStuff.Subscriptions

  describe "subscribers" do
    alias ShortStuff.Subscriptions.Subscriber

    @valid_attrs %{email: "some email", email_active: true, phone: "some phone", phone_active: true}
    @update_attrs %{email: "some updated email", email_active: false, phone: "some updated phone", phone_active: false}
    @invalid_attrs %{email: nil, email_active: nil, phone: nil, phone_active: nil}

    def subscriber_fixture(attrs \\ %{}) do
      {:ok, subscriber} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Subscriptions.create_subscriber()

      subscriber
    end

    test "list_subscribers/0 returns all subscribers" do
      subscriber = subscriber_fixture()
      assert Subscriptions.list_subscribers() == [subscriber]
    end

    test "get_subscriber!/1 returns the subscriber with given id" do
      subscriber = subscriber_fixture()
      assert Subscriptions.get_subscriber!(subscriber.id) == subscriber
    end

    test "create_subscriber/1 with valid data creates a subscriber" do
      assert {:ok, %Subscriber{} = subscriber} = Subscriptions.create_subscriber(@valid_attrs)
      assert subscriber.email == "some email"
      assert subscriber.email_active == true
      assert subscriber.phone == "some phone"
      assert subscriber.phone_active == true
    end

    test "create_subscriber/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_subscriber(@invalid_attrs)
    end

    test "update_subscriber/2 with valid data updates the subscriber" do
      subscriber = subscriber_fixture()
      assert {:ok, %Subscriber{} = subscriber} = Subscriptions.update_subscriber(subscriber, @update_attrs)
      assert subscriber.email == "some updated email"
      assert subscriber.email_active == false
      assert subscriber.phone == "some updated phone"
      assert subscriber.phone_active == false
    end

    test "update_subscriber/2 with invalid data returns error changeset" do
      subscriber = subscriber_fixture()
      assert {:error, %Ecto.Changeset{}} = Subscriptions.update_subscriber(subscriber, @invalid_attrs)
      assert subscriber == Subscriptions.get_subscriber!(subscriber.id)
    end

    test "delete_subscriber/1 deletes the subscriber" do
      subscriber = subscriber_fixture()
      assert {:ok, %Subscriber{}} = Subscriptions.delete_subscriber(subscriber)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_subscriber!(subscriber.id) end
    end

    test "change_subscriber/1 returns a subscriber changeset" do
      subscriber = subscriber_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_subscriber(subscriber)
    end
  end
end
