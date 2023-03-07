---@diagnostic disable: duplicate-set-field
if arg[2] == "debug" then
    require("lldebugger").start()
end
function love.load()

    Object = require "libraries/classic"
    Width = 16
    Height = 16
    World_quads = {}
    Prop_quads = {}
    Unit_quads = {}
    Icon_quads = {}

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

    Units = love.graphics.newImage("graphics/units.png")
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

    -- map keys in keys.txt
    -- map files in maps folder, put whatever map you want here
    require("maps/BeanIsland")

    Transmap = MapTranslate(Tilemap)

    Cursor = {
        image = love.graphics.newImage("graphics/cursortransparent.png"),
        x = 1,
        y = 1,
    }
end

require ("mapgen")

function love.keypressed(key)
    local x = Cursor.x
    local y = Cursor.y

    if key == "left" then
        x = x - 1
    elseif key == "right" then
        x = x + 1
    elseif key == "up" then
        y = y - 1
    elseif key == "down" then
        y = y + 1
    end

    Cursor.x = x
    Cursor.y = y
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
    for i,row in ipairs(Transmap) do
        for j,tile in ipairs(row) do
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