Rockets = Unit:extend()

function Rockets:new()
    self.name = "Rockets"
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tire"
    self.vision = 1
    self.fuel = 50
    self.range = {3,4,5}
    self.ammo = 6
    Rockets.super.new(self)
    self.quad = 511 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Rockets
end