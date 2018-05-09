import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("marty", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp); })
  .receive("error", resp => { console.log("Unable to join", resp); });

// Get elements

let motion = document.getElementById('motion-select');
let stepsSelect = document.getElementById('steps');
let speedRadios = document.getElementsByName('speed');
let connectionElement = document.getElementById('connection');
let batteryElement = document.getElementById('battery');

// Add event listeners

motion.addEventListener('change', e => {
  setupInputState(motion.value);
});

document.getElementById('go').addEventListener('click', e => {
  performMotion(motion.value);
});

document.getElementById('hello').addEventListener('click', e => {
  channel.push('hello', {});
});

document.getElementById('move-stop').addEventListener('click', e => {
  channel.push('stop', {});
});

document.getElementById('lifelike').addEventListener('click', e => {
  if (document.getElementById('lifelike').checked) {
    channel.push('lifelike', {enable: true});
  } else {
    channel.push('lifelike', {enable: false});
  }
});

// input state functions

const setupInputState = motion => {
  if(/circle|celebrate/.test(motion)){
    disableInputs({steps: true, speed: false});
  } else if(motion.includes('kick')){
    disableInputs({steps: true, speed: false});
  } else if(motion.includes('tap')){
    disableInputs({steps: true, speed: true});
  } else {
    disableInputs({steps: false, speed: false});
  }
};

const disableInputs = ({steps, speed}) => {
  stepsSelect.disabled = steps;
  for (var i=0, iLen=speedRadios.length; i<iLen; i++) {
    speedRadios[i].disabled = speed;
  }
};

// Motion functions

const performMotion = motion => {
  let speed = document.querySelector('input[name="speed"]:checked').value;

  switch(motion) {
    case 'celebrate':
      channel.push('celebrate', {speed: speed});
      break;
    case 'tap-left':
      tapFoot('left');
      break;
    case 'tap-right':
      tapFoot('right');
      break;
    case 'kick-left':
      kick('left', speed);
      break;
    case 'kick-right':
      kick('right', speed);
      break;
    case 'circle-left':
      circleDance('left', speed);
      break;
    case 'circle-right':
      circleDance('right', speed);
      break;
    default:
      walk(motion, speed);
      break;
  }
};

let kick  = (foot, speed) => {
  channel.push('kick', {foot: foot, speed: speed, twist: 1});
};

let circleDance = (side, speed) => {
  channel.push('circle_dance', {side: side, speed: speed});
};

let tapFoot = foot => {
  channel.push('tap_foot', {foot: foot});
};

let walk = (motion, speed) => {
  channel.push('walk', {
    direction: motion,
    speed: speed,
    steps: stepsSelect.value
  });
};

// Connection states

channel.on('marty_state', martyState => {
  if(martyState['connected?']) {
    connectedState(martyState);
  }  else {
    disconnectedState();
  }
});

const connectedState = martyState => {
  connectionElement.src = '/images/connected.svg';
  batteryElement.src = '/images/full-battery.svg';

  if(martyState.battery != null) {
    if(martyState.battery.toFixed(3) <= 7.7) {
      batteryElement.src = '/images/mid-battery.svg';
    } else if(martyState.battery.toFixed(3) <= 6.9) {
      batteryElement.src = '/images/low-battery.svg';
    }
  }
};

const disconnectedState = () => {
  connectionElement.src = '/images/disconnected.svg';
  batteryElement.src = '/images/battery-unavailable.svg';
  channel.push('lifelike', { enable: false });
  document.getElementById('lifelike').checked = false;
};
