-- rc_xephyr.lua: wrapper to run user's rc.lua and force a preset for testing
local home = os.getenv("HOME") or "/home/milk"
dofile(home .. "/.config/awesome/rc.lua")

-- after the main config initializes, set shimmer preset explicitly
local ok, shimmer = pcall(require, "plugins.shimmer")
if ok and shimmer and shimmer.set_mode then
  shimmer.set_mode("copper")
end
