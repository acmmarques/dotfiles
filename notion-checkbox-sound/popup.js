const checkbox = document.querySelector("#enabled");
const status = document.querySelector("#status");
const volume = document.querySelector("#volume");
const volumeValue = document.querySelector("#volume-value");

chrome.runtime.sendMessage({ type: "get-settings" }, (response) => {
  if (chrome.runtime.lastError) {
    status.textContent = "Unavailable";
    return;
  }

  checkbox.checked = response?.enabled ?? true;
  volume.value = Math.round((response?.volume ?? 0.35) * 100);
  updateStatus();
  updateVolumeLabel();
});

checkbox.addEventListener("change", () => {
  chrome.runtime.sendMessage({
    type: "set-enabled",
    enabled: checkbox.checked
  });
  updateStatus();
});

volume.addEventListener("input", () => {
  updateVolumeLabel();
  chrome.runtime.sendMessage({
    type: "set-volume",
    volume: Number(volume.value) / 100
  });
});

function updateStatus() {
  status.textContent = checkbox.checked ? "Enabled for this browser session" : "Disabled for this browser session";
}

function updateVolumeLabel() {
  volumeValue.textContent = `${volume.value}%`;
}
