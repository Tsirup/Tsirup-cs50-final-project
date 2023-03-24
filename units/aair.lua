AntiAir = Unit:extend()

function AntiAir:new()
    self.name = "AntiAir"
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 2
    self.fuel = 60
    self.range = {1}
    self.ammo = 9
    AntiAir.super.new(self)
    self.quad = 451 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.AntiAir
end