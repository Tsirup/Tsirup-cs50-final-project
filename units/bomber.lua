Bomber = Unit:extend()

function Bomber:new()
    self.name = "Bomber"
    self.spec = "plane"
    self.move = 7
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Bomber.super.new(self)
    self.quad = 601 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Bomber
end