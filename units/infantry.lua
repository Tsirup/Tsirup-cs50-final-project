Infantry = Object:extend()

function Infantry:new()
    self.cost = 1000
    self.spec = "Infantry"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 3
    self.moveType = "infantry"
    self.ready = false
    self.vision = 2
    self.fuel = 99
    self.health = 100
    self.combatType = "direct"
    self.selected = false
    self.movement = Movement(self)
    self.capture = 20
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Infantry:draw()
    local quad
    if self.team == "red" then
        quad = 1
    elseif self.team == "blue" then
        quad = 37
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end