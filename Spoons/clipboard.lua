-- clipboard = hs.chooser.new(function (choice)
--     if choice then
--       hs.pasteboard.setContents(choice.content)
--       hs.eventtap.keyStroke({ "cmd" }, "v")
--     end
--   end)
  
--   local history = {}
--   function addHistoryFromPasteboard()
--     print('add')
--     local contentTypes = hs.pasteboard.contentTypes()
  
--     local item = {}
--     for index, uti in ipairs(contentTypes) do
--       print(uti)
      
--         print(hs.pasteboard.readString())
--         print(hs.pasteboard.readImage())
      
--         imagee = hs.pasteboard.readImage()
--         if imagee ~= nil then
--             item.image = imagee
--         end
--       if uti == "public.utf8-plain-text" then
--         local text = hs.pasteboard.readString()
--         item.text = string.gsub(text, "[\r\n]+", " ")
--         item.content = text;
--         break
--       end
--     end
  
--     table.insert(history, 1, item)
--   end
  
--   local preChangeCount = hs.pasteboard.changeCount()
--   local watcher = hs.timer.new(0.5, function ()
--     -- print(preChangeCount)
--       local changeCount = hs.pasteboard.changeCount()
--     --   print(changeCount)
--     if preChangeCount ~= changeCount then
--        addHistoryFromPasteboard()
--        preChangeCount = changeCount
--     end
--   end)
--   watcher:start()
  
--   hs.hotkey.bind({ "cmd", "shift" }, "v", function ()
--     clipboard:choices(history)
--     clipboard:show()
--   end)