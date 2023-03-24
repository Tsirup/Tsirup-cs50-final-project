BlackBomb = Unit:extend()

function BlackBomb:new()
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 1
    self.fuel = 45
    BlackBomb.super.new(self)
    self.quad = 871 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.BlackBomb
end