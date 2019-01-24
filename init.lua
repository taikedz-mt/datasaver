datasaver = {
    name = "datasaver",
    version = "20190124",
}

local function filepath(self)
    return minetest.get_worldpath().."/"..self.mod_name.."_"..(self.data_name or "data")..".lua.ser"
end

local function datasave(self, data)
	local serdata = minetest.serialize(data)

	if not serdata then
		minetest.log("error", "["..self.mod_name.."/"..self.data_name.."] Data serialization failed")
		return
	end

	local file, err = io.open(self:filepath(), "w")
	if err then
		return err
	end
	file:write(serdata)
	file:close()
end

local function dataload(self)
	local file, err = io.open(self:filepath(), "r")
    local data

	if not err then
        data = minetest.deserialize(file:read("*a"))
        file:close()

	else
		minetest.log("error", "["..self.mod_name.."/"..self.data_name.."] Data read failed - initializing")

        if self.initialize then
            data = self.initialize()
        else
            data = {}
        end
    end

    return data
end

function datasaver:new(modname, dataname, defaultdata)
    local def = {
        mod_name = modname,        -- name of the mod e.g. 'rspawn' / required
        data_name = dataname,      -- name of the data e.g. 'spawnpoints' / optional
        initialize = initfunction, -- default data / optional / e.g. {default = {x=0,y=0,z=0}}

        save = datasave,
        load = dataload,
        filepath = filepath,
    }

    return def
end
