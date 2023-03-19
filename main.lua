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

    Icons = love.graphics.newImage("graphics/icons2bordertransparent.png")
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
    Ground = {"Infantry", "Mech", "Tank", "Apc", "Artillery"}
    Transmap = MapTranslate(Tilemap)
    Selection = false
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
    for _, unit in ipairs(UnitList) do
        if unit.team == Active_Player.color then
            unit.movement = Movement(unit)
        end
    end
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

    if GameOver then
        if key == "escape" then
            love.event.push("quit")
        end
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
                    if not unit.selected and not Selection then
                        unit.selected = true
                        Selection = true
                        return
                    elseif not Selection then
                        unit.selected = false
                        Menu(unit)
                        return
                    else
                        return
                    end
                elseif unit.selected then
                    for _, validTile in ipairs(unit.movement) do
                        if validTile[1] == Cursor.y and validTile[2] == Cursor.x then
                            for _, otherUnit in ipairs(UnitList) do
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
                if unit.x == x and unit.y == y and (unit.ready == false or unit.team ~= Active_Player.color) then
                    Menu()
                    return
                end
            end
            Menu("build")
            return
        end
        Menu()
    elseif key == "x" then
        if Selection then 
            for _, unit in ipairs(UnitList) do
                unit.selected = false
            end
            Selection = false
        end
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

function TileTranslate(tile, i, j)
    local transmap = Transmap
    -- copy pasted code snippets from MapTranslate
    if tile == 06 then
        transmap[i][j] = 1006
    elseif tile == 07 then
        transmap[i][j] = 1024
    elseif tile == 08 then
        transmap[i][j] = 463
    elseif tile == 09 then
        transmap[i][j] = 465
    elseif tile == 13 then
        transmap[i][j] = 1007
    elseif tile == 14 then
        transmap[i][j] = 1025
    elseif tile == 18 then
        transmap[i][j] = 1008
    elseif tile == 19 then
        transmap[i][j] = 1026
    elseif tile == 24 then
        transmap[i][j] = 1109
    elseif tile == 25 then
        transmap[i][j] = 1027
    end
    Transmap = transmap
end

function MapUpdate(x,y)
    local loser, winner = nil, nil
    winner = Active_Player
    for _, player in ipairs(Players) do
        if InTable(player.bases, Tilemap[y][x]) then
            loser = player
        end
    end 
    if InTable(City, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[1]
    elseif InTable(Base, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[2]
    elseif InTable(HQ, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[1]
        for i = #Players, 1, -1 do
            if loser == Players[i] then
                -- delete all of the loser's units
                for j = #UnitList, 1, -1 do
                    if UnitList[j].team == loser.color then
                        table.remove(UnitList, j)
                    end
                end
                -- transfer over all of the loser's properties
                for i, row in ipairs(Tilemap) do
                    for j, tile in ipairs(row) do
                        if InTable(loser.bases, tile) then
                            MapUpdate(j,i)
                        end
                    end
                end
                -- remove the loser
                table.remove(Players, i)
            end
        end
    elseif InTable(Airport, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[4]
    elseif InTable(Port, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[5]
    elseif InTable(Lab, Tilemap[y][x]) then
        Tilemap[y][x] = winner.bases[6]
    end
    TileTranslate(Tilemap[y][x], y, x)
    winner.income = winner.income + 1000
    if loser then
        loser.income = loser.income - 1000
    end
end

function EndGame()
    local mWidth = #(Tilemap[1]) * Width
    local mHeight = #Tilemap * Height
    GameOver = true
    love.graphics.rectangle("fill", mWidth / 4, mHeight / 4, mWidth / 2, mHeight / 2)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(string.format("%s is the winner!", Active_Player.color), mWidth * (5/16), mHeight * (5/16))
    love.graphics.print("Press Esc to exit.", mWidth * (5/16), mHeight * (9/16))
    love.graphics.setColor(1,1,1,1)
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
            -- arbitrary rgba value for "unready" tint
            love.graphics.setColor(0.7,0.7,0.7,0.8)
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
    love.graphics.setColor(0,0,0,1)
    love.graphics.print("Player: " .. Active_Player.color, 20, 20)
    love.graphics.print("Money: " .. Active_Player.money, 20, 40)
    love.graphics.setColor(1,1,1,1)
    -- check for victory
    if #Players == 1 then
        EndGame()
    end
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