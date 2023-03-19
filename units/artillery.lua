Artillery = Unit:extend()

function Artillery:new()
    self.cost = 6000
    self.spec = "Artillery"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {2,3}
    self.ammo = 9
    Artillery.super.new(self)
    if self.team == "red" then
        self.quad = 481
    elseif self.team == "blue" then
        self.quad = 487
    end
    table.insert(UnitList, self)
end