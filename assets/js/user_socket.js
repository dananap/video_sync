// Bring in Phoenix channels client library:
import { Socket } from "phoenix"
import videojs from 'video.js';

let socket = new Socket("/socket", { params: { token: window.userToken } })

const player = videojs('videoPlayer', {
  fluid: true
});

socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
let channel = socket.channel("room:42", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

const videoForm = document.getElementById('videoForm');

videoForm.addEventListener('submit', event => {
  event.preventDefault();
  const url = document.getElementById('videoUrl').value;
  channel.push('add_video', { url });
});
channel.on('init', ({ url, playing, time }) => {
  player.src(url);
  if (playing) {
    player.play();
  }
  player.currentTime(time);
});

channel.on('add_video', ({ url }) => {
  player.src(url);
});

channel.on('play', () => {
  player.play();
});

channel.on('pause', () => {
  player.pause();
});

channel.on('timeupdate', ({ time }) => {
  if( Math.abs(player.currentTime() - time) > 1 ) {
    player.currentTime(time);
  }
});

player.on('play', () => {
  channel.push('play', {});
});

player.on('pause', () => {
  channel.push('pause', {});
});

player.on('timeupdate', () => {
  channel.push('timeupdate', { time: player.currentTime() });
});

export default socket
