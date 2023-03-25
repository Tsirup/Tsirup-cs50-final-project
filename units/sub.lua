Submarine = Unit:extend()

function Submarine:new()
    self.name = "Submarine"
    -- have it start as a ship and turn into a sub when it dives
    self.spec = "ship"
    self.move = 5
    self.moveType = "ship"
    self.vision = 5
    self.fuel = 60
    self.range = {1}
    self.ammo = 6
    Submarine.super.new(self)
    self.quad = 781 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Submarine
end