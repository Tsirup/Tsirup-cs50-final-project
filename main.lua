---@diagnostic disable: duplicate-set-field
if arg[2] == "debug" then
    require("lldebugger").start()
end
function love.load(args)
    PriorityQueue = require("priorityqueue")
    -- my only borrowed library for this project
    Object = require "libraries/classic"
    Width = 16
    Height = 16
    World_quads = {}
    Prop_quads = {}
    Unit_quads = {}
    Icon_quads = {}
    UnitList = {}
    Unitmap = nil

    -- I modified these tilemaps with microsoft paint from the great templates at spriters-resource.com
    Overworld = love.graphics.newImage("graphics/overworld3bordertransparent.png")
    local image_width = Overworld:getWidth()
    local image_height = Overworld:getHeight()
    for i=0,57 do
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

    Units = love.graphics.newImage("graphics/units5bordertransparent.png")
    image_width = Units:getWidth()
    image_height = Units:getHeight()
    for i=0,33 do
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

    require("mapgen")
    require("units")
    require("movement")
    require("menu")
    -- tilemap keys in keys.txt
    -- map files in maps folder
    -- if you give it a command line argument it will load the map given, otherwise it will give the default debugging map
    if #args ~= 1 or args[1] == "debug" then
        require("maps/BeanIsland")
    else
        require("maps/" .. args[1])
    end
    Scale = 2
    Camera = {x = 0, y = 0}
    Ground = {"Infantry", "Mech", "Recon", "Tank", "MediumTank", "NeoTank", "MegaTank", "APC", "Artillery", "Rockets", "AntiAir", "Missles", "PipeRunner"}
    Air = {"Fighter", "Bomber", "BattleCopter", "TransportCopter", "StealthFighter", "BlackBomb"}
    Naval = {"Battleship", "Cruiser", "Lander", "Submarine", "BlackBoat", "AircraftCarrier"}
    -- we have this because we need some way to get the cost of a unit before it is built to show whether or not we can build it
    Cost = {Infantry = 1000, Mech = 3000, Recon = 4000, Tank = 7000, MediumTank = 16000,
            NeoTank = 22000, MegaTank = 28000, APC = 5000, Artillery = 6000, Rockets = 15000,
            AntiAir = 8000, Missles = 12000, PipeRunner = 20000, Fighter = 20000, Bomber = 22000,
            BattleCopter = 9000, TransportCopter = 5000, StealthFighter = 24000, BlackBomb = 25000, Battleship = 28000,
            Cruiser = 18000, Lander = 12000, Submarine = 20000, BlackBoat = 7500, AircraftCarrier = 30000}
    Transmap = MapTranslate(Tilemap)
    MouseDown, Selection, Stealth = false, false, false
    Turn = 1
    PlayerGen()
    Cursor = {
        image = love.graphics.newImage("graphics/cursortransparent.png"),
        y = 1,
        x = 1
    }
    if ActivePlayer.cursor then
        Cursor.y = ActivePlayer.cursor[1]
        Cursor.x = ActivePlayer.cursor[2]
    end
    if Unitmap then
        for _, unit in ipairs(Unitmap) do
            Deploy = unit
            Deploy[1]()
        end
        ActivePlayer.money = ActivePlayer.income
        Deploy = nil
    end
end

