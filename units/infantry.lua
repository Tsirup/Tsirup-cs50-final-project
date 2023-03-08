Infantry = Object:extend()

function Infantry:new()
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player
    self.spec = "infantry"
    self.move = 3
    self.moveType = "infantry"
    self.vision = 2
    self.fuel = 99
    self.combatType = "direct"
    table.insert(UnitList, self)
end

function Infantry:draw()
    local quad
    if self.team == "blue" then
        quad = 37
    else
        quad = 1
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end