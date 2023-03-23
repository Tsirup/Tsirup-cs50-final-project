Fighter = Unit:extend()

function Fighter:new()
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    Fighter.super.new(self)
    if self.team == "red" then
        self.quad = 571
    elseif self.team == "blue" then
        self.quad = 577
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Fighter
end