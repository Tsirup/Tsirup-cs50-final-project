Bomber = Unit:extend()

function Bomber:new()
    self.cost = 22000
    self.spec = "Bomber"
    self.move = 7
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Bomber.super.new(self)
    if self.team == "red" then
        self.quad = 601
    elseif self.team == "blue" then
        self.quad = 607
    end
    table.insert(UnitList, self)
end