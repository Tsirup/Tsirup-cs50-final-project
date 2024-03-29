Submarine = Unit:extend()

function Submarine:new()
    self.name = "Submarine"
    self.order = 23
    self.spec = "ship"
    self.move = 5
    self.moveType = "ship"
    self.vision = 5
    self.fuel = 60
    self.range = {1}
    self.damage = {nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,55,25,95,55,95,75}
    self.ammo = 6
    Submarine.super.new(self)
    self.quad = 781 + (self.teamOrder * 6)
end

function Submarine:draw()
    Submarine.super.draw(self)
    if self.stealth then
        self.iconQuad = 17 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end