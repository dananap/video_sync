defmodule VideoSyncWeb.RoomChannel do
  use VideoSyncWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("play", _, socket) do
    broadcast!(socket, "play", %{time: socket.assigns.time})
    {:noreply, assign(socket, :playing, true)}
  end

  @impl true
  def handle_in("pause", _, socket) do
    broadcast!(socket, "pause", %{time: socket.assigns.time})
    {:noreply, assign(socket, :playing, false)}
  end

  @impl true
  def handle_in("timeupdate", %{"time" => time}, socket) do
    broadcast!(socket, "timeupdate", %{time: time})
    {:noreply, assign(socket, :time, time)}
  end

  @impl true
  def handle_in("add_video", %{"url" => url}, socket) do
    broadcast!(socket, "add_video", %{url: url})
    {:noreply, assign(socket, video_url: url, playing: false, time: 0)}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
