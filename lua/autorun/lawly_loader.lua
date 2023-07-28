MsgN("===================Init Lawlib===================")
LAWLIB = {}

local lawlyFolder = "lawlypops/"


local cl_files = {}
local sh_files = {}
local sv_files = {}

local pwd = lawlyFolder

local files, dirs = file.Find(pwd.."*", "LUA", "namedesc")
MsgN("[Lawlib] Loading files...")

local function addFiles(files, dir)
    if dir == nil then dir = "" end
    for _, f in ipairs(files) do
        if string.Left(f, 2) == "sh" then
            table.insert(sh_files, f) end
        if string.Left(f, 2) == "cl" then
            table.insert(cl_files, f) end
        if string.Left(f, 2) == "sv" then
            table.insert(sv_files, f) end
    end
end
addFiles(files)

if SERVER then
    for _, f in ipairs(cl_files) do
        MsgN("Sending CLIENT file "..pwd..f)
        AddCSLuaFile(pwd..f)
    end
    for _, f in ipairs(sh_files) do
        MsgN("Loading+Sending SHARED file "..pwd..f)
        AddCSLuaFile(pwd..f)
        include(pwd..f)
    end
    for _, f in ipairs(sv_files) do
        MsgN("Loading SERVER file "..pwd..f)
        include(pwd..f)
    end
end
if CLIENT then
    for _, f in ipairs(sh_files) do
        MsgN("Loading SHARED file "..pwd..f)
        include(pwd..f)
    end
    for _, f in ipairs(cl_files) do
        MsgN("Loading CLIENT file "..pwd..f)
        include(pwd..f)
    end
end
MsgN("==================Loaded Lawlib==================")