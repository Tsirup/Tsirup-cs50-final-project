Rockets = Unit:extend()

function Rockets:new()
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tire"
    self.vision = 1
    self.fuel = 50
    self.range = {3,4,5}
    self.ammo = 6
    Rockets.super.new(self)
    if self.team == "red" then
        self.quad = 511
    elseif self.team == "blue" then
        self.quad = 517
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Rockets
end