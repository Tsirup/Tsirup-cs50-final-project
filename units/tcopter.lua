Tcopter = Unit:extend()

function Tcopter:new()
    self.spec = "copter"
    self.move = 6
    self.moveType = "air"
    self.vision = 2
    self.fuel = 99
    self.carry = {"infantry"}
    self.cargo = {}
    self.capacity = 1
    Tcopter.super.new(self)
    if self.team == "red" then
        self.quad = 661
    elseif self.team == "blue" then
        self.quad = 667
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Tcopter
end

function Tcopter:draw()
    Tcopter.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end