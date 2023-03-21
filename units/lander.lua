Lander = Unit:extend()

function Lander:new()
    self.spec = "ship"
    self.move = 6
    self.moveType = "transport"
    self.vision = 1
    self.fuel = 99
    self.carry = {"infantry", "vehicle"}
    self.cargo = {}
    self.capacity = 2
    Lander.super.new(self)
    if self.team == "red" then
        self.quad = 751
    elseif self.team == "blue" then
        self.quad = 757
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Lander
end