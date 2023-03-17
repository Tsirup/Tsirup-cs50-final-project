Artillery = Object:extend()

function Artillery:new()
    self.cost = 6000
    self.spec = "Artillery"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 5
    self.moveType = "tread"
    self.ready = false
    self.vision = 1
    self.fuel = 50
    self.health = 100
    self.range = {2,3}
    self.selected = false
    self.movement = nil
    self.ammo = 9
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Artillery:draw()
    local quad
    if self.team == "red" then
        quad = 481
    elseif self.team == "blue" then
        quad = 487
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
end