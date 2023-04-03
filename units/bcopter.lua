BattleCopter = Unit:extend()

function BattleCopter:new()
    self.name = "BattleCopter"
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 3
    self.fuel = 99
    self.range = {1}
    self.damage = {75,75,55,55,25,10,20,60,65,65,25,65,55,nil,nil,65,95,nil,nil,25,55,25,25,25,25}
    self.ammo = 6
    BattleCopter.super.new(self)
    self.quad = 631 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.BattleCopter
end