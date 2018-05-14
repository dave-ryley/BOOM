------------------------------------------------------------------------------------
-- Local Functions
------------------------------------------------------------------------------------

local function addWhiteSpace(str, depth)
    for i = 1, depth do
        str = str .. "    "
    end
    return str
end

local function buildRecursiveString(value, str, depth, maxDepth)
    str = str  .. " =\n"
    str = addWhiteSpace(str, depth)
    str = str .. "{\n"
    depth = depth + 1
    for k, v in pairs(value) do
        str = addWhiteSpace(str, depth)
        str = str .. "[" .. k .. "]"
        if type(v) == "table" and depth <= maxDepth then
            str = buildRecursiveString(v, str, depth, maxDepth)
        elseif type(v) == "string" then
            str = str .. " = \"" .. v .. "\"\n"
        else
            str = str .. " = " .. tostring(v) .. "\n"
        end
    end
    depth = depth - 1
    str = addWhiteSpace(str, depth)
    str = str .. "}\n"
    return str
end

------------------------------------------------------------------------------------
-- Table Functions
------------------------------------------------------------------------------------

function clear(t)
    for k, v in pairs(t) do
        t[k] = nil
    end
    for i = #t, 1, -1 do
        t[i] = nil
    end
end

------------------------------------------------------------------------------------
-- String Functions
------------------------------------------------------------------------------------

-- Ideally pass in and recycle a table
function split(str, sep, result)
    result = result or {}
    for s in string.gmatch(str, "([^"..sep.."]+)") do
        result[#result + 1] = s
    end
    return result
end

------------------------------------------------------------------------------------
-- Print Functions
------------------------------------------------------------------------------------

function printR(value, maxDepth, optionalName)
    maxDepth = maxDepth or 2
    if type(value) == "table" then
        local str = (optionalName or tostring(value))
        local depth = 0
        str = buildRecursiveString(value, str, depth, maxDepth )
        print(str)
    else
        print("Attempting to recursively print non-table type:", type(value))
    end
end