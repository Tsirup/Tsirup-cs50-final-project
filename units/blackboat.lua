BlackBoat = Unit:extend()

function BlackBoat:new()
    self.spec = "ship"
    self.move = 7
    self.moveType = "transport"
    self.vision = 1
    self.fuel = 60
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 2
    BlackBoat.super.new(self)
    self.quad = 931 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.BlackBoat
end

function BlackBoat:draw()
    BlackBoat.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (ActivePlayer.order * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end