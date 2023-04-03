APC = Unit:extend()

function APC:new()
    self.name = "APC"
    self.order = 8
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 70
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 1
    APC.super.new(self)
    self.quad = 421 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.APC
end

function APC:draw()
    APC.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end