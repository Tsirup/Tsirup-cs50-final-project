Infantry = Object:extend()

function Infantry:new()
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player
    self.spec = "infantry"
    self.move = 3
    self.moveType = "infantry"
    self.ready = true
    self.vision = 2
    self.fuel = 99
    self.combatType = "direct"
    table.insert(UnitList, self)
end

function Infantry:draw()
    local quad
    if self.team == "red" then
        quad = 1
    else
        quad = 37
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end