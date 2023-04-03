Rockets = Unit:extend()

function Rockets:new()
    self.name = "Rockets"
    self.order = 10
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tire"
    self.vision = 1
    self.fuel = 50
    self.range = {3,4,5}
    self.damage = {95,90,90,80,55,25,50,80,80,85,85,90,80,nil,nil,nil,nil,nil,nil,55,85,60,85,60,60}
    self.ammo = 6
    Rockets.super.new(self)
    self.quad = 511 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Rockets
end