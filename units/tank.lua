Tank = Unit:extend()

function Tank:new()
    self.name = "Tank"
    self.order = 4
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 3
    self.fuel = 70
    self.range = {1}
    self.damage = {75,70,85,55,15,10,15,75,70,85,65,85,55,nil,nil,10,40,nil,nil,1,5,10,1,10,1}
    self.ammo = 9
    Tank.super.new(self)
    self.quad = 331 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Tank
end