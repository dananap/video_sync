defmodule VideoSyncWeb.RoomChannel do
  alias VideoSync.Repo
  use VideoSyncWeb, :channel


  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join("room:" <> room_id, payload, socket) do
    if authorized?(payload) do
      video_state = get_video_state(room_id)
      socket = assign(socket, %{url: video_state.url, playing: video_state.playing, time: video_state.time})

      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    push(socket, "init", %{url: socket.assigns.url, playing: socket.assigns.playing, time: socket.assigns.time})

    {:noreply, socket}
  end

  @impl true
  def handle_in("add_video", %{"url" => url}, socket) do
    broadcast!(socket, "add_video", %{url: url})
    socket = assign(socket, url: url, playing: false, time: 0)
    save_video_state(socket.topic, socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_in("play", _params, socket) do
    broadcast!(socket, "play", %{})
    socket = assign(socket, playing: true)
    save_video_state(socket.topic, socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_in("pause", _params, socket) do
    broadcast!(socket, "pause", %{})
    socket = assign(socket, playing: false)
    save_video_state(socket.topic, socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_in("timeupdate", %{"time" => time}, socket) do
    if abs(time - get_video_state(socket.topic).time) > 1 do
      broadcast!(socket, "timeupdate", %{time: time})
      socket = assign(socket, time: time)
      save_video_state(socket.topic, socket.assigns)
    end

    {:noreply, socket}
  end

  @impl true
  def handle_in("seek", %{"time" => time}, socket) do
    broadcast!(socket, "seek", %{time: time})
    socket = assign(socket, time: time)
    save_video_state(socket.topic, socket.assigns)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp get_video_state(room_id) do
    unless Repo.exists?(VideoSync.Room, id: room_id) do
      VideoSync.Room.changeset(%VideoSync.Room{}, %{id: room_id, url: "", playing: false, time: 0})
      |> Repo.insert!()
    end

    Repo.one!(VideoSync.Room, where: %{id: room_id})
  end

  defp save_video_state(topic, state) do
    VideoSync.Room.changeset(get_video_state(topic), state)
    |> Repo.update!()
  end
end
