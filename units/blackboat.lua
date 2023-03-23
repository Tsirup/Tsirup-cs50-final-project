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
    if self.team == "red" then
        self.quad = 931
    elseif self.team == "blue" then
        self.quad = 937
    end
    ActivePlayer.money = ActivePlayer.money - Cost.BlackBoat
end

function BlackBoat:draw()
    BlackBoat.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end