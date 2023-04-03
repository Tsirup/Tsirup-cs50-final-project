Artillery = Unit:extend()

function Artillery:new()
    self.name = "Artillery"
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {2,3}
    self.damage = {90,85,80,70,45,15,40,70,75,80,75,80,70,nil,nil,nil,nil,nil,nil,40,65,55,60,55,45}
    self.ammo = 9
    Artillery.super.new(self)
    self.quad = 481 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Artillery
end