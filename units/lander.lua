Lander = Unit:extend()

function Lander:new()
    self.spec = "ship"
    self.move = 6
    self.moveType = "transport"
    self.vision = 1
    self.fuel = 99
    self.carry = {"infantry", "vehicle"}
    self.cargo = {}
    self.capacity = 2
    Lander.super.new(self)
    if self.team == "red" then
        self.quad = 751
    elseif self.team == "blue" then
        self.quad = 757
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Lander
end

function Lander:draw()
    Lander.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end