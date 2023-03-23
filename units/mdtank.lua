MediumTank = Unit:extend()

function MediumTank:new()
    self.spec = "vehicle"
    self.move = 5
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.ammo = 8
    MediumTank.super.new(self)
    if self.team == "red" then
        self.quad = 361
    elseif self.team == "blue" then
        self.quad = 367
    end
    ActivePlayer.money = ActivePlayer.money - Cost.MediumTank
end