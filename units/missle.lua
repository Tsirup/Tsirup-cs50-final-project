Missles = Unit:extend()

function Missles:new()
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tire"
    self.vision = 5
    self.fuel = 50
    self.range = {3,4,5}
    self.ammo = 6
    Missles.super.new(self)
    if self.team == "red" then
        self.quad = 541
    elseif self.team == "blue" then
        self.quad = 547
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Missles
end