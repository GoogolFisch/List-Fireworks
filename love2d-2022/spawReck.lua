local fort = {}
fort.__index = fort
local base = setmetatable(fort,{})


function fort.new(x,y,dx,dy,time)
    local self = setmetatable({},{__index = base})
    self.px =  x
    self.py =  y
    self.dx = dx
    self.dy = dy
    self.timer = time
    self.spawn = 0
    return self
end
function fort:tick()
end
function fort:update(dt)
    self.timer = self.timer - dt
    self.spawn = self.spawn + dt
    if self.spawn > 0.0625 then
        self.spawn = 0
        spawn(true,self.px,self.py,self.dx,self.dy)
    end
end
function fort:draw()
end
function fort:isDead()
    return self.timer < 0
end

return fort