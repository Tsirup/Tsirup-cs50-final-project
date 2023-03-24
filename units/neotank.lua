NeoTank = Unit:extend()

function NeoTank:new()
    self.name = "NeoTank"
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    NeoTank.super.new(self)
    self.quad = 391 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.NeoTank
end