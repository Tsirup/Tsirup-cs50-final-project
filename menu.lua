-- very core component of the game
-- couldnt find any good tutorials or guides for this sort of pop-up menu online which is perplexing since i think menus are kinda important in games
-- so because of that I really had to take everything I've learned up to this point and utilize it to my upmost capability
Menu = Object:extend()

function Menu:new(unit)
    self.options = {}
    if unit then
        if type(unit) ~= "string" then
            self.unit = unit
            -- we must avoid overlapping units
            for _, otherUnit in ipairs(UnitList) do
                if otherUnit.x == Cursor.x and otherUnit.y == Cursor.y and otherUnit ~= unit then
                    if otherUnit.carry then
                        if InTable(otherUnit.carry, unit.spec) and #otherUnit.cargo < otherUnit.capacity then
                            table.insert(self.options, "Load")
                            self.cursor = 1
                            self.cursorimage = love.graphics.newImage("graphics/menucursortransparent.png")
                            MenuOpen = self
                            return
                        end
                    end
                    return
                end
            end
            if (unit.name == "Submarine" or unit.name == "StealthFighter") then
                if not unit.stealth then
                    if unit.name == "Submarine" then
                        table.insert(self.options, "Dive")
                    else
                        table.insert(self.options, "Hide")
                    end
                elseif unit.name == "Submarine" then
                    table.insert(self.options, "Rise")
                else
                    table.insert(self.options, "Reveal")
                end
            end
            if unit.name == "BlackBomb" then
                table.insert(self.options, "Explode")
            end
            -- change this to check if a unit is IN range before you let it attack
            for _, neighbor in ipairs(Adjacent(Cursor.y, Cursor.x)) do
                for _, otherUnit in ipairs(UnitList) do
                    if otherUnit.team ~= ActivePlayer.color and unit.range and otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] then
                        table.insert(self.options, "Attack")
                        goto rangeBreak
                    elseif (unit.name == "APC" or unit.name == "BlackBoat") and otherUnit.team == ActivePlayer.color and otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] then
                        table.insert(self.options, "Supply")
                        goto rangeBreak
                    end
                end
            end
            ::rangeBreak::
            if unit.capture then
                if InTable(Property, Tilemap[Cursor.y][Cursor.x]) and not InTable(ActivePlayer.props, Tilemap[Cursor.y][Cursor.x]) then
                    local remaining = 20 - unit.capture + math.ceil(unit.health / 10)
                    if remaining > 20 then
                        remaining = 20
                    end
                    table.insert(self.options, string.format("Capture - %d/20", remaining))
                elseif Tilemap[Cursor.y][Cursor.x] == 21 then
                    table.insert(self.options, "Launch")
                end
            end
            if unit.carry then
                if #unit.cargo > 0 then
                    table.insert(self.options, "Unload")
                end
            end
            table.insert(self.options, "Wait")
        elseif ActivePlayer.production[1] == Tilemap[Cursor.y][Cursor.x] then
            for _, groundUnit in ipairs(Ground) do
                if Cost[groundUnit] <= ActivePlayer.money then
                    table.insert(self.options, groundUnit)
                end
            end
        elseif ActivePlayer.production[2] == Tilemap[Cursor.y][Cursor.x] then
            for _, airUnit in ipairs(Air) do
                if Cost[airUnit] <= ActivePlayer.money then
                    table.insert(self.options, airUnit)
                end
            end
        elseif ActivePlayer.production[3] == Tilemap[Cursor.y][Cursor.x] then
            for _, navalUnit in ipairs(Naval) do
                if Cost[navalUnit] <= ActivePlayer.money then
                    table.insert(self.options, navalUnit)
                end
            end
        end
    end
    if #self.options == 0 then
        self.options = {"End Turn"}
    end
    self.cursor = 1
    self.cursorimage = love.graphics.newImage("graphics/menucursortransparent.png")
    MenuOpen = self
end

