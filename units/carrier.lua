AircraftCarrier = Unit:extend()

function AircraftCarrier:new()
    self.name = "AircraftCarrier"
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
    self.quad = 961 + (self.teamOrder * 6)
    ActivePlayer.money = ActivePlayer.money - Cost.AircraftCarrier
end

function AircraftCarrier:draw()
    AircraftCarrier.super.draw(self)
    if #self.cargo > 0 then
        self.iconQuad = 15 + (self.teamOrder * 28)
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end