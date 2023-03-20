Submarine = Unit:extend()

function Submarine:new()
    -- potentially have it start as a ship and turn into a sub when it dives
    self.spec = "sub"
    self.move = 5
    self.moveType = "ship"
    self.vision = 5
    self.fuel = 60
    self.range = {1}
    self.ammo = 6
    Submarine.super.new(self)
    if self.team == "red" then
        self.quad = 781
    elseif self.team == "blue" then
        self.quad = 787
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Submarine
end