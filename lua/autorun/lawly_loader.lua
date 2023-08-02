MsgN("===================Init Lawlib===================")
LAWLIB = {}

local lawlyFolder = "lawlypops/"


local cl_files = {}
local sh_files = {}
local sv_files = {}

local pwd = lawlyFolder

MsgN("[Lawlib] Loading files...")

local function addFiles()
    for _, f in ipairs(file.Find(pwd.."*", "LUA", "namedesc")) do
        if string.Left(f, 2) == "sh" then
            table.insert(sh_files, pwd..f) end
        if string.Left(f, 2) == "cl" then
            table.insert(cl_files, pwd..f) end
        if string.Left(f, 2) == "sv" then
            table.insert(sv_files, pwd..f) end
    end
    pwd = lawlyFolder .. "vgui/"
    for _, f in ipairs(file.Find(pwd.."*", "LUA")) do
        table.insert(cl_files, pwd..f)
    end
end

addFiles()

if SERVER then
    for _, f in ipairs(cl_files) do
        MsgN("Sending CLIENT file "..f)
        AddCSLuaFile(f)
    end
    for _, f in ipairs(sh_files) do
        MsgN("Loading+Sending SHARED file "..f)
        AddCSLuaFile(f)
        include(f)
    end
    for _, f in ipairs(sv_files) do
        MsgN("Loading SERVER file "..f)
        include(f)
    end
end
if CLIENT then
    for _, f in ipairs(sh_files) do
        MsgN("Loading SHARED file "..f)
        include(f)
    end
    for _, f in ipairs(cl_files) do
        MsgN("Loading CLIENT file "..f)
        include(f)
    end
end
MsgN("==================Loaded Lawlib==================")