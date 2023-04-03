MegaTank = Unit:extend()

function MegaTank:new()
    self.name = "MegaTank"
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.damage = {135,125,195,180,125,65,115,195,195,195,195,195,180,nil,nil,22,55,nil,nil,45,65,75,45,105,45}
    self.ammo = 3
    MegaTank.super.new(self)
    self.quad = 811 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.MegaTank
end