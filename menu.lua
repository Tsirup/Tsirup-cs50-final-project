-- very core component of the game
-- couldnt find any good tutorials or guides for this sort of pop-up menu online which is perplexing since i think menus are kinda important in games
-- so because of that I really had to take everything I've learned up to this point and utilize it to my upmost capability
Menu = Object:extend()

function Menu:new(unit)
    self.options = {}
    if unit then
        if type(unit) ~= "string" then
            self.unit = unit
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
    local selection = MenuOpen.options[MenuOpen.cursor]
    if selection == "Wait" then
        unit.x = Cursor.x
        unit.y = Cursor.y
        unit.fuel = unit.fuel - Cursor.fuel
        unit.ready = false
        unit.selected = false
        Selection = false
        if unit.capture then
            unit.capture = 20
        end
    elseif selection  == "Attack" then
    elseif selection == "Capture" then
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
    elseif selection == "End Turn" then
        EndTurn()
    else
        -- loads the selection string into a function and calls it if the selection exists
        local func = load(selection .. "()")
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
    love.graphics.rectangle("fill", Cursor.x * Width + Width, Cursor.y * Height, menuWidth * Width, Height * #(MenuOpen.options))
    love.graphics.setColor(0,0,0,1)
    for i, option in ipairs(MenuOpen.options) do
        love.graphics.print(option, Cursor.x * Width + Width * 1.25, Cursor.y * Height + Height * (i-1))
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(MenuOpen.cursorimage, Cursor.x * Width + Width, Cursor.y * Height + (3 * Height / 4) * (MenuOpen.cursor-1) + (Height / 4) * MenuOpen.cursor)
end