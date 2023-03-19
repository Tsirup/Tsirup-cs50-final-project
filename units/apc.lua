Apc = Unit:extend()

function Apc:new()
    self.cost = 5000
    self.spec = "Apc"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 70
    Apc.super.new(self)
    if self.team == "red" then
        self.quad = 421
    elseif self.team == "blue" then
        self.quad = 427
    end
    table.insert(UnitList, self)
end