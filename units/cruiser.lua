Cruiser = Unit:extend()

function Cruiser:new()
    self.spec = "ship"
    self.move = 6
    self.moveType = "ship"
    self.vision = 3
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Cruiser.super.new(self)
    if self.team == "red" then
        self.quad = 721
    elseif self.team == "blue" then
        self.quad = 727
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Cruiser
end