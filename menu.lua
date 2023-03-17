-- very core component of the game
-- couldnt find any good tutorials or guides for this sort of pop-up menu online which is perplexing since i think menus are kinda important in games
-- so because of that I really had to take everything I've learned up to this point and utilize it to my upmost capability
Menu = Object:extend()

function Menu:new(unit)
    self.options = {}
    if unit then
        if type(unit) ~= "string" then
            self.unit = unit
            for _, neighbor in ipairs(Adjacent(unit.y, unit.x)) do
                for _, otherUnit in ipairs(UnitList) do
                    if otherUnit.team ~= Active_Player.color and otherUnit.y == neighbor[1] and otherUnit.x == neighbor[2] and not InTable(self.options, "Attack") then
                        table.insert(self.options, "Attack")
                        break
                    end
                end
            end
            if unit.capture and InTable(Property, Tilemap[Cursor.y][Cursor.x]) and not InTable(Active_Player.bases, Tilemap[Cursor.y][Cursor.x]) then
                table.insert(self.options, "Capture")
            end
            table.insert(self.options, "Wait")
        elseif InTable(Bases, Tilemap[Cursor.y][Cursor.x]) then
            self.options = Ground
        end
    else
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
        unit.movement = Movement(unit)
        unit.ready = false
        unit.selected = false
    elseif selection  == "Attack" then
    elseif selection == "Capture" then
        if unit.x ~= Cursor.x or unit.y ~= Cursor.y then
            unit.x = Cursor.x
            unit.y = Cursor.y
            unit.movement = Movement(unit)
            unit.capture = 20
        end
        unit.ready = false
        unit.selected = false
        unit.capture = MenuOpen.unit.capture - math.ceil(unit.health / 10)
        if unit.capture <= 0 then
            MapUpdate(unit.x, unit.y)
            unit.capture = 20
        end
    elseif selection == "End Turn" then
        EndTurn()
    elseif selection == "Infantry" and Active_Player.money >= 1000 then
        Infantry()
    elseif selection == "Mech" and Active_Player.money >= 3000 then
        Mech()
    elseif selection == "Tank" and Active_Player.money >= 7000 then
        Tank()
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