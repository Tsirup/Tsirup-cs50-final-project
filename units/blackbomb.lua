BlackBomb = Unit:extend()

function BlackBomb:new()
    self.spec = "plane"
    self.move = 9
    self.moveType = "air"
    self.vision = 1
    self.fuel = 45
    BlackBomb.super.new(self)
    if self.team == "red" then
        self.quad = 871
    elseif self.team == "blue" then
        self.quad = 877
    end
    ActivePlayer.money = ActivePlayer.money - Cost.BlackBomb
end