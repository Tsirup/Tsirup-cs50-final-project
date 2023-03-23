StealthFighter = Unit:extend()

function StealthFighter:new()
    self.spec = "plane"
    self.move = 6
    self.moveType = "air"
    self.vision = 4
    self.fuel = 60
    self.range = {1}
    self.ammo = 6
    StealthFighter.super.new(self)
    if self.team == "red" then
        self.quad = 901
    elseif self.team == "blue" then
        self.quad = 907
    end
    ActivePlayer.money = ActivePlayer.money - Cost.StealthFighter
end