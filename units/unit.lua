Unit = Object:extend()

function Unit:new()
    if not Deploy then
        self.x = Cursor.x
        self.y = Cursor.y
        self.team = ActivePlayer.color
        self.teamOrder = ActivePlayer.order - 1
        self.ready = false
    else
        self.x = Deploy[3]
        self.y = Deploy[2]
        self.team = Players[Deploy[4]].color
        self.teamOrder = Deploy[4] - 1
        self.ready = true
        self.movement = Movement(self)
    end
    self.health = 100
    self.selected = false
    self.fuelCapacity = self.fuel
    if self.ammo then
        self.ammoCapacity = self.ammo
    end
    ActivePlayer.money = ActivePlayer.money - Cost[self.name]
    table.insert(UnitList, self)
end

function Unit:draw()
    if self.ready then
        love.graphics.draw(Units, Unit_quads[self.quad], self.x * Width, self.y * Height)
    else
        love.graphics.draw(Units, Unit_quads[self.quad + 3], self.x * Width, self.y * Height)
    end
    local digit = math.ceil(self.health/10)
    if digit < 10 then
        love.graphics.draw(Icons, Icon_quads[18 + digit], self.x * Width + Width / 2, self.y * Height + Height / 2)
    end
    if self.fuel <= self.fuelCapacity / 3 then
        love.graphics.draw(Icons, Icon_quads[47], self.x * Width + Width / 2, self.y * Height)
    end
    if self.ammo then
        if self.ammo <= self.ammoCapacity / 3 then
            love.graphics.draw(Icons, Icon_quads[75], self.x * Width, self.y * Height + Height / 2)
        end
    end
end