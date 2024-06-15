// Bring in Phoenix channels client library:
import { Socket } from "phoenix"
import videojs from '../vendor/video.js/video';
import { debounce } from "./util";

const videoForm = document.getElementById('videoForm');
let socket = new Socket("/socket", { params: { token: window.userToken } })
let userInitiatedAction = true;

const player = videojs('videoPlayer', {
  fluid: true,
  preload: 'auto'
});

socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
let channel = socket.channel("room:42", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


videoForm.addEventListener('submit', event => {
  event.preventDefault();
  const url = document.getElementById('videoUrl').value;
  channel.push('add_video', { url });
});
channel.on('init', ({ url, playing, time }) => {
  player.src(url);
  player.currentTime(time);
  if (playing) {
    player.play();
  }
});

channel.on('add_video', ({ url }) => {
  player.src(url);
});

channel.on('play', () => {
  userInitiatedAction = false;
  player.play();
});

channel.on('pause', () => {
  userInitiatedAction = false;
  player.pause();
});

channel.on('timeupdate', ({ time }) => {
  if (Math.abs(player.currentTime() - time) > 1) {
    player.currentTime(time);
  }
});

const pushPlay = debounce(() => channel.push('play', {}), 100);
const pushPause = debounce(() => channel.push('pause', {}), 100);
player.on('play', (e) => {
  console.log('play', e);
  pushPlay();
});

player.on('pause', (e) => {
  console.log('pause', e);
  pushPause();
});


player.on('timeupdate', () => {
  channel.push('timeupdate', { time: player.currentTime() });
});

export default socket
