
LRU cache implement with lua.

## Example

basic usage

```
local lrucache = require "lru"
local lru = lrucache:new()

lru:set("x","a")
lru:set("y","b")
lru:set("z","c")

print(lru) 
print(lru.get("x"))  

-- {a,b,c}
-- a
```

expire and max-size

```
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

```