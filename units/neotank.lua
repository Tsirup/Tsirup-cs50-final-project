NeoTank = Unit:extend()

function NeoTank:new()
    self.name = "NeoTank"
    self.order = 6
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 99
    self.range = {1}
    self.damage = {125,115,125,105,75,35,55,125,115,125,115,125,105,nil,nil,22,55,nil,nil,15,50,50,15,40,15}
    self.ammo = 9
    NeoTank.super.new(self)
    self.quad = 391 + (self.teamOrder * 6)
end