function Menu:select()
    -- I thought it would be better to turn all these if statements into local functions in here so that func() could load them, 
    -- it should work perfectly fine and avoid some if checks but it seems that the lua debugger doesn't like it so i guess ill leave it as is...
    -- i have not really used local functions at all in this project and it seems like a massive blunder? oh well lol
    local unit = MenuOpen.unit
    local selected = MenuOpen.options[MenuOpen.cursor]
    if unit then
        if unit.x ~= Cursor.x or unit.y ~= Cursor.y then
            for i, point in ipairs(UnitPath) do
                for _, otherUnit in ipairs(UnitList) do
                    if unit.team ~= otherUnit.team and otherUnit.y == point[1] and otherUnit.x == point[2] then
                        unit.y = UnitPath[i-1][1]
                        unit.x = UnitPath[i-1][2]
                        unit.fuel = unit.fuel - UnitPath[i-1][3]
                        selected = "Wait"
                        goto trapped
                    end
                end
            end
            unit.x = Cursor.x
            unit.y = Cursor.y
            unit.fuel = unit.fuel - Cursor.fuel
        end
    end
    ::trapped::
    if selected == "Wait" then
        unit.ready, unit.selected, Selection = false, false, false
        if unit.capture then
            unit.capture = 20
        end
    elseif selected  == "Attack" then
    elseif string.find(selected, "Capture") then
        if unit.x ~= Cursor.x or unit.y ~= Cursor.y then
            unit.capture = 20
        end
        unit.ready, unit.selected, Selection = false, false, false
        unit.capture = MenuOpen.unit.capture - math.ceil(unit.health / 10)
        if unit.capture <= 0 then
            MapUpdate(unit.x, unit.y)
            unit.capture = 20
        end
    elseif selected == "End Turn" then
        EndTurn()
        return
    elseif selected == "Load" then
        for _, otherUnit in ipairs(UnitList) do
            if otherUnit.x == Cursor.x and otherUnit.y == Cursor.y and otherUnit ~= unit then
                unit.selected = false
                unit.fuel = unit.fuelCapacity
                if unit.ammo then
                    unit.ammo = unit.ammoCapacity
                end
                table.insert(otherUnit.cargo, unit)
                table.remove(UnitList, Index(UnitList, unit))
                -- dont forget this
                Selection = false
            end
        end
    elseif selected == "Unload" then
        unit.action = Adjacent(unit.y, unit.x)
        unit.actionType = selected
    elseif selected == "Supply" then
        unit.ready, unit.selected, Selection = false, false, false
        for _, neighbor in ipairs(Adjacent(unit.y, unit.x)) do
            for _, otherUnit in ipairs(UnitList) do
                if unit.team == otherUnit.team and otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] then
                    otherUnit.fuel = otherUnit.fuelCapacity
                end
            end
        end
    elseif selected == "Hide" or selected == "Dive" then
        Stealth, unit.stealth = true, true
        unit.ready, unit.selected, Selection = false, false, false
        unit.revealed = false
        if selected == "Dive" then
            unit.spec = "sub"
        end
    elseif selected == "Reveal" or selected == "Rise" then
        unit.stealth = nil
        Stealth = false
        for _, otherUnit in ipairs(UnitList) do
            if otherUnit.stealth then
                Stealth = true
                break
            end
        end
        unit.ready, unit.selected, Selection = false, false, false
        if selected == "Rise" then
            unit.spec = "ship"
        end
    elseif selected == "Explode" then
        unit.action = Range(unit.y, unit.x, {0,1,2,3})
        unit.actionType = selected
    elseif selected == "Launch" then
    else
        -- loads the selection string into a function and calls it if the selection exists
        local func = load(selected .. "()")
        if func then
            func()
        end
    end
    -- by god this is cursed
    -- i dont wanna run these loops if i dont have to, so i only consider this if there are any stealthed units on the map, denoted by the global "Stealth"
    -- this is one of the few times i use goto in this whole project, it is the only way to break out of nested loops in lua without returning
    if Stealth then
        for _, otherUnit in ipairs(UnitList) do
            if otherUnit.stealth then
                for _, otherotherUnit in ipairs(UnitList) do
                    for _, neighbor in ipairs(Adjacent(otherUnit.y,otherUnit.x)) do
                        if otherUnit.team ~= otherotherUnit.team and otherotherUnit.y == neighbor[1] and otherotherUnit.x == neighbor[2] then
                            otherUnit.revealed = true
                            goto nextUnit
                        end
                    end
                end
                otherUnit.revealed = nil
            end
            ::nextUnit::
        end
    end
end

function Action(unit,actionType)
    if actionType == "Attack" then
    elseif actionType == "Unload" then
        local validCargo
        for _, otherUnit in ipairs(UnitList) do
            if otherUnit.x == Cursor.x and otherUnit.y == Cursor.y then
                return
            end
        end
        -- this crazy-looking chunk of code just makes sure if the first unit cant exist on the unloading zone, then check for any other units that can
        -- otherwise prevent all unloading
        for i=1,#unit.cargo do
            if Movecost[unit.cargo[i].moveType][Tilemap[Cursor.y][Cursor.x] + 1] ~= 99 then
                validCargo = i
                break
            else
                return
            end
        end
        unit.cargo[validCargo].x = Cursor.x
        unit.cargo[validCargo].y = Cursor.y
        unit.cargo[validCargo].ready = false
        table.insert(UnitList, unit.cargo[validCargo])
        table.remove(unit.cargo, validCargo)
    elseif actionType == "Explode" then
        for _, dangerZone in ipairs(unit.action) do
            for _, otherUnit in ipairs(UnitList) do
                if dangerZone[1] == otherUnit.y and dangerZone[2] == otherUnit.x then
                    otherUnit.health = otherUnit.health - 50
                    if otherUnit.health <= 0 then
                        otherUnit.health = 1
                    end
                end
            end
        end
        table.remove(UnitList, Index(UnitList, unit))
    end
    unit.action, unit.actionType = nil, nil
    unit.ready, unit.selected, Selection = false, false, false
end

function Menu:draw()
    local menuWidth = 0
    for _, option in ipairs(MenuOpen.options) do
        if (#(option) / 2) > menuWidth then
            menuWidth = #(option) / 2
        end
    end
    if Cost[MenuOpen.options[1]] then
        menuWidth = menuWidth * 1.5
    end
    love.graphics.rectangle("fill", Cursor.x * Width + Width, Cursor.y * Height, (menuWidth + 1) * Width, Height * #(MenuOpen.options))
    love.graphics.setColor(0,0,0,1)
    for i, option in ipairs(MenuOpen.options) do
        love.graphics.print(option, Cursor.x * Width + Width * 1.25, Cursor.y * Height + Height * (i-1))
        if Cost[option] then
            love.graphics.print(tostring(Cost[option]), Cursor.x * Width + Width * (menuWidth - 1), Cursor.y * Height + Height * (i-1))
        end
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(MenuOpen.cursorimage, Cursor.x * Width + Width, Cursor.y * Height + (3 * Height / 4) * (MenuOpen.cursor-1) + (Height / 4) * MenuOpen.cursor)
end