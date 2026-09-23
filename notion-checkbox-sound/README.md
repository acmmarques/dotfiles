# Notion Checkbox Sound

A personal Chrome extension that plays cycling notification sounds when a
native checkbox on Notion changes state. The ten `checkbox-on` sounds are used
for unchecked → checked transitions, and the two `checkbox-off` sounds are used
for checked → unchecked transitions.

It does not use Notion's API, request account access, or make network requests.
The popup toggle and volume setting default to enabled and 35%, and are held in
`chrome.storage.session`, so they reset when Chrome starts a new browser
session. Sounds stop when a new checkbox transition occurs.

## Install locally

1. Open `chrome://extensions`.
2. Enable **Developer mode**.
3. Click **Load unpacked** and select this directory.
4. Open or reload a Notion tab.

The extension watches native checkbox `change` events, so page loading,
scrolling, unchecking, and already-checked checkboxes do not play a sound.
