-- very core component of the game
-- couldnt find any good tutorials or guides for this sort of pop-up menu online which is perplexing since i think menus are kinda important in games
-- so because of that I really had to take everything I've learned up to this point and utilize it to my upmost capability
Menu = Object:extend()

function Menu:new(unit)
    MenuOpen = self
    self.options = {}
    if unit then
        for _, neighbor in ipairs(Adjacent(unit.y, unit.x)) do
            for _, otherUnit in ipairs(UnitList) do
                if otherUnit.y == Adjacent[1] and otherUnit.x == Adjacent[2] and not InTable(self.options, "Attack") then
                    table.insert(self.options, "Attack")
                    break
                end
            end
        end
        if InTable(Property, Tilemap[unit.y][unit.x]) and not InTable(Active_Player.bases, Tilemap[unit.y][unit.x]) then
            table.insert(self.options, "Capture")
        end
        table.insert(self.options, "Wait")
    elseif InTable(Bases, Tilemap[Cursor.y][Cursor.x]) then
        self.options = {"Infantry"}
    else
        self.options = {"End Turn"}
    end
    self.cursor = 1
    self.cursorimage = love.graphics.newImage("graphics/menucursortransparent")
end

function Menu:select()
    --statements
end

function Menu:draw()
    love.graphics.rectangle("fill", Cursor.x + Width, Cursor.y, Width * 2, Height * #self.options)
    for i, option in ipairs(self.options) do
        love.graphics.print(option, Cursor.x + Width * 1.25, Cursor.y + Height * (i-1))
    end
    love.graphics.draw(self.cursorimage, Cursor.x + Width, Cursor.y + Height * (self.cursor-1))
end