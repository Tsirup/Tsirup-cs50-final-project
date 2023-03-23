PipeRunner = Unit:extend()

function PipeRunner:new()
    self.spec = "vehicle"
    self.move = 9
    self.moveType = "pipe"
    self.vision = 4
    self.fuel = 99
    self.range = {2,3,4,5}
    self.ammo = 9
    PipeRunner.super.new(self)
    if self.team == "red" then
        self.quad = 841
    elseif self.team == "blue" then
        self.quad = 847
    end
    ActivePlayer.money = ActivePlayer.money - Cost.PipeRunner
end