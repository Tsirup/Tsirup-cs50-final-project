TransportCopter = Unit:extend()

function TransportCopter:new()
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 1
    TransportCopter.super.new(self)
    self.quad = 661 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.TransportCopter
end

function TransportCopter:draw()
    TransportCopter.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (ActivePlayer.order * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end