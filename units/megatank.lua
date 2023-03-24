MegaTank = Unit:extend()

function MegaTank:new()
    self.name = "MegaTank"
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.ammo = 3
    MegaTank.super.new(self)
    self.quad = 811 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.MegaTank
end