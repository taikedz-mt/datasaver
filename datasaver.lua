--[[

'datasaver' library for Minetest - a simpe lib for saving
data to text files

Copyright (C) 2019 Tai "DuCake" Kedzierski

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

--]]






local this_mod = minetest.get_current_modname()
local ds_version = "20190125"

--[[
Safety check to not overwrite previously loaded datasaver.
--]]

if datasaver then
    if datasaver.name == "datasaver" then
        minetest.log("warning",
            "Previously loaded datasaver version "..datasaver.version..
            " from "..(datasaver.mod or "<unknown>").." detected - not loading ours ("..
            this_mod..", version "..ds_version..")"
        )
        return false
    else
        -- Neither loading or skipping is correct to do.
        error("A global 'datasaver' Lua table was found, but is not our kind of datasaver. Check your mods.")
    end
end

-- Mod code in earnest --¬

datasaver = {
    name = "datasaver",
    mod = this_mod,
    version = ds_version,
}

local function filepath(self)
    return minetest.get_worldpath().."/"..self.mod_name.."_"..(self.data_name or "data")..".lua.ser"
end

local function datasave(self, data)
	local serdata = minetest.serialize(data)

	if not serdata then
		minetest.log("error", "["..self.mod_name.."/"..self.data_name.."] Data serialization failed when saving.")
		return
	end

	local file, err = io.open(self:filepath(), "w")
	if err then
		return err
	end
	file:write(serdata)
	file:close()
end

local function dataload(self, exit_on_fail)
	local file, err = io.open(self:filepath(), "r")
    local data

	if not err then
        data = minetest.deserialize(file:read("*a"))
        file:close()

	else
        local error_message = "["..self.mod_name.."/"..self.data_name.."] Data read failed when loading."
        if exit_on_fail then
            error(error_message)
        else
            minetest.log("error", error_message)
        end
    end

    return data
end

function datasaver:new(modname, dataname)
    local def = {
        mod_name = modname,        -- name of the mod e.g. 'rspawn' / required
        data_name = dataname,      -- name of the data e.g. 'spawnpoints' / optional

        save = datasave,
        load = dataload,
        filepath = filepath,
    }

    return def
end

return true
