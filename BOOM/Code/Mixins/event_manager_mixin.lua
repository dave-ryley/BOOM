local EventManager = {}

------------------------------------------------------------------------------------
-- Event Functions
------------------------------------------------------------------------------------

local function addEventListener(self, eventName, listener)
    if not self._eventListeners[eventName] then
        self._eventListeners[eventName] = {}
    end
    local listeners = self._eventListeners[eventName]
    listeners[listener] = true
end

local function removeEventListener(self, eventName, listener)
    if self._eventListeners[eventName] then
        self._eventListeners[eventName][listener] = nil
    end
end

local event = {}
local function dispatchEvent(self, eventName, ...)
    if not self._eventListeners[eventName] then
        return end
    end
    local listeners = self._eventListeners[eventName]

    local params = table.pack(...)
    if params.n % 2 ~= 0 then
        error("Attempting to send event, " .. eventName .. "with invalid arguments.")
        return
    end

    clear(event)
    for i = 1, params.n, 2 do
        event[params[i]] = params[i+1]
    end

    for k, _ in pairs(listeners) do
        if type(k) == "table" then
            k[eventName](k, event)
        elseif type(k) == "function" then
            k(event)
        end
    end
end

------------------------------------------------------------------------------------
-- Initialize
------------------------------------------------------------------------------------

function EventManager:mixin(o)
    o._eventListeners = {}

    o.addEventListener = addEventListener
    o.removeEventListener = removeEventListener
    o.dispatchPooledEvent = dispatchPooledEvent
end

return EventManager
