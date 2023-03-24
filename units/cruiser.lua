Cruiser = Unit:extend()

function Cruiser:new()
    self.name = "Cruiser"
    self.spec = "ship"
    self.move = 6
    self.moveType = "ship"
    self.vision = 3
    self.fuel = 99
    self.range = {1}
    self.ammo = 9
    self.carry = {"copter"}
    self.cargo = {}
    self.capacity = 2
    Cruiser.super.new(self)
    self.quad = 721 + (ActivePlayer.order * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Cruiser
end

function Cruiser:draw()
    Cruiser.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (ActivePlayer.order * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end