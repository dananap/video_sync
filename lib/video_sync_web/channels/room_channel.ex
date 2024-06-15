defmodule VideoSyncWeb.RoomChannel do
  use VideoSyncWeb, :channel

  @ets_table :video_state_table

  def init(state) do
    :ets.new(@ets_table, [:named_table, :public, read_concurrency: true, write_concurrency: true])
    {:ok, state}
  end

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
      socket = assign(socket, video_state)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("add_video", %{"url" => url}, socket) do
    broadcast!(socket, "add_video", %{url: url})
    socket = assign(socket, video_url: url, playing: false, time: 0)
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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp get_video_state(room_id) do
    case :ets.lookup(@ets_table, room_id) do
      [{^room_id, video_state}] -> video_state
      [] -> %{video_url: nil, playing: false, time: 0}
    end
  end

  defp save_video_state(topic, state) do
    :ets.insert(@ets_table, {topic, state})
  end
end
