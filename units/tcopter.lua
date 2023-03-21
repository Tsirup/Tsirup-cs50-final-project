Tcopter = Unit:extend()

function Tcopter:new()
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.carry = {"infantry"}
    Tcopter.super.new(self)
    if self.team == "red" then
        self.quad = 661
    elseif self.team == "blue" then
        self.quad = 667
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Tcopter
end