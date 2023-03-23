MegaTank = Unit:extend()

function MegaTank:new()
    self.spec = "vehicle"
    self.move = 4
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 50
    self.range = {1}
    self.ammo = 3
    MegaTank.super.new(self)
    if self.team == "red" then
        self.quad = 811
    elseif self.team == "blue" then
        self.quad = 817
    end
    ActivePlayer.money = ActivePlayer.money - Cost.MegaTank
end