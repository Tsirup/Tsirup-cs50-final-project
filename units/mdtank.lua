MediumTank = Unit:extend()

function MediumTank:new()
    self.name = "MediumTank"
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.ammo = 8
    MediumTank.super.new(self)
    self.quad = 361 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.MediumTank
end