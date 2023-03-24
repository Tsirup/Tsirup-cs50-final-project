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
            for _, neighbor in ipairs(Adjacent(Cursor.y, Cursor.x)) do
                for _, otherUnit in ipairs(UnitList) do
                    if otherUnit.team ~= ActivePlayer.color and otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and not InTable(self.options, "Attack") then
                        table.insert(self.options, "Attack")
                        break
                    end
                end
            end
            if unit.capture and InTable(Property, Tilemap[Cursor.y][Cursor.x]) and not InTable(ActivePlayer.props, Tilemap[Cursor.y][Cursor.x]) then
                table.insert(self.options, "Capture")
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
    local unit = MenuOpen.unit
    local selected = MenuOpen.options[MenuOpen.cursor]
    if selected == "Wait" then
        if unit.x ~= Cursor.x or unit.y ~= Cursor.y then
            unit.x = Cursor.x
            unit.y = Cursor.y
            unit.fuel = unit.fuel - Cursor.fuel
        end
        unit.ready = false
        unit.selected = false
        Selection = false
        if unit.capture then
            unit.capture = 20
        end
    elseif selected  == "Attack" then
    elseif selected == "Capture" then
        if unit.x ~= Cursor.x or unit.y ~= Cursor.y then
            unit.x = Cursor.x
            unit.y = Cursor.y
            unit.fuel = unit.fuel - Cursor.fuel
            unit.capture = 20
        end
        unit.ready = false
        unit.selected = false
        Selection = false
        unit.capture = MenuOpen.unit.capture - math.ceil(unit.health / 10)
        if unit.capture <= 0 then
            MapUpdate(unit.x, unit.y)
            unit.capture = 20
        end
    elseif selected == "End Turn" then
        EndTurn()
    elseif selected == "Load" then
        for _, otherUnit in ipairs(UnitList) do
            if otherUnit.x == Cursor.x and otherUnit.y == Cursor.y then
                table.insert(otherUnit.cargo, unit)
                table.remove(UnitList, Index(UnitList, unit))
                -- dont forget this
                Selection = false
            end
        end
    else
        -- loads the selection string into a function and calls it if the selection exists
        local func = load(selected .. "()")
        if func then
            func()
        end
    end
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