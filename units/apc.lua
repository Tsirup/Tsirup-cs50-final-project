APC = Unit:extend()

function APC:new()
    self.spec = "vehicle"
    self.move = 6
    self.moveType = "tread"
    self.vision = 1
    self.fuel = 70
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 1
    APC.super.new(self)
    if self.team == "red" then
        self.quad = 421
    elseif self.team == "blue" then
        self.quad = 427
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.APC
end

function APC:draw()
    APC.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end   