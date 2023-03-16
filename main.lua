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
                    1 + j * (Width + 2),
                    1 + i * (Height + 2),
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
                    1 + j * (Width / 2 + 2),
                    1 + i * (Height / 2 + 2),
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
    require("menu")

    Scale = 2
    Camera = {x = 0, y = 0}
    MouseDown = false
    MenuOpen = nil
    Ground = {"Infantry", "Mech", "Tank"}
    Transmap = MapTranslate(Tilemap)
    -- currently only have support for 2 players but the easy ability to add more is there
    -- I'd just need to add the relevant tilemap keys and spritemap index keys
    Turn = 1
    PlayerGen()
    Cursor = {
        image = love.graphics.newImage("graphics/cursortransparent.png"),
        x = 1,
        y = 1,
    }
end

function EndTurn()
    for _, unit in ipairs(UnitList) do
        if unit.team == Active_Player.color then
            if not unit.ready then
                unit.ready = true
            end
        end
    end
    Turn = Turn + 1
    local active = Turn
    while active > #Players do
        active = active - #Players
    end
    Active_Player = Players[active]
    Active_Player.money = Active_Player.money + Active_Player.income
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

    if MenuOpen then
        if key == "z" then
            Menu:select()
            MenuOpen = nil
        elseif key == "x" then
            MenuOpen = nil
        elseif key == "up" and MenuOpen.cursor > 1 then
            MenuOpen.cursor = MenuOpen.cursor - 1
        elseif key == "down" and MenuOpen.cursor < #(MenuOpen.options) then
            MenuOpen.cursor = MenuOpen.cursor + 1
        end
        return
    end

    local x = Cursor.x
    local y = Cursor.y

    if Active_Player.color == "red" then
        Bases = {08, 13, 18}
    elseif Active_Player.color == "blue" then
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
        for _, unit in ipairs(UnitList) do
            if unit.team == Active_Player.color and unit.ready then
                -- begin movement for that unit
                if unit.x == Cursor.x and unit.y == Cursor.y then
                    if unit.selected == false then
                        unit.selected = true
                        return
                    else
                        unit.selected = false
                    end
                elseif unit.selected then
                    for _, validTile in ipairs(unit.movement) do
                        if validTile[1] == Cursor.y and validTile[2] == Cursor.x then
                            for _, otherUnit in ipairs(UnitList) do
                                -- TODO: exit movement with x
                                -- TODO: allow waiting/capturing/etc without moving(this elseif is ignored in that case so putting unit ~= otherUnit doesnt work)
                                -- TODO: stop telepathic capture
                                -- TODO: render captured property
                                if Cursor.x == otherUnit.x and Cursor.y == otherUnit.y then
                                    return
                                end
                            end
                            Menu(unit)
                            return
                        end
                    end
                end
            end
        end
        -- check if cursor is on base
        if InTable(Bases, Tilemap[y][x]) then
            for _, unit in ipairs(UnitList) do
                if unit.x == x and unit.y == y and unit.ready == false then
                    Menu()
                    return
                end
            end
            Menu("build")
            return
        end
        Menu()
    -- for whatever reason if I quit the game without using a quit event, theres a segmentation fault
    -- im not sure how to get it to not seg fault when I hit the exit button in the top right but it doesnt seem to mess anything up in the game so whatever
    elseif key == "escape" then
        love.event.push("quit")
    end

    if IsEmpty(x,y) then
        Cursor.x = x
        Cursor.y = y
    end
end

function love.mousepressed(x,y,button)
    if button == 1 then
        MouseDown = true
    end
end

function love.mousereleased(x,y,button)
    if button == 1 then
        MouseDown = false
    end
end

function love.wheelmoved(x,y)
    if y > 0 then
        Scale = Scale + 0.1
    end
    if y < 0 then
        Scale = Scale - 0.1
    end
end

function love.update(dt)
    -- extremely jank camera controls
    -- obviously unacceptable in its current state 
    -- but ultimately it is low priority compared to all of the actual gameplay stuff that needs to be worked on
    if MouseDown then
        local mouseX, mouseY = love.mouse.getPosition()
        Camera.x = -love.graphics.getWidth() / 2 + mouseX
        Camera.y = -love.graphics.getHeight() / 2 + mouseY
    end
end

function love.draw()
    -- to avoid bleeding upon scale, i wrote another python script which changes the borders of a spritemap to be the same color as the "actual border"
    -- check it out at border.py

    -- to properly layer the appropriate quads on top of one another, i wrote another python scipt which makes a particular RGBA value transparent
    -- check it out at transparent.py

    -- temporary scale for dev purposes
    love.graphics.scale(Scale,Scale)
    love.graphics.translate(Camera.x, Camera.y)
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
        if not unit.ready then
            love.graphics.setColor(0.8,0.8,0.8,0.7)
        end
        unit:draw()
        love.graphics.setColor(1,1,1,1)
        if unit.selected then
            -- arbitrary rgba value for selection tint
            love.graphics.setColor(0.5,0.8,0.9,0.7)
            for _, validTile in ipairs(unit.movement) do
                love.graphics.rectangle("fill", validTile[2] * Width, validTile[1] * Height, Width, Height)
            end
            love.graphics.setColor(1,1,1,1)
        end
    end
    if MenuOpen then
        Menu:draw()
    end
    love.graphics.draw(Cursor.image, Cursor.x * Width, Cursor.y * Height)
    love.graphics.print("Player: " .. Active_Player.color, 20, 20)
    love.graphics.print("Money: " .. Active_Player.money, 20, 40)
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