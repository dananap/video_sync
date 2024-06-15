defmodule VideoSync.PlayerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `VideoSync.Player` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        time: "some time",
        url: "some url"
      })
      |> VideoSync.Player.create_room()

    room
  end
end
