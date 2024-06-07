print("Fungus bungus initiated (dead's stolen code edition) by Dead [p.s. by DeadCodes (if it wasn't obvious already)]")
local API = require("api")
local UTILS = require("utils")

API.SetDrawTrackedSkills(true)

-- We update this value based on the state transitions
local STATE = 0

-- All the states that we want to track
local STATES = {
    MINE = 0,
    EMPTY_BAGS = 1
}

local function findNpcOrObject(npcid, distance, objType)
    local distance = distance or 20

    return #API.GetAllObjArray1({npcid}, distance, {objType}) > 0
end

function findObj(objectid, distance)
    local distance = distance or 15
    return #API.GetAllObjArrayInteract({objectid}, distance, {0}) > 0
end

local fungy = {
    NotShiny = {121765, 121768, 121762, 121759}, -- type12
    Shiny = {121769, 121763, 121760, 121766} -- type0
}

local function emptyBags()
    local Enriched = "Enriched calcified fungus"
    local Regular = "Calcified fungus"
    print("Emptying fungy")
    repeat
        if (API.InvItemcount_String(Regular) >= 1) then
            API.KeyboardPress2(0x34, 60, 100)
        end
        if (API.InvItemcount_String(Enriched) >= 1) then
            API.KeyboardPress2(0x35, 60, 100)
        end
    until (API.InvItemcount_String(Enriched) == 0) and (API.InvItemcount_String(Regular) == 0)
    STATE = STATES.MINE_CLAY
end

local function InvyCheck()
    if API.InvFull_() then
        emptyBags()
    end
end

local function mineFungy() -- good luck understanding this l33tG0Dhax0rZzZ code
    local hoverProgress = API.LocalPlayer_HoverProgress()
    math.randomseed(os.time())
    if hoverProgress < 80 + math.random(10, 30) or not API.CheckAnim(20) then
        local hasShiny = false
        for _, shiny in ipairs(fungy.Shiny) do
            if findObj(shiny, 50) then
                print("Shiny found, mining shiny!")
                API.DoAction_Object1(0x3a, 0, {shiny}, 50)
                UTILS.countTicks(2)
                API.WaitUntilMovingEnds()
                hasShiny = true
                break
            end
        end
        if not hasShiny then
            for _, notshiny in ipairs(fungy.NotShiny) do
                if findNpcOrObject(notshiny, 50, 12) then
                    print("No shiny fungy, mining!")
                    API.DoAction_Object1(0x3a, 0, {notshiny}, 50)
                    UTILS.countTicks(2)
                    API.WaitUntilMovingEnds()
                    break
                end
            end
        end
    end
end

local function checkStates()
    UTILS:gameStateChecks()
    UTILS:antiIdle()
    if API.InvFull_() then
        STATE = STATES.EMPTY_BAGS
    else
        STATE = STATES.MINE
    end
end

local function priffClayMiner()

    API.DoRandomEvents()
    if STATE == STATES.MINE then
        mineFungy()
    elseif STATE == STATES.EMPTY_BAGS then
        InvyCheck()
    end
    checkStates()
end

API.Write_LoopyLoop(true)
while API.Read_LoopyLoop() do
    priffClayMiner()
end
API.SetDrawTrackedSkills(false)
