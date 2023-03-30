Unit = Object:extend()

function Unit:new()
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = ActivePlayer.color
    self.teamOrder = ActivePlayer.order
    self.ready = false
    self.health = 100
    self.selected = false
    self.fuelCapacity = self.fuel
    if self.ammo then
        self.ammoCapacity = self.ammo
    end
    table.insert(UnitList, self)
end

function Unit:predeployed(y,x,team)
    self.x = x
    self.y = y
    self.team = Players[team].color
    self.teamOrder = team - 1
    self.ready = true
    self.health = 100
    self.selected = false
    self.fuelCapacity = self.fuel
    if self.ammo then
        self.ammoCapacity = self.ammo
    end
    table.insert(UnitList, self)
end

function Unit:draw()
    love.graphics.draw(Units, Unit_quads[self.quad], self.x * Width, self.y * Height)
    if self.fuel <= self.fuelCapacity / 3 then
        love.graphics.draw(Icons, Icon_quads[47], self.x * Width + Width / 2, self.y * Height)
    end
end