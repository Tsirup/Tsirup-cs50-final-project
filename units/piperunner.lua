PipeRunner = Unit:extend()

function PipeRunner:new()
    self.name = "PipeRunner"
    self.order = 13
    self.spec = "vehicle"
    self.move = 9
    self.moveType = "pipe"
    self.vision = 4
    self.fuel = 99
    self.range = {2,3,4,5}
    self.damage = {95,90,90,80,55,25,50,80,80,85,85,90,80,65,75,105,105,75,120,55,85,60,85,60,60}
    self.ammo = 9
    PipeRunner.super.new(self)
    self.quad = 841 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.PipeRunner
end