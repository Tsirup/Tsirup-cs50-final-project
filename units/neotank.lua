NeoTank = Unit:extend()

function NeoTank:new()
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    NeoTank.super.new(self)
    if self.team == "red" then
        self.quad = 391
    elseif self.team == "blue" then
        self.quad = 397
    end
    ActivePlayer.money = ActivePlayer.money - Cost.NeoTank
end