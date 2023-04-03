AntiAir = Unit:extend()

function AntiAir:new()
    self.name = "AntiAir"
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 2
    self.fuel = 60
    self.range = {1}
    self.damage = {105,105,60,25,10,1,5,50,50,55,45,55,25,65,75,120,120,75,120,nil,nil,nil,nil,nil,nil}
    self.ammo = 9
    AntiAir.super.new(self)
    self.quad = 451 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.AntiAir
end