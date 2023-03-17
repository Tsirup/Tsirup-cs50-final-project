Mech = Object:extend()

function Mech:new()
    self.cost = 3000
    self.spec = "Mech"
    self.x = Cursor.x
    self.y = Cursor.y
    self.team = Active_Player.color
    self.move = 2
    self.moveType = "mech"
    self.ready = false
    self.vision = 2
    self.fuel = 70
    self.health = 100
    self.range = {1}
    self.selected = false
    self.movement = nil
    self.capture = 20
    table.insert(UnitList, self)
    Active_Player.money = Active_Player.money - self.cost
end

function Mech:draw()
    local quad, iconQuad
    if self.team == "red" then
        quad = 151
    elseif self.team == "blue" then
        quad = 187
    end
    love.graphics.draw(Units, Unit_quads[quad], self.x * Width, self.y * Height)
    if self.capture < 20 then
        if self.team == "red" then
            iconQuad = 16
        elseif self.team == "blue" then
            iconQuad = 44
        end
        love.graphics.draw(Icons, Icon_quads[iconQuad], self.x * Width, self.y * Height + Height / 2)
    end
end