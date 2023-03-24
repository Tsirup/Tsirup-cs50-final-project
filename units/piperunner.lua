PipeRunner = Unit:extend()

function PipeRunner:new()
    self.name = "PipeRunner"
    self.spec = "vehicle"
    self.move = 9
    self.moveType = "pipe"
    self.vision = 4
    self.fuel = 99
    self.range = {2,3,4,5}
    self.ammo = 9
    PipeRunner.super.new(self)
    self.quad = 841 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.PipeRunner
end