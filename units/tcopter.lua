TransportCopter = Unit:extend()

function TransportCopter:new()
    self.name = "TransportCopter"
    self.order = 17
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 1
    TransportCopter.super.new(self)
    self.quad = 661 + (self.teamOrder * 6)
end

function TransportCopter:draw()
    TransportCopter.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end