--[[--
LRU implement in lua

local lrucache = require "lru"
local lru = lrucache:new(max_size=2,expire=3)

local function sleep(n)
    os.execute("sleep " .. tonumber(n))  
end

lru:set("x","a")
time.sleep(3)
lru:set("y","b")
lru:set("z","c")
lru:set("w","d")

lru.get("x") -- return nil, expired
lru.get("y") -- return nil, reach max count
lru.get("z") -- return c


]]

local LRUCache = {max_size=10000,expire=60*60}

--@max_size default max store 1000 items. if set nil,no upper limit
--@expire default 1 hours. if set nil, never expire

function  LRUCache:new(max_size,expire)
    local LC = {
        max_size = max_size,
        expire = expire,
        values = {},
        expire_times = {},
        access_times = {},
    }
    setmetatable(LC,self)
    self.__index = self
    return LC
end

function LRUCache.get(self,key)
    local t = os.time()
    self:cleanup()
    if self.values[key] ~= nil then
        self.access_times[key] = t
        return self.values[key]
    else
        return nil
    end

end

function LRUCache.set(self,key,value)
    local t = os.time()
    self.values[key] = value
    self.expire_times[key] = t + self.expire
    self.access_times[key] = t
    self:cleanup()

end

function LRUCache.remove(self,key)
    self.values[key] = nil
    self.expire_times[key] = nil
    self.access_times[key] = nil
end

function LRUCache.cleanup(self)
    -- remove expired items
    if self.expire ~= nil then
        for k,v in pairs(self.expire_times) do
            if v < os.time() then self:remove(k) end
        end
    end

    if self.max_size == nil then
        return
    end

    -- sort as the access time
    sorted_array = self:sort(self.access_times)

    -- remove oldest item
    while #self > self.max_size do
        oldest = sorted_array[1]
        self:remove(oldest.key)
    end

end


function LRUCache.sort(self,t)
    local array = {}
    for k,v in pairs(t) do
        table.insert(array,{key=k,access=v})
    end
    table.sort(array,function(a,b) return a.access<b.access end)
    return array
end

function LRUCache.__tostring(self)
    local s = "{"
    local sep = ""
    for k,_ in pairs(self.values) do
        s = s .. sep .. k
        sep = ","
    end
    return s .. "}"
end

function LRUCache.__len(self)
    local count = 0
    for _ in pairs(self.values) do count = count +1 end
    return count
end

return LRUCache



