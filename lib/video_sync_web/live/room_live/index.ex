defmodule VideoSyncWeb.RoomLive.Index do
  use VideoSyncWeb, :live_view

  alias VideoSync.Player
  alias VideoSync.Player.Room

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :rooms, Player.list_rooms())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Room")
    |> assign(:room, Player.get_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Room")
    |> assign(:room, %Room{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rooms")
    |> assign(:room, nil)
  end

  @impl true
  def handle_info({VideoSyncWeb.RoomLive.FormComponent, {:saved, room}}, socket) do
    {:noreply, stream_insert(socket, :rooms, room)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    room = Player.get_room!(id)
    {:ok, _} = Player.delete_room(room)

    {:noreply, stream_delete(socket, :rooms, room)}
  end
end
