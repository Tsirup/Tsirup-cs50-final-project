StealthFighter = Unit:extend()

function StealthFighter:new()
    self.name = "StealthFighter"
    self.spec = "plane"
    self.move = 6
    self.moveType = "air"
    self.vision = 4
    self.fuel = 60
    self.range = {1}
    self.damage = {90,90,85,75,70,15,60,85,75,85,50,85,80,45,70,85,95,55,120,45,35,65,55,65,45}
    self.ammo = 6
    StealthFighter.super.new(self)
    self.quad = 901 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.StealthFighter
end

function StealthFighter:draw()
    StealthFighter.super.draw(self)
    if self.stealth then
        self.iconQuad = 17 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end