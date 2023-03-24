Fighter = Unit:extend()

function Fighter:new()
    self.name = "Fighter"
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Fighter.super.new(self)
    self.quad = 571 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Fighter
end