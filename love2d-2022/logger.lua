local logger = {}

logger.NOTE     = 1
logger.DEBUG    = 2
logger.INFO     = 3
logger.WARN     = 4
logger.WARNING  = 4
logger.ERROR    = 5
logger.CRITICAL = 6
logger.FATAL    = 6

function logger.init(level,name)
    local self = setmetatable({},{__index=logger})
    -- set level
    self.level = level     or self.NOTE
    self.sep   = "|"
    self.kva   = "->"
    self.strk  = '"'
    self.name  = name
    -- reverse Priority
    self.priority = {
        "\x1b[90mnote    : ",-- NOTE
        "\x1b[94mdebug   : ",-- DEBUG
        "\x1b[92minfo    : ",-- INFO
        "\x1b[93mWarning : ",-- WARN
        "\x1b[91mERROR   : ",-- ERROR
        "\x1b[95mCRITICAL: " -- FATAL
    }
    -- self.priority[nil] = "\x1b[95mHOW_ERR: "
    return self
end
function logger:logit(logging,level)
    -- get log-out
    local a = ""
    if     type(logging) == "nil"                 then a = "nil"
    elseif type(logging) == "number"              then a = logging
    elseif type(logging) == "table" and level < 1 then a = "{...}"
    elseif type(logging) == "function"            then a = "#()"
    elseif type(logging) == "string"              then
        a = self.strk ..  logging:gsub("\\","\\\\"):gsub("\n","\\n"):gsub("\t","\\t"):gsub('"','\\"') .. self.strk
    elseif type(logging) == "table" and level > 0 then
        for k,v in pairs(logging) do
            a = a .. self:logit(k,level - 1) .. self.kva .. self:logit(v,level - 1) .. self.sep
        end
        a = "{" .. a:sub(0,#a - #self.sep) .. "}"
    elseif type(logging) == "boolean" then
        a = logging and "true" or "false"
    else
        a = "???"
    end
    return a
end

function logger:fixnum(num,limit)
    local out = "" .. num, i
    for i=0,limit - #out,1 do out = "0" .. out end
    return out:sub(-limit,#out)
end
function logger:logstr(logging,limit)
    limit = limit or 1
    return self:logit(logging,limit)
end
function logger:log(logging,level,limit)
    level = level or self.NOTE
    if self.level <= level then
        print((self.priority[level] or "Err!") .. "<" .. (self.name or "nil") .. ">\x1b[0m" .. (self:logstr(logging,limit) or "Err!"))
    end
end

return logger