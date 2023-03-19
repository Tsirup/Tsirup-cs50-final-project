Bcopter = Unit:extend()

function Bcopter:new()
    self.cost = 9000
    self.spec = "Battle Copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 3
    self.fuel = 99
    self.range = {1}
    self.ammo = 6
    Bcopter.super.new(self)
    if self.team == "red" then
        self.quad = 431
    elseif self.team == "blue" then
        self.quad = 437
    end
    table.insert(UnitList, self)
end