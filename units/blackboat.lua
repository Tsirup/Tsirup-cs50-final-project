BlackBoat = Unit:extend()

function BlackBoat:new()
    self.name = "BlackBoat"
    self.order = 24
    self.spec = "ship"
    self.move = 7
    self.moveType = "transport"
    self.vision = 1
    self.fuel = 60
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 2
    BlackBoat.super.new(self)
    self.quad = 931 + (self.teamOrder * 6)
end

function BlackBoat:draw()
    BlackBoat.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end