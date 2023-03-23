AntiAir = Unit:extend()

function AntiAir:new()
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 2
    self.fuel = 60
    self.range = {1}
    self.ammo = 9
    AntiAir.super.new(self)
    if self.team == "red" then
        self.quad = 451
    elseif self.team == "blue" then
        self.quad = 457
    end
    ActivePlayer.money = ActivePlayer.money - Cost.AntiAir
end