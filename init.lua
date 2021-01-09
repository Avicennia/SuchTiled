local modn = minetest.get_current_modname()
local modp = minetest.get_modpath(modn)
local modstore = minetest.get_mod_storage()
local worldp = minetest.get_worldpath()
local tiled = {}

tiled.raw = {}
tiled.converted = {}
local exportfile_name = worldp.."/suchtiled_export.txt"
-------------------------------------------------------------------------------------
--FUNCTIONS
-------------------------------------------------------------------------------------
function say(x)
    return minetest.chat_send_all(type(x) == "string" and x or minetest.serialize(x))
end

minetest.register_chatcommand("suchtiled", {
    params = "interact",
    description = "Converts file",
    privs = {interact=true},
    func = function(name, param)
        local spcs = function(param, n)
            return string.find(param, " ",n or 1)
        end
        local space1 = spcs(param)
        if(param)then
            local rdata = dofile(modp.."/"..param..".lua") -- for testing param should be "testexport" when you call the command.
            if(rdata)then
                --say(rdata.layers[1].data)
                rdata = {
                    width = rdata.layers[1].width,
                    height = rdata.layers[1].height,
                    name = rdata.layers[1].name,
                    data = rdata.layers[1].data
                }
                local cdata = {data = {}} -- final converted table
                local count = 0
                for n = 1, rdata.height do 
                    for nn = 1, rdata.width do
                        count = count + 1
                        cdata.data[count] = rdata.data[nn+(rdata.width*(rdata.height-(1*n)))]
                    end
                end
                local nodes = { -- Temporary nodenames for testing
                    [0] = "air",
                    [21] = "nc_terrain:dirt_with_grass",
                    [31] = "nc_terrain:cobble",
                    [33] = "nc_terrain:stone",
                    [41] = "nc_lode:block_annealed",
                    [43] = "nc_woodwork:plank"
                }
                for n = 1, #cdata.data do -- Setting the data fields
                    cdata.data[n] = {name = nodes[cdata.data[n]]}
                end
                cdata.size = {x = rdata.width, z = rdata.height, y = 1}
                minetest.place_schematic(minetest.get_player_by_name(name):get_pos(),cdata,_,_,true)
               -- say(cdata)
            end
        else say("File conversion error!")

        end
    end
})