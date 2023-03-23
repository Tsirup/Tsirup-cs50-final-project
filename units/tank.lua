Tank = Unit:extend()

function Tank:new()
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 3
    self.fuel = 70
    self.range = {1}
    self.ammo = 9
    Tank.super.new(self)
    if self.team == "red" then
        self.quad = 331
    elseif self.team == "blue" then
        self.quad = 337
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Tank
end