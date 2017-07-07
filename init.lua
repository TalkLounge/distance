-- clientmods/distance/init.lua
-- =================
-- See README.txt for licensing and other information.

local pos1
local pos2
local punchpos
local localplayer

minetest.register_on_connect(function()
    localplayer = minetest.localplayer
end)

local function round(x)
  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
  end
  return x-0.5
end

local function round2(x)
  local mult = 10^1
  return math.floor(x * mult + 0.5) / mult
end

minetest.register_chatcommand("dt", {
    params = "set_pos1 <pos> | set_pos2 <pos> | punch_pos1 | punch_pos2 | get_pos1 | get_pos2 | measure",
    description = "\n"..
    ".dt set_pos1 <pos>: Set position 1 with x y z or at your Position\n"..
    ".dt set_pos2 <pos>: Set position 2 with x y z or at your Position\n"..
    ".dt punch_pos1: Set position 1 at the last punched block\n"..
    ".dt punch_pos2: Set position 2 at the last punched block\n"..
    ".dt get_pos1: Get position 1\n"..
    ".dt get_pos2: Get position 2\n"..
    ".dt measure: Measure the length",
    func = function(param)
      local cmd = param
      local position = param:find(" ")
      if position then
        cmd = param:sub(1, position - 1)
        param = param:sub(position + 1)
      else
        param = ""
      end
      cmd = cmd:lower()
      
      if cmd == "set_pos1" then
        if param ~= "" then
          local found, _, x, y, z = param:find("^(-?%d+)[, ](-?%d+)[, ](-?%d+)$")
          if found then
            pos1 = vector.round({x = tonumber(x), y = tonumber(y), z = tonumber(z)})
            minetest.display_chat_message("First position selected at ".. pos1.x ..", ".. pos1.y ..", ".. pos1.z)
          else
            minetest.display_chat_message("Unknown position")
          end
        else
          pos1 = vector.round(localplayer:get_pos())
          minetest.display_chat_message("First position selected at ".. pos1.x ..", ".. pos1.y ..", ".. pos1.z)
        end
      end
      
      if cmd == "set_pos2" then
        if param ~= "" then
          local found, _, x, y, z = param:find("^(-?%d+)[, ](-?%d+)[, ](-?%d+)$")
          if found then
            pos2 = vector.round({x = tonumber(x), y = tonumber(y), z = tonumber(z)})
            minetest.display_chat_message("Second position selected at ".. pos2.x ..", ".. pos2.y ..", ".. pos2.z)
            if pos1 ~= nil then
              minetest.display_chat_message("Selected length are ".. round(vector.distance(pos1, pos2)) .." meters")
            else
              minetest.display_chat_message("First position not selected")
            end
          else
            minetest.display_chat_message("Unknown position")
          end
        else
          pos2 = vector.round(localplayer:get_pos())
          minetest.display_chat_message("Second position selected at ".. pos2.x ..", ".. pos2.y ..", ".. pos2.z)
          if pos1 ~= nil then
              minetest.display_chat_message("Selected length are ".. round(vector.distance(pos1, pos2)) .." meters")
            else
              minetest.display_chat_message("First position not selected")
            end
        end
      end
      
      if cmd == "punch_pos1" then
        if punchpos ~= nil then
          pos1 = punchpos
          minetest.display_chat_message("First position selected at ".. pos1.x ..", ".. pos1.y ..", ".. pos1.z)
        else
          minetest.display_chat_message("No block punched")
        end
      end
      
      if cmd == "punch_pos2" then
        if punchpos ~= nil then
          pos2 = punchpos
          minetest.display_chat_message("Second position selected at ".. pos2.x ..", ".. pos2.y ..", ".. pos2.z)
          if pos1 ~= nil then
              minetest.display_chat_message("Selected length are ".. round(vector.distance(pos1, pos2)) .." meters")
            else
              minetest.display_chat_message("First position not selected")
            end
        else
          minetest.display_chat_message("No block punched")
        end
      end
      
      if cmd == "get_pos1" then
        if pos1 ~= nil then
          minetest.display_chat_message("First position was selected at ".. pos1.x ..", ".. pos1.y ..", ".. pos1.z)
        else
          minetest.display_chat_message("No position selected")
        end
      end
      
      if cmd == "get_pos2" then
        if pos2 ~= nil then
          minetest.display_chat_message("Second position was selected at ".. pos2.x ..", ".. pos2.y ..", ".. pos2.z)
        else
          minetest.display_chat_message("No position selected")
        end
      end
      
      if cmd == "measure" then
        if pos1 ~= nil then
          if pos2 ~= nil then
            minetest.display_chat_message("Selected length are ".. round2(vector.distance(pos1, pos2)) .." meters")
          else
          minetest.display_chat_message("Second position not selected")
        end
      else
        minetest.display_chat_message("First position not selected")
      end
    end
    end})

minetest.register_on_punchnode(function(pos, node)
    punchpos = vector.round(pos)
  end)

