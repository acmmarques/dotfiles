local step = 30
local repeatDelay = 0.3
local repeatInterval = 0.1
local maxHold = 5

local directions = {
  left = { x = -step, y = 0 },
  right = { x = step, y = 0 },
  up = { x = 0, y = -step },
  down = { x = 0, y = step },
}

local activeHold

local function stopHold()
  if not activeHold then return end

  if activeHold.delayTimer then activeHold.delayTimer:stop() end
  if activeHold.repeatTimer then activeHold.repeatTimer:stop() end
  if activeHold.timeoutTimer then activeHold.timeoutTimer:stop() end
  activeHold = nil
end

local function nudge(hold)
  local frame = hold.window:frame()
  if not frame then
    hs.printf("Window nudge: the focused window is no longer available")
    stopHold()
    return
  end

  frame.x = frame.x + hold.delta.x
  frame.y = frame.y + hold.delta.y
  hold.window:setFrame(frame, 0)
end

hs.urlevent.bind("nudge", function(_, params)
  local direction = params.direction
  local action = params.action
  if not directions[direction] or (action ~= "start" and action ~= "stop") then
    hs.printf("Window nudge: expected direction=left|right|up|down and action=start|stop")
    return
  end

  if action == "stop" then
    if activeHold and activeHold.direction == direction then stopHold() end
    return
  end

  if activeHold and activeHold.direction == direction then return end
  stopHold()

  local window = hs.window.focusedWindow()
  if not window then
    hs.printf("Window nudge: no focused window")
    return
  end

  local hold = { direction = direction, delta = directions[direction], window = window }
  activeHold = hold
  nudge(hold)
  if activeHold ~= hold then return end

  hold.delayTimer = hs.timer.doAfter(repeatDelay, function()
    if activeHold ~= hold then return end
    hold.repeatTimer = hs.timer.doEvery(repeatInterval, function()
      if activeHold == hold then nudge(hold) end
    end)
  end)
  hold.timeoutTimer = hs.timer.doAfter(maxHold, function()
    if activeHold == hold then stopHold() end
  end)
end)
