Unit = Object:extend()

function Unit:new()
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = ActivePlayer.color
    self.ready = false
    self.health = 100
    self.selected = false
    self.fuelCapacity = self.fuel
end

function Unit:draw()
    love.graphics.draw(Units, Unit_quads[self.quad], self.x * Width, self.y * Height)
    if self.fuel <= self.fuelCapacity / 3 then
        love.graphics.draw(Icons, Icon_quads[47], self.x * Width + Width / 2, self.y * Height)
    end
end