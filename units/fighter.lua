Fighter = Unit:extend()

function Fighter:new()
    self.cost = 20000
    self.spec = "Fighter"
    self.move = 9
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Fighter.super.new(self)
    if self.team == "red" then
        self.quad = 571
    elseif self.team == "blue" then
        self.quad = 577
    end
    table.insert(UnitList, self)
end