BlackBomb = Unit:extend()

function BlackBomb:new()
    self.name = "BlackBomb"
    self.order = 19
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 1
    self.fuel = 45
    BlackBomb.super.new(self)
    self.quad = 871 + (self.teamOrder * 6)
end