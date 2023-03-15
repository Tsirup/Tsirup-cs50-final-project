Mech = Object:extend()

function Mech:new()
    self.cost = 3000
    self.spec = "Mech"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 2
    self.moveType = "mech"
    self.ready = false
    self.vision = 2
    self.fuel = 70
    self.health = 100
    self.combatType = "direct"
    self.selected = false
    self.movement = Movement(self)
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Mech:draw()
    local quad
    if self.team == "red" then
        quad = 151
    elseif self.team == "blue" then
        quad = 187
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end