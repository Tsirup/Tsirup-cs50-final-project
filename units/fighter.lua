Fighter = Unit:extend()

function Fighter:new()
    self.name = "Fighter"
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.damage = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,55,100,100,100,85,120,nil,nil,nil,nil,nil,nil}
    self.ammo = 9
    Fighter.super.new(self)
    self.quad = 571 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Fighter
end