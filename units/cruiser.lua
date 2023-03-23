Cruiser = Unit:extend()

function Cruiser:new()
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
    if self.team == "red" then
        self.quad = 721
    elseif self.team == "blue" then
        self.quad = 727
    end
    ActivePlayer.money = ActivePlayer.money - Cost.Cruiser
end

function Cruiser:draw()
    Cruiser.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end