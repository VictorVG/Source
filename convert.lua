-- shmuz, 28.05.2020, updated VictorVG, 28.05.2020
-- copy to root temporary folder included Moonscript files and run
-- all Moonscript files be deleted after convert!
local to_lua = (require "moonscript.base").to_lua
far.RecursiveSearch(far.GetCurrentDirectory(), "*.moon",
  function(item, fullpath)
    local fp = assert(io.open(fullpath))
    local str = fp:read("*all")
    fp:close()
    local newpath = fullpath:sub(1,-5).."lua"
    fp = assert(io.open(newpath,"w"))
    str = assert(to_lua(str))
    fp:write(str, "\n")
    fp:close()
  end,
  "FRS_RECUR")
far.RecursiveSearch(far.GetCurrentDirectory(), "*.moon",
  function(name, path) win.DeleteFile(path) end,
  "FRS_RECUR")