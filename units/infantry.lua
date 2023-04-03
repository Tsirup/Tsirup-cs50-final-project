Infantry = Unit:extend()

function Infantry:new()
    self.name = "Infantry"
    self.order = 1
    self.spec = "infantry"
    self.move = 3
    self.moveType = "infantry"
    self.vision = 2
    self.fuel = 99
    self.range = {1}
    self.damage = {55,45,12,5,1,1,1,14,15,25,5,26,5,nil,nil,7,30,nil,nil,nil,nil,nil,nil,nil,nil}
    self.capture = 20
    Infantry.super.new(self)
    self.quad = 1 + (self.teamOrder * 6)
end

function Infantry:draw()
    Infantry.super.draw(self)
    if self.capture < 20 then
        self.iconQuad = 16 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end