function EndTurn()
    -- potentially move this into the next for loop for optimization? but make sure it does this for the previous player then
    for _, unit in ipairs(UnitList) do
        unit.previousX, unit.previousY, unit.previousFuel = nil, nil, nil
        if unit.team == ActivePlayer.color then
            unit.ready = true
            unit.selected = false
        end
    end
    Selection = false
    Turn = Turn + 1
    local active = Turn
    while active > #Players do
        active = active - #Players
    end
    ActivePlayer.cursor[1] = Cursor.y
    ActivePlayer.cursor[2] = Cursor.x
    ActivePlayer = Players[active]
    ActivePlayer.money = ActivePlayer.money + ActivePlayer.income
    if ActivePlayer.cursor then
        Cursor.y = ActivePlayer.cursor[1]
        Cursor.x = ActivePlayer.cursor[2]
    end
    -- we have 3 very similar if statements here because we have to follow the proper procedure order of:
    -- decrement fuel from units -> resupply units -> destroy units
    for _, unit in ipairs(UnitList) do
        if unit.team == ActivePlayer.color then
            unit.movement = Movement(unit)
            if unit.spec ~= "infantry" and unit.spec ~= "vehicle" then
                if unit.spec == "ship" then
                    unit.fuel = unit.fuel - 1
                elseif unit.spec == "copter" then
                    unit.fuel = unit.fuel - 2
                elseif unit.spec == "plane" then
                    if not unit.stealth then
                        unit.fuel = unit.fuel - 5
                    else
                        unit.fuel = unit.fuel - 8
                    end
                elseif unit.spec == "sub" then
                    unit.fuel = unit.fuel - 5
                end
            end
        end
    end
    for i, unit in ipairs(UnitList) do
        if unit.team == ActivePlayer.color then
            -- this should be okay??? definitely doesnt look okay i'll admit
            if unit.name == "APC" or unit.name == "BlackBoat" then
                for _, neighbor in ipairs(Adjacent(unit.y, unit.x)) do
                    for _, otherUnit in ipairs(UnitList) do
                        if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and unit.team == otherUnit.team then
                            otherUnit.fuel = otherUnit.fuelCapacity
                            if otherUnit.ammo then
                                otherUnit.ammo = otherUnit.ammoCapacity
                            end
                        end
                    end
                end
            end
        end
    end
    for i, unit in ipairs(UnitList) do
        if unit.team == ActivePlayer.color then
            if unit.spec ~= "infantry" and unit.spec ~= "vehicle" then
                if unit.fuel <= 0 then
                    table.remove(UnitList, i)
                end
                if unit.spec == "copter" or unit.spec == "plane" then
                    if Tilemap[unit.y][unit.x] == ActivePlayer.props[4] and unit.health < 100 then
                        Heal(unit,20)
                    end
                else
                    if Tilemap[unit.y][unit.x] == ActivePlayer.props[5] and unit.health < 100 then
                        Heal(unit,20)
                    end
                end
            elseif InTable({ActivePlayer.props[1], ActivePlayer.props[2], ActivePlayer.props[3], ActivePlayer.props[6]}, Tilemap[unit.y][unit.x]) and unit.health < 100 then
                Heal(unit,20)
            end
            if unit.name == "BlackBoat" then
                for _, neighbor in ipairs(Adjacent(unit.y, unit.x)) do
                    for _, otherUnit in ipairs(UnitList) do
                        if otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and unit.team == otherUnit.team and unit.health < 100 then
                            Heal(otherUnit,10)
                        end
                    end
                end
            end
        end
    end
end

function Heal(unit,default)
    local repairCost = math.floor(Cost[unit.name] * (default / 100))
    if (ActivePlayer.money / repairCost) < 1 then
        default = math.floor(default * (ActivePlayer.money / repairCost))
        ActivePlayer.money = 0
    else
        ActivePlayer.money = ActivePlayer.money - repairCost
    end
    unit.health = unit.health + default
    if unit.health > 100 then
        local surplus = unit.health - 100
        unit.health = 100
        ActivePlayer.money = math.floor(ActivePlayer.money + Cost[unit.name] * (surplus / 100))
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
            if unit.team == ActivePlayer.color and unit.ready then
                if unit.action then
                    for _, actionTile in ipairs(unit.action) do
                        if actionTile[1] == y and actionTile[2] == x then
                            Action(unit, unit.actionType)
                            return
                        end
                    end
                    return
                end
                -- begin movement for that unit
                if unit.x == x and unit.y == y then
                    -- what the hell is going on here
                    if not unit.selected and not Selection then
                        unit.selected = true
                        Selection = true
                        return
                    elseif unit.selected then
                        Menu(unit)
                        return
                    end
                elseif unit.selected then
                    for _, validTile in ipairs(unit.movement) do
                        if validTile[1] == y and validTile[2] == x then
                            Cursor.fuel = validTile[3]
                            Menu(unit)
                            return
                        end
                    end
                end
            end
        end
        -- check if cursor is on base
        if InTable(ActivePlayer.production, Tilemap[y][x]) then
            for _, unit in ipairs(UnitList) do
                if unit.x == x and unit.y == y and (unit.ready == false or unit.team ~= ActivePlayer.color) then
                    Menu()
                    return
                end
            end
            Menu("Build")
            return
        end
        Menu()
    elseif key == "x" then
        if Selection then
            for _, unit in ipairs(UnitList) do
                if unit.action then
                    unit.action, unit.actionType = nil, nil
                    if unit.previousFuel then
                        unit.x = unit.previousX
                        unit.y = unit.previousY
                        unit.fuel = unit.previousFuel
                    end
                end
                unit.selected, Selection = false, false
            end
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
        transmap[i][j] = 2006
    elseif tile == 07 then
        transmap[i][j] = 2024
    elseif tile == 08 then
        transmap[i][j] = 463
    elseif tile == 09 then
        transmap[i][j] = 465
    elseif tile == 13 then
        transmap[i][j] = 2007
    elseif tile == 14 then
        transmap[i][j] = 2025
    elseif tile == 18 then
        transmap[i][j] = 2008
    elseif tile == 19 then
        transmap[i][j] = 2026
    elseif tile == 22 then
        transmap[i][j] = 2102
    elseif tile == 24 then
        transmap[i][j] = 2109
    elseif tile == 25 then
        transmap[i][j] = 2027
    elseif tile == 28 then
        local matrix = MatrixTranslate(Neighbors(i,j), "pipe")
        if matrix[2][1] == 1 and matrix[2][3] == 1 then
            transmap[i][j] = 52
        elseif matrix[1][2] == 1 and matrix[3][2] == 1 then
            transmap[i][j] = 53
        else
            transmap[i][j] = 52
        end
    elseif tile == 29 then
        transmap[i][j] = 2042
    elseif tile == 30 then
        transmap[i][j] = 467
    elseif tile == 31 then
        transmap[i][j] = 2039
    elseif tile == 32 then
        transmap[i][j] = 2043
    elseif tile == 33 then
        transmap[i][j] = 2044
    elseif tile == 34 then
        transmap[i][j] = 2045
    elseif tile == 35 then
        transmap[i][j] = 2060
    elseif tile == 36 then
        transmap[i][j] = 469
    elseif tile == 37 then
        transmap[i][j] = 2058
    elseif tile == 38 then
        transmap[i][j] = 2061
    elseif tile == 39 then
        transmap[i][j] = 2062
    elseif tile == 40 then
        transmap[i][j] = 2063
    elseif tile == 41 then
        transmap[i][j] = 2078
    elseif tile == 42 then
        transmap[i][j] = 471
    elseif tile == 43 then
        transmap[i][j] = 2077
    elseif tile == 44 then
        transmap[i][j] = 2079
    elseif tile == 45 then
        transmap[i][j] = 2080
    elseif tile == 46 then
        transmap[i][j] = 2081
    end
    Transmap = transmap
