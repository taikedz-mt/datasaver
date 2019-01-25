# Data Saver

Convenience mod to save data to a local file in the world folder.

This kind of code is duplicated for many mods, having a reliable library for it might make life easier.

## Dependency

You can either add this mod as a dependency for your mod, or literally copy the `datasaver.lua` file into your own project. Be sure to check your license is compatible with this one's (LGPLv2.1).

If multiple mods copy the file into their own code, versions loaded after the first one will skip loading - so it should be safe to copy them around.

## API

### `datasaver:new(modname, dataname, defaultdata)`

Create a new data saver object. Returns a datasaver object, e.g.

Arguments

* `modname` - REQUIRED - name of the mod - used to distinguish data files from other mods
* `dataname` - Optional - name of the data - used to distinguish data files within the mod

### Datasaver object

Methods:

* `save(data)` - save the data in serialized form
* `load(exit_on_error)` - load the data
    * if `exit_on_error` is true, will cause minetest to exit rather than continue
    * default is `nil` so does not exit.
* `filepath()` - path of the actual storage file.

### Example

This could be an example `init.lua` file:

```lua

mymod = {}

-- local to init.lua
local dsobj = datasaver:new("rspawn", "players")

-- also local to init.lua
local playerdata = dsobj:load() or {}

--[[
The only save function exposed by your mod;
 allows other files in your mod to call it,
 but does not expose the data.
--]]
function mymod:save()
    dsobj:save(playerdata)
end
```
