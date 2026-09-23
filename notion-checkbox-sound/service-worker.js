const DEFAULT_ENABLED = true;
const DEFAULT_VOLUME = 0.6;
const SOUND_FILES = {
  on: Array.from(
    { length: 10 },
    (_, index) =>
      `notification-sounds/dir1-checkbox-on-${String(index + 1).padStart(2, "0")}.wav`,
  ),
  off: [
    "notification-sounds/dir1-checkbox-off-01.wav",
    "notification-sounds/dir1-checkbox-off-02.wav",
  ],
};
let allocationQueue = Promise.resolve();

async function getSettings() {
  const { enabled, volume } = await chrome.storage.session.get([
    "enabled",
    "volume",
  ]);
  return {
    enabled: enabled ?? DEFAULT_ENABLED,
    volume: volume ?? DEFAULT_VOLUME,
  };
}

function getNextSound(direction) {
  allocationQueue = allocationQueue.then(async () => {
    const files = SOUND_FILES[direction];
    const key = `sound-index-${direction}`;
    const stored = await chrome.storage.session.get(key);
    const index = stored[key] ?? 0;

    await chrome.storage.session.set({
      [key]: (index + 1) % files.length,
    });
    return files[index];
  });

  return allocationQueue;
}

async function notifyNotionTabs(message) {
  const tabs = await chrome.tabs.query({
    url: [
      "https://notion.so/*",
      "https://www.notion.so/*",
      "https://app.notion.com/*",
    ],
  });

  await Promise.all(
    tabs.map(async (tab) => {
      if (tab.id === undefined) {
        return;
      }

      try {
        await chrome.tabs.sendMessage(tab.id, message);
      } catch (error) {
        if (!String(error?.message).includes("Receiving end does not exist")) {
          console.error("Could not update the Notion tab:", error);
        }
      }
    }),
  );
}

chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  if (message?.type === "get-settings") {
    getSettings()
      .then((settings) => sendResponse(settings))
      .catch((error) => {
        console.error("Could not read the sound settings:", error);
        sendResponse({ enabled: DEFAULT_ENABLED, volume: DEFAULT_VOLUME });
      });
    return true;
  }

  if (message?.type === "set-enabled" && typeof message.enabled === "boolean") {
    chrome.storage.session
      .set({ enabled: message.enabled })
      .then(() =>
        notifyNotionTabs({ type: "enabled-changed", enabled: message.enabled }),
      )
      .catch((error) =>
        console.error("Could not save the sound setting:", error),
      );
  }

  if (message?.type === "set-volume" && typeof message.volume === "number") {
    chrome.storage.session
      .set({ volume: message.volume })
      .then(() =>
        notifyNotionTabs({ type: "volume-changed", volume: message.volume }),
      )
      .catch((error) =>
        console.error("Could not save the volume setting:", error),
      );
  }

  if (
    message?.type === "next-sound" &&
    (message.direction === "on" || message.direction === "off")
  ) {
    getNextSound(message.direction)
      .then((soundFile) => sendResponse({ soundFile }))
      .catch((error) => {
        console.error("Could not allocate the next notification sound:", error);
        sendResponse({});
      });
    return true;
  }
});