end

function MapUpdate(y,x)
    local loser, winner
    winner = ActivePlayer
    for _, player in ipairs(Players) do
        if InTable(player.props, Tilemap[y][x]) then
            loser = player
        end
    end
    if InTable({3,12,16,17,23}, Tilemap[y][x]) then
        loser = "neutral"
    end
    if loser then
        if InTable(City, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[1]
        elseif InTable(Base, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[2]
        elseif InTable(HQ, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[1]
            for i = #Players, 1, -1 do
                if loser == Players[i] then
                    -- delete all of the loser's units
                    for j = #UnitList, 1, -1 do
                        if UnitList[j].team == loser.color then
                            table.remove(UnitList, j)
                        end
                    end
                    -- transfer over all of the loser's properties
                    for ti, row in ipairs(Tilemap) do
                        for tj, tile in ipairs(row) do
                            if InTable(loser.props, tile) then
                                MapUpdate(ti,tj)
                            end
                        end
                    end
                    -- remove the loser
                    table.remove(Players, i)
                end
            end
        elseif InTable(Airport, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[4]
        elseif InTable(Port, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[5]
        elseif InTable(Lab, Tilemap[y][x]) then
            Tilemap[y][x] = winner.props[6]
        end
        winner.income = winner.income + 1000
        if type(loser) ~= "string" then
            loser.income = loser.income - 1000
        end
    else
        if Tilemap[y][x] == 21 then
            Tilemap[y][x] = 22
        -- implies that the tile was a pipe seam
        else
            Tilemap[y][x] = 28
        end
    end
    TileTranslate(Tilemap[y][x], y, x)
end

function EndGame()
    local mWidth = #(Tilemap[1]) * Width
    local mHeight = #Tilemap * Height
    GameOver = true
    love.graphics.rectangle("fill", mWidth / 4, mHeight / 4, mWidth / 2, mHeight / 2)
    love.graphics.setColor(0,0,0,1)
    love.graphics.print(string.format("%s is the winner!", ActivePlayer.color), mWidth * (5/16), mHeight * (5/16))
    love.graphics.print("Press Esc to exit.", mWidth * (5/16), mHeight * (9/16))
    love.graphics.setColor(1,1,1,1)
end

function Arrow(path)
    -- this is really ugly and terrible
    -- why is this so much harder and uglier than what i did before with the tilemaps?
    -- because for the tilemaps the "arrows" for roads for instance were already drawn out on a grid
    -- here, we could totally complete this function by having a grid and fill it out with 1s and 0s depending on if theres a path-point there
    -- that would make the code much less ugly and we could use a translation method we've already done before
    -- however that would just be slower, i hope i dont have to explain why filling a big 2d grid out, where most of the spaces will be empty
    -- and then iterating through the whole grid is much slower than just having a few if-checks per point in the path,
    -- and because this is supposed to run every time the player moves their cursor, we just cant have it be slow
    -- im sure there is some super-brilliant algorithm that im forgetting about or dont know about, oh well
    local arrow = path
    UnitPath = path
    for i, point in ipairs(path) do
        if i == 1 then
            if path[i+1][1] > point[1] then
                table.insert(arrow[i],991)
            elseif path[i+1][1] < point[1] then
                table.insert(arrow[i],996)
            elseif path[i+1][2] < point[2] then
                table.insert(arrow[i],998)
            else
                table.insert(arrow[i],1002)
            end
        elseif i ~= #path then
            if path[i+1][1] > point[1] then
                if point[1] > path[i-1][1] then
                    table.insert(arrow[i],995)
                elseif point[2] > path[i-1][2] then
                    table.insert(arrow[i],994)
                else
                    table.insert(arrow[i],993)
                end
            elseif path[i+1][1] < point[1] then
                if point[1] < path[i-1][1] then
                    table.insert(arrow[i],995)
                elseif point[2] < path[i-1][2] then
                    table.insert(arrow[i],999)
                else
                    table.insert(arrow[i],1000)
                end
            elseif path[i+1][2] < point[2] then
                if point[2] < path[i-1][2] then
                    table.insert(arrow[i],1003)
                elseif point[1] < path[i-1][1] then
                    table.insert(arrow[i],994)
                else
                    table.insert(arrow[i],1000)
                end
            elseif path[i+1][2] > point[2] then
                if point[2] > path[i-1][2] then
                    table.insert(arrow[i],1003)
                elseif point[1] > path[i-1][1] then
                    table.insert(arrow[i],999)
                else
                    table.insert(arrow[i],993)
                end
            end
        else
            if point[1] > path[i-1][1] then
                table.insert(arrow[i],1001)
            elseif point[1] < path[i-1][1] then
                table.insert(arrow[i],992)
            elseif point[2] < path[i-1][2] then
                table.insert(arrow[i],997)
            else
                table.insert(arrow[i],1004)
            end
        end
    end
    return arrow
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
    -- note that this configuration of drawing is just barely light enough for me not to have an ordering table where i store all the sprites, order them correctly, and then draw the whole table
    -- if i add any more hypothetical layers, of which right now I have something like 4 or 5, then it would then become worth it to refactor this code for that
    -- as of now however, im not exactly convinced that that method is more optimized
    for i, row in ipairs(Transmap) do
        for j, tile in ipairs(row) do
            -- the > 0 check just prevents it from crashing when you have to have a "blank" tile, you can remove this when not debugging
            if tile > 0 then
                if tile < 2001 then
                    if tile > 462 and tile < 506 then
                        love.graphics.draw(Overworld, World_quads[1], j * Width, i * Height)
                        love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                        love.graphics.draw(Overworld, World_quads[473], j * Width, (i-1) * Height)
                    else
                        love.graphics.draw(Overworld, World_quads[tile], j * Width, i * Height)
                    end
                else
                    love.graphics.draw(Overworld, World_quads[1], j * Width, i * Height)
                    love.graphics.draw(Properties, Prop_quads[tile-2000], j * Width, (i-1) * Height)
                end
            end
        end
    end
    for _, unit in ipairs(UnitList) do
        if (not unit.stealth or ActivePlayer.color == unit.team or unit.revealed) and not unit.selected then
            unit:draw()
        end
    end
    if Selection then
        for _, unit in ipairs(UnitList) do
            if unit.selected then
                if not unit.action then
                    -- arbitrary rgba value for movement tint
                    love.graphics.setColor(0.5,0.8,0.9,0.7)
                    for _, validTile in ipairs(unit.movement) do
                        love.graphics.rectangle("fill", validTile[2] * Width, validTile[1] * Height, Width, Height)
                    end
                    love.graphics.setColor(1,1,1,1)
                    for _, validTile in ipairs(unit.movement) do
                        if validTile[1] == Cursor.y and validTile[2] == Cursor.x and not (unit.x == Cursor.x and unit.y == Cursor.y) then
                            for _, part in ipairs(Arrow(validTile[4])) do
                                love.graphics.draw(Units, Unit_quads[part[4]], part[2] * Width, part[1] * Height)
                            end
                        end
                    end
                else
                    -- arbitrary rgba value for action tint
                    love.graphics.setColor(1,0.8,0.8,0.7)
                    for _, validTile in ipairs(unit.action) do
                        love.graphics.rectangle("fill", validTile[2] * Width, validTile[1] * Height, Width, Height)
                    end
                end
            love.graphics.setColor(1,1,1,1)
            unit:draw()
            break
            end
        end
    end
    if MenuOpen then
        Menu:draw()
    end
    love.graphics.draw(Cursor.image, Cursor.x * Width, Cursor.y * Height)
    love.graphics.print("Player: " .. ActivePlayer.color, 20, #Tilemap * Height + 20)
    love.graphics.print("Money: " .. ActivePlayer.money, 20, #Tilemap * Height + 40)
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