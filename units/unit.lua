Unit = Object:extend()

function Unit:new()
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.ready = false
    self.health = 100
    self.selected = false
    Active_Player.money = Active_Player.money - self.cost
end

function Unit:draw()
    love.graphics.draw(Units, Unit_quads[self.quad], self.x * Width, self.y * Height)
end