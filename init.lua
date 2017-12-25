hardcore_death = {}
hardcore_death.dead = {}
hardcore_death.file = minetest.get_worldpath().."/dead.txt"

function hardcore_death:load()
    local file = io.open(hardcore_death.file, "r")
    if file then
        hardcore_death.dead = minetest.deserialize(file:read("*all")) or {}
        file:close()
    end
end

function hardcore_death:save()
    local file = io.open(hardcore_death.file, "w")
    if file then
        file:write(minetest.serialize(hardcore_death.dead))
        file:close()
    end
end

minetest.register_on_dieplayer(function(player)
    hardcore_death.dead[player:get_player_name()] = true
    hardcore_death:save()
end)

local function kick_player(player)

    local playername = player:get_player_name()

    if hardcore_death.dead[playername] then
        minetest.kick_player(playername, playername .. " is dead")
    end
end

minetest.register_on_respawnplayer(function(player)
    kick_player(player)
end)

minetest.register_on_joinplayer(function(player)
    kick_player(player)
end)

hardcore_death:load()