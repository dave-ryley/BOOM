local LuaFileSystem = require("lfs")

local ConfigService = {}
local Configs = {}

------------------------------------------------------------------------------------
-- Local Functions - Populating Includes
------------------------------------------------------------------------------------
local includedChecklist = {}
local function populateInclude(parent, child)
    for k, v in pairs(parent) do
        if not child[k] and parent[k] ~= "_includes" then
            child[k] = v
        elseif type(v) == "table" then
            populateInclude(parent[k], child[k])
        end
    end
end

local recursiveCheckTable = {}
local function include(namespace, k, v)
    if v._includes then
        if includedChecklist[v._includes] then -- Parent already populated
            includedChecklist[k] = true
            populateInclude(namespace[v._includes], v)
        elseif recursiveCheckTable[k] then
            error("Circular dependency detected! Cannot build Config.")
            printR(recursiveCheckTable)
            return
        else
            if namespace[v._includes] then -- If not, parent not yet loaded
                recursiveCheckTable[k] = true
                -- Include the parent, then attempt to include again
                include(namespace, v._includes, namespace[v._includes])
                include(namespace, k, v)
            end
        end
    else
        includedChecklist[k] = true
    end
    clear(recursiveCheckTable)
end

------------------------------------------------------------------------------------
-- Local Functions - Getting and Making Configs
------------------------------------------------------------------------------------
local function getOrMakeConfig(addressTable, index, branch, make)
    local child = branch[addressTable[index]]
    if not child then
        if make then
            branch[addressTable[index]] = {}
            child = branch[addressTable[index]]
        else
            error("Could not find config at", addressTable[index])
            return nil
        end
    end
    if index < #addressTable then
        return getOrMakeConfig(addressTable, index + 1, child, make)
    else
        return child
    end
end

local function getConfig(addressTable, index, branch)
    return getOrMakeConfig(addressTable, index, branch, false)
end

local function makeConfig(addressTable, index, branch)
    return getOrMakeConfig(addressTable, index, branch, true)
end

------------------------------------------------------------------------------------
-- Local Functions - Loading
------------------------------------------------------------------------------------

local namespaceCheck = {}
local function load(requirePath)
    -- print("Loading Config:", requirePath)
    local configFile = require(requirePath)
    
    local namespaceKey = configFile._namespace
    if not namespaceKey then 
        error(requirePath .. " is not a valid config. No namespace found.")
        return 
    end

    -- Check the namespace isn't a sub-namespace
    namespaceCheck = split(namespaceKey, ".", namespaceCheck)
    local namespace = makeConfig(namespaceCheck, 1, Configs)
    clear(namespaceCheck)

    -- Add the initial configs
    for k, v in pairs(configFile) do
        if k ~= "_namespace" then
            namespace[k] = v
        end
    end

    -- populate from includes
    for k, v in pairs(namespace) do
        if type(v) == "table" then
            include(namespace, k, v)
        end
    end

    clear(includedChecklist)
end

local function recursiveLoad(path, requirePath)
    for k in LuaFileSystem.dir(path) do
        if k ~= "." and k ~= ".." then
            local fileAttrib = LuaFileSystem.attributes( path .. "/" .. k )
            if fileAttrib.mode == "directory" then
                recursiveLoad(path .. "/" .. k, requirePath .. "." .. k)
            elseif fileAttrib.mode == "file" and string.match(k, "[.lua]$") then
                -- Make a new string based on the require path, so it doesn't carry over for the next load
                local finalRP = requirePath .. "." .. k
                -- Create a substring that removes ".lua" from the end
                local luaPostfixLength = 4
                finalRP = string.sub(finalRP, 1, string.len(finalRP) - luaPostfixLength)
                load(finalRP)
            end
        end
    end
end

------------------------------------------------------------------------------------
-- Local Functions - Getter
------------------------------------------------------------------------------------
local splitId = {}
local function findAndLoadAsset(searchSpace, assetKey, loadFunction, result)
    for k, v in pairs(searchSpace) do
        if k == assetKey then
            if v == "table" then
                for i = 1, #v do
                    if not result[v[i]] then -- Avoiding duplicate load calls
                        result[v[i]] = loadFunction(v[i])
                    end
                end
            elseif not result[v] then -- Avoiding duplicate load calls
                result[v] = loadFunction(v)
            end
        elseif type(v) == "table" then
            findAndLoadAsset(v, assetKey, loadFunction, result)
        end
    end
end

------------------------------------------------------------------------------------
-- ConfigService Functions
------------------------------------------------------------------------------------

function ConfigService:fromId(configId)
    splitId = split(configId, ".", splitId)
    if #splitId < 2 then
        error("Invalid Id: " .. configId .. ". Did you forget the namespace?")
        return nil
    end

    local namespace = Configs[splitId[1]]
    if not namespace then
        error("Invalid Id:" .. configId .. ". Could not find namespace: " .. splitId[1])
        return nil
    end

    local config = getConfig(splitId, 2, namespace)
    clear(splitId)
    return config
end

function ConfigService:buildAssetTable(namespaceKey, assetKey, loadFunction, result)
    local namespace = Configs[namespaceKey]
    if not namespace then
        error("Cannot find namespace \"" .. namespaceKey .. "\" in Configs. Cannot build Asset Table.")
        return result
    end
    return find
end

------------------------------------------------------------------------------------
-- Initialization
------------------------------------------------------------------------------------

function ConfigService:init()
    local path = system.pathForFile() .. "/Config"
    recursiveLoad(path, "Config")
    printR(Configs, 2)
end

------------------------------------------------------------------------------------
return ConfigService