Aair = Unit:extend()

function Aair:new()
    self.cost = 8000
    self.spec = "Anti Air"
    self.move = 6
    self.moveType = "tread"
    self.vision = 2
    self.fuel = 60
    self.range = {1}
    self.ammo = 9
    Aair.super.new(self)
    if self.team == "red" then
        self.quad = 451
    elseif self.team == "blue" then
        self.quad = 457
    end
    table.insert(UnitList, self)
end