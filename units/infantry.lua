Infantry = Unit:extend()

function Infantry:new()
    self.spec = "infantry"
    self.move = 3
    self.moveType = "infantry"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.capture = 20
    Infantry.super.new(self)
    if self.team == "red" then
        self.quad = 1
    elseif self.team == "blue" then
        self.quad = 37
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Infantry
end

function Infantry:draw()
    Infantry.super.draw(self)
    if self.capture < 20 then
        if self.team == "red" then
            self.iconQuad = 16
        elseif self.team == "blue" then
            self.iconQuad = 44
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end