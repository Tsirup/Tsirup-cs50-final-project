Mech = Unit:extend()

function Mech:new()
    self.spec = "infantry"
    self.move = 2
    self.moveType = "mech"
    self.vision = 2
    self.fuel = 70
    self.range = {1}
    self.capture = 20
    Mech.super.new(self)
    if self.team == "red" then
        self.quad = 151
    elseif self.team == "blue" then
        self.quad = 187
    end
    table.insert(UnitList, self)
    ActivePlayer.money = ActivePlayer.money - Cost.Mech
end

function Mech:draw()
    Mech.super.draw(self)
    if self.capture < 20 then
        if self.team == "red" then
            self.iconQuad = 16
        elseif self.team == "blue" then
            self.iconQuad = 44
        end
        love.graphics.draw(Icons, Icon_quads[self.iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end