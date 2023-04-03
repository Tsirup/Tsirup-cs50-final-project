Lander = Unit:extend()

function Lander:new()
    self.name = "Lander"
    self.order = 22
    self.spec = "ship"
    self.move = 6
    self.moveType = "transport"
    self.vision = 1
    self.fuel = 99
    self.carry = {"infantry", "vehicle"}
    self.cargo = {}
    self.capacity = 2
    Lander.super.new(self)
    self.quad = 751 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Lander
end

function Lander:draw()
    Lander.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end