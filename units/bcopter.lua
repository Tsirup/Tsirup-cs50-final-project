Bcopter = Unit:extend()

function Bcopter:new()
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 3
    self.fuel = 99
    self.range = {1}
    self.ammo = 6
    Bcopter.super.new(self)
    if self.team == "red" then
        self.quad = 631
    elseif self.team == "blue" then
        self.quad = 637
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Bcopter
end