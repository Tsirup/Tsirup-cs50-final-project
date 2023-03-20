APC = Unit:extend()

function APC:new()
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 70
    APC.super.new(self)
    if self.team == "red" then
        self.quad = 421
    elseif self.team == "blue" then
        self.quad = 427
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.APC
end