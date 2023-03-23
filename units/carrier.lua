AircraftCarrier = Unit:extend()

function AircraftCarrier:new()
    self.spec = "ship"
    self.move = 5
    self.moveType = "ship"
    self.vision = 4
    self.fuel = 99
    self.range = {3,4,5,6,7,8}
    self.ammo = 9
    self.carry = {"copter", "plane"}
    self.cargo = {}
    self.capacity = 2
    AircraftCarrier.super.new(self)
    if self.team == "red" then
        self.quad = 961
    elseif self.team == "blue" then
        self.quad = 967
    end
    ActivePlayer.money = ActivePlayer.money - Cost.AircraftCarrier
end

function AircraftCarrier:draw()
    AircraftCarrier.super.draw(self)
    if #self.cargo > 0 then
        if self.team == "red" then
            self.iconQuad = 15
        elseif self.team == "blue" then
            self.iconQuad = 43
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end