Tcopter = Unit:extend()

function Tcopter:new()
    self.cost = 5000
    self.spec = "Transport Copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    Tcopter.super.new(self)
    if self.team == "red" then
        self.quad = 661
    elseif self.team == "blue" then
        self.quad = 667
    end
    table.insert(UnitList, self)
end