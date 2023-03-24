Missles = Unit:extend()

function Missles:new()
    self.name = "Missles"
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 50
    self.range = {3,4,5}
    self.ammo = 6
    Missles.super.new(self)
    self.quad = 541 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Missles
end