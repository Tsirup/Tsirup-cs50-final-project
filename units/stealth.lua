StealthFighter = Unit:extend()

function StealthFighter:new()
    self.name = "StealthFighter"
    self.spec = "plane"
    self.move = 6
    self.moveType = "air"
    self.vision = 4
    self.fuel = 60
    self.range = {1}
    self.ammo = 6
    StealthFighter.super.new(self)
    self.quad = 901 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.StealthFighter
end