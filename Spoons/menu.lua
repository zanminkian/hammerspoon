rightClicking = false
eventtap = hs.eventtap.new({hs.eventtap.event.types.rightMouseDown}, function()
    rightClicking = true
    hs.timer.doAfter(0.1, function() rightClicking = false end)
end)
eventtap:start()

local function getIcon(name)
  if name == 'Docker Desktop' then return '~/.hammerspoon/Spoons/assets/Docker Desktop.png' end
  if name == 'uTools' then return '~/.hammerspoon/Spoons/assets/uTools.png' end
  if name == 'Seal' then return '~/.hammerspoon/Spoons/assets/Seal.png' end
  if name == 'Microsoft Edge' then return '~/.hammerspoon/Spoons/assets/Microsoft Edge.png' end
  if name == 'Lark' then return '~/.hammerspoon/Spoons/assets/Lark.png' end
  if name == 'WeChat' then return '~/.hammerspoon/Spoons/assets/WeChat.png' end
  if name == 'Visual Studio Code' then return '~/.hammerspoon/Spoons/assets/Visual Studio Code.png' end
  if name == 'Finder' then return '~/.hammerspoon/Spoons/assets/Finder.png' end
  if name == 'Terminal' then return '~/.hammerspoon/Spoons/assets/Terminal.png' end
  if name == 'Activity Monitor' then return '~/.hammerspoon/Spoons/assets/Activity Monitor.png' end
  if name == 'Notes' then return '~/.hammerspoon/Spoons/assets/Notes.png' end
  return '~/.hammerspoon/Spoons/assets/unknown.png'
end

local function length(arr)
  local count = 0
  for k, v in pairs(arr) do
      count = count + 1
  end
  return count
end

function setup(image, app, path, tooltip)
  local icon = hs.image.imageFromPath(image):setSize({h=22, w=22})
  return hs.menubar.new():setIcon(icon, false):setTooltip(tooltip):setMenu(function()
    if rightClicking then
      return {{title = "Exit", fn = function() app:kill() end}}
    end

    local menu = {}
    for k, v in pairs(app:allWindows()) do
        if v:isStandard() then
            local title = v:title()
            if title then
                table.insert(menu, {title = title, fn = function() v:focus() end})
            end
        end
    end
    if length(menu) > 1 then return menu end

    path = path:gsub(" ", "\\ ")
    hs.execute('open '..path); hs.timer.doAfter(0.35, function() app:activate(true) end)
    return {}
  end)
end

ms = {}
watcher = hs.application.watcher.new(function(appName, eventType, appInstance)
  if eventType ~= hs.application.watcher.launching and eventType ~= hs.application.watcher.activated and eventType ~= hs.application.watcher.terminated then return end
  _, dockAppNames = hs.osascript.applescript('tell application "Finder"\n get the name of every process whose visible is true\n end tell')
  if not dockAppNames then return end
  for i, v in pairs(dockAppNames) do
    if v == 'Electron' then dockAppNames[i] = 'Visual Studio Code' end
  end

  apps = {}
  for i, app in pairs(hs.application.runningApplications()) do
    local bundleID = app:bundleID()
    if bundleID then
      local path = hs.application.pathForBundleID(bundleID)
      if path then
        apps[path] = app
      end
    end
  end

  -- for i, v in pairs(apps) do
  --   print(i)
  -- end

  local dockerApps = {}
  for i, name in pairs(dockAppNames) do
    local inserted = false
    for path, app in pairs(apps) do
      if path:match(name..".app$") then
        dockerApps[name] = path
        inserted = true
      end
    end
    if not inserted then dockerApps[name] = '' end
  end

  -- for i, v in pairs(dockerApps) do
  --   print(i, v)
  -- end
  for i, v in pairs(ms) do
    v:delete()
  end
  ms = {}
  local names = {}
  for name, path in pairs(dockerApps) do
    table.insert(names, name)
  end
  table.sort(names)
  for i, name in pairs(names) do
    local path = dockerApps[name]
    table.insert(ms, setup(getIcon(name), apps[path], path, name))
  end
end)
watcher:start()
