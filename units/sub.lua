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

function Submarine:draw()
    Submarine.super.draw(self)
    if self.stealth then
        self.iconQuad = 17 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end