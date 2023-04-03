MediumTank = Unit:extend()

function MediumTank:new()
    self.name = "MediumTank"
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.damage = {105,95,105,85,55,25,45,105,105,105,105,105,85,nil,nil,12,45,nil,nil,10,45,35,10,35,10}
    self.ammo = 8
    MediumTank.super.new(self)
    self.quad = 361 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.MediumTank
end