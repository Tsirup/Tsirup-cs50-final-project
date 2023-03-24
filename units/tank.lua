Tank = Unit:extend()

function Tank:new()
    self.name = "Tank"
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 3
    self.fuel = 70
    self.range = {1}
    self.ammo = 9
    Tank.super.new(self)
    self.quad = 331 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Tank
end