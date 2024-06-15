defmodule VideoSync.PlayerTest do
  use VideoSync.DataCase

  alias VideoSync.Player

  describe "rooms" do
    alias VideoSync.Player.Room

    import VideoSync.PlayerFixtures

    @invalid_attrs %{time: nil, url: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Player.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Player.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{time: "some time", url: "some url"}

      assert {:ok, %Room{} = room} = Player.create_room(valid_attrs)
      assert room.time == "some time"
      assert room.url == "some url"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Player.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{time: "some updated time", url: "some updated url"}

      assert {:ok, %Room{} = room} = Player.update_room(room, update_attrs)
      assert room.time == "some updated time"
      assert room.url == "some updated url"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Player.update_room(room, @invalid_attrs)
      assert room == Player.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Player.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Player.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Player.change_room(room)
    end
  end
end
