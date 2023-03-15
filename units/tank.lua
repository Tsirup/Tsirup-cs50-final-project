Tank = Object:extend()

function Tank:new()
    self.cost = 7000
    self.spec = "Tank"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 6
    self.moveType = "tread"
    self.ready = false
    self.vision = 3
    self.fuel = 70
    self.health = 100
    self.combatType = "direct"
    self.selected = false
    self.movement = Movement(self)
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Tank:draw()
    local quad
    if self.team == "red" then
        quad = 331
    elseif self.team == "blue" then
        quad = 337
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end