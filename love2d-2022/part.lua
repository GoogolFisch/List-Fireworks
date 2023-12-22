local fert = {}
fert.__index = fert
local base = setmetatable(fert,{})

function fert.new(x,y,dx,dy,time,color)
    local self = setmetatable({},{__index = base})
    self.px =  x
    self.py =  y
    self.dx = dx
    self.dy = dy
    self.ay = 30
    self.ax = 0
    self.color = color
    self.timer = time
    self.lastX = x
    self.lastY = y
    return self
end
function fert:tick()
end
function fert:update(dt)
    self.lastX = self.px
    self.lastY = self.py
    self.dx    = self.dx + self.ax * dt
    self.dy    = self.dy + self.ay * dt
    self.px    = self.px  + self.dx * dt
    self.py    = self.py  + self.dy * dt
    self.timer = self.timer - dt
end
function fert:draw()
    love.graphics.setColor(self.color[1],self.color[2],self.color[3])
    love.graphics.line(self.px,self.py,self.lastX,self.lastY)
end
function fert:isDead()
    return self.timer < 0
end

return fert