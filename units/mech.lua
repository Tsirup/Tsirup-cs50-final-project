Mech = Unit:extend()

function Mech:new()
    self.name = "Mech"
    self.spec = "infantry"
    self.move = 2
    self.moveType = "mech"
    self.vision = 2
    self.fuel = 70
    self.range = {1}
    self.damage = {65,55,85,55,15,5,15,75,70,85,65,85,55,nil,nil,9,35,nil,nil,nil,nil,nil,nil,nil,nil}
    self.ammo = 3
    self.capture = 20
    Mech.super.new(self)
    self.quad = 151 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.Mech
end

function Mech:draw()
    Mech.super.draw(self)
    if self.capture < 20 then
        self.iconQuad = 16 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end