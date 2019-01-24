# Data Saver

Mod to save data to a local file in the world folder.

## API

### `datasaver:new(modname, dataname, defaultdata)`

Create a new data saver object. Returns a datasaver object, e.g.

    dsobj = datasaver:new("rspawn", "players")

Arguments

* `modname` - REQUIRED - name of the mod - used to distinguish data files from other mods
* `dataname` - Optional - name of the data - used to distinguish data files within the mod
* `defaultdata` - Optional - data that should be used if no data file is found or if data load fails

### Datasaver object

Methods:

* `dsobj:save(data)` - save the data in serialized form
* `dsobj:load()` - load the data
* `dsobj:filepath()` - path of the actual storage file.
