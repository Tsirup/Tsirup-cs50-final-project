---@diagnostic disable: duplicate-set-field
if arg[2] == "debug" then
    require("lldebugger").start()
end
function love.load()

    PriorityQueue = require("priorityqueue")
    Object = require "libraries/classic"
    Width = 16
    Height = 16
    World_quads = {}
    Prop_quads = {}
    Unit_quads = {}
    Icon_quads = {}
    UnitList = {}

    -- I modified these tilemaps with microsoft paint from the great templates at spriters-resource.com
    Overworld = love.graphics.newImage("graphics/overworld2bordertransparent.png")
    local image_width = Overworld:getWidth()
    local image_height = Overworld:getHeight()

    for i=0,21 do
        for j=0,21 do
            table.insert(World_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 2),
                    1 + i * (Height + 2),
                    Width, Height,
                    image_width, image_height))
        end
    end

    Properties = love.graphics.newImage("graphics/properties2bordertransparent.png")
    image_width = Properties:getWidth()
    image_height = Properties:getHeight()

    for i=0,5 do
        for j=0,17 do
            table.insert(Prop_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 2),
                    1 + i * (2 * Height + 2),
                    Width, 2 * Height,
                    image_width, image_height))
        end
    end

    Units = love.graphics.newImage("graphics/units2bordertransparent.png")
    image_width = Units:getWidth()
    image_height = Units:getHeight()

    for i=0,26 do
        for j=0,29 do
            table.insert(Unit_quads,
                love.graphics.newQuad(
                    1 + j * (Width + 1),
                    1 + i * (Height + 1),
                    Width, Height,
                    image_width, image_height))
        end
    end

    Icons = love.graphics.newImage("graphics/icons.png")
    image_width = Icons:getWidth()
    image_height = Icons:getHeight()

    for i=0,4 do
        for j=0,27 do
            table.insert(Icon_quads,
                love.graphics.newQuad(
                    1 + j * (Width / 2 + 1),
                    1 + i * (Height / 2 + 1),
                    Width / 2, Height / 2,
                    image_width, image_height))
        end
    end

    -- tilemap keys in keys.txt
    -- map files in maps folder, put whatever map you want here
    require("maps/BeanIsland")
    require("mapgen")
    require("units")
    require("movement")

    Transmap = MapTranslate(Tilemap)
    -- currently only have support for 2 players but the easy ability to add more is there
    -- I'd just need to add the relevant tilemap keys and spritemap index keys
    PlayerGen()
    UnitTypes = {"Infantry"}
    Cursor = {
        image = love.graphics.newImage("graphics/cursortransparent.png"),
        x = 1,
        y = 1,
    }
end

function IsEmpty(x,y)
    if x < 1 or y < 1 or x > #(Transmap[1]) or y > #(Transmap) then
        return false
    end
    return true
end

function love.keypressed(key)
    local valid = {"left", "right", "up", "down", "z", "x", "escape"}

    if not InTable(valid, key) then
        return
    end

    local x = Cursor.x
    local y = Cursor.y

    -- move this elsewhere when you implement End Turn
    if Active_Player == "red" then
        Bases = {08, 13, 18}
    elseif Active_Player == "blue" then
        Bases = {09, 14, 19}
    end

    if key == "left" then
        x = x - 1
    elseif key == "right" then
        x = x + 1
    elseif key == "up" then
        y = y - 1
    elseif key == "down" then
        y = y + 1
    elseif key == "z" then
        -- check if cursor is on unit
        for i, unit in ipairs(UnitList) do
            if unit.x == x and unit.y == y and unit.team == Active_Player then
                -- begin movement for that unit
                -- when finished, return
            end
        end
        -- check if cursor is on base
        if InTable(Bases, Tilemap[y][x]) then
            local locked = false
            for i, unit in ipairs(UnitList) do
                if unit.x == x and unit.y == y then
                    return
                end
            end
            Infantry()
        end
    elseif key == "escape" then
        love.event.push("quit")
    end

    if IsEmpty(x,y) then
        Cursor.x = x
        Cursor.y = y
    end
end

function love.update(dt)
end

function love.draw()
    -- to avoid bleeding upon scale, i wrote another python script which changes the borders of a spritemap to be the same color as the "actual border"
    -- check it out at border.py

    -- to properly layer the appropriate quads on top of one another, i wrote another python scipt which makes a particular RGBA value transparent
    -- check it out at transparent.py

    -- temporary scale for dev purposes
    love.graphics.scale(2,2)
    for i, row in ipairs(Transmap) do
        for j, tile in ipairs(row) do
            if tile > 0 then
                if tile < 463 then
                    love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                elseif tile < 2001 then
                    love.graphics.draw(Overworld, World_quads[1], j * Width, i * Height)
                    if tile < 485 then
                        love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                        love.graphics.draw(Overworld, World_quads[473], j * Width, (i-1) * Height)
                    else
                        love.graphics.draw(Properties, Prop_quads[tile-1000], j * Width, (i-1) * Height)
                    end
                end
            end
        end
    end
    for i, unit in ipairs(UnitList) do
        unit:draw()
        --remove this immeidately
        Movement(unit)
    end
    love.graphics.draw(Cursor.image, Cursor.x * Width, Cursor.y * Height)
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
---@diagnostic disable-next-line: undefined-global
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end