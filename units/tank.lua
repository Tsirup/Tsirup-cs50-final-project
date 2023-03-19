Tank = Unit:extend()

function Tank:new()
    self.cost = 7000
    self.spec = "Tank"
    self.move = 6
    self.moveType = "tread"
    self.vision = 3
    self.fuel = 70
    self.range = {1}
    self.ammo = 9
    Tank.super.new(self)
    if self.team == "red" then
        self.quad = 331
    elseif self.team == "blue" then
        self.quad = 337
    end
    table.insert(UnitList, self)
end