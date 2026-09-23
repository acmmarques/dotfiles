let enabled = true;
let volume = 0.6;
let contextInvalidated = false;
const lastPlayedAt = new WeakMap();
const nextSounds = { on: null, off: null };
const fallbackIndexes = { on: 0, off: 0 };
const fallbackSounds = {
  on: Array.from({ length: 10 }, (_, index) =>
    `notification-sounds/dir1-checkbox-on-${String(index + 1).padStart(2, "0")}.wav`
  ),
  off: [
    "notification-sounds/dir1-checkbox-off-01.wav",
    "notification-sounds/dir1-checkbox-off-02.wav"
  ]
};
let activeAudio = null;

function playNotification(soundFile) {
  if (activeAudio) {
    activeAudio.pause();
    activeAudio.currentTime = 0;
  }

  let soundUrl;
  try {
    soundUrl = chrome.runtime.getURL(soundFile);
  } catch (error) {
    if (String(error?.message).includes("Extension context invalidated")) {
      contextInvalidated = true;
      return false;
    }
    throw error;
  }

  const audio = new Audio(soundUrl);
  audio.volume = volume;
  activeAudio = audio;
  audio.addEventListener("ended", () => {
    if (activeAudio === audio) {
      activeAudio = null;
    }
  });
  audio.play().catch((error) => {
    console.warn("Could not play the checkbox notification:", error);
    if (activeAudio === audio) {
      activeAudio = null;
    }
  });
  return true;
}

function playForCheckbox(checkbox, soundFile) {
  if (!enabled) {
    return;
  }

  playOnceForCheckbox(checkbox, soundFile);
}

function playOnceForCheckbox(checkbox, soundFile) {
  if (
    !enabled ||
    !(checkbox instanceof HTMLInputElement) ||
    (soundFile !== "on" && soundFile !== "off")
  ) {
    return;
  }

  const now = Date.now();
  const previousPlay = lastPlayedAt.get(checkbox) ?? 0;
  if (now - previousPlay < 250) {
    return;
  }

  lastPlayedAt.set(checkbox, now);
  const sound = nextSounds[soundFile] ?? getFallbackSound(soundFile);
  nextSounds[soundFile] = null;

  if (!playNotification(sound)) {
    return;
  }
  requestNextSound(soundFile);
}

function getFallbackSound(direction) {
  const sounds = fallbackSounds[direction];
  const index = fallbackIndexes[direction];
  fallbackIndexes[direction] = (index + 1) % sounds.length;
  return sounds[index];
}

function requestNextSound(direction) {
  if (
    contextInvalidated ||
    (direction !== "on" && direction !== "off")
  ) {
    return;
  }

  try {
    chrome.runtime.sendMessage({ type: "next-sound", direction }, (response) => {
    if (chrome.runtime.lastError) {
      console.warn(
        "Could not prefetch the checkbox sound:",
        chrome.runtime.lastError.message,
      );
      return;
    }

    if (typeof response?.soundFile === "string") {
      nextSounds[direction] = response.soundFile;
    }
    });
  } catch (error) {
    if (String(error?.message).includes("Extension context invalidated")) {
      contextInvalidated = true;
      return;
    }
    throw error;
  }
}

chrome.runtime.sendMessage({ type: "get-settings" }, (response) => {
  if (chrome.runtime.lastError) {
    console.warn(
      "Could not read the checkbox sound settings:",
      chrome.runtime.lastError.message,
    );
    return;
  }

  if (typeof response?.enabled === "boolean") {
    enabled = response.enabled;
  }
  if (typeof response?.volume === "number") {
    volume = response.volume;
  }
});

requestNextSound("on");
requestNextSound("off");

chrome.runtime.onMessage.addListener((message) => {
  if (
    message?.type === "enabled-changed" &&
    typeof message.enabled === "boolean"
  ) {
    enabled = message.enabled;
  }
  if (
    message?.type === "volume-changed" &&
    typeof message.volume === "number"
  ) {
    volume = message.volume;
  }
});

document.addEventListener(
  "change",
  (event) => {
    const target = event.target;

    if (
      !event.isTrusted ||
      !(target instanceof HTMLInputElement) ||
      target.type !== "checkbox"
    ) {
      return;
    }

    playForCheckbox(target, target.checked ? "off" : "on");
  },
  true,
);

document.addEventListener(
  "click",
  (event) => {
    if (!event.isTrusted || !(event.target instanceof Element)) {
      return;
    }

    const propertyCell = event.target.closest('[data-testid="property-value"]');
    const checkbox = propertyCell?.querySelector('input[type="checkbox"]');
    if (!propertyCell || !checkbox) {
      return;
    }

    playOnceForCheckbox(checkbox, checkbox.checked ? "on" : "off");
  },
  true,
);
