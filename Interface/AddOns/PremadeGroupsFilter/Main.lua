-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2022 Elotheon-Arthas-EU
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

PGF.currentSearchResults = {}
PGF.lastSearchEntryReset = time()
PGF.previousSearchExpression = ""
PGF.currentSearchExpression = ""
PGF.previousSearchLeaders = {}
PGF.currentSearchLeaders = {}
PGF.searchResultIDInfo = {}
PGF.numResultsBeforeFilter = 0
PGF.numResultsAfterFilter = 0

function PGF.ResetSearchEntries()
    -- make sure to wait at least some time between two resets
    if time() - PGF.lastSearchEntryReset > C.SEARCH_ENTRY_RESET_WAIT then
        PGF.previousSearchLeaders = PGF.Table_Copy_Shallow(PGF.currentSearchLeaders)
        PGF.currentSearchLeaders = {}
        PGF.previousSearchExpression = PGF.currentSearchExpression
        PGF.lastSearchEntryReset = time()
        PGF.searchResultIDInfo = {}
        PGF.numResultsBeforeFilter = 0
        PGF.numResultsAfterFilter = 0
    end
end

function PGF.GetUserSortingTable()
    local sorting = PGF.Dialog:GetSortingExpression()
    if PGF.Empty(sorting) then return 0, {} end
    -- example string:  "friends asc, age desc , foo asc, bar   desc , x"
    -- resulting table: { ["friends"] = "asc", ["age"] = "desc", ["foo"] = "asc", ["bar"] = "desc" }
    local c = 0
    local t = {}
    for k, v in string.gmatch(sorting, "(%w+)%s+(%w+),?") do
        c = c + 1
        t[k] = v
    end
    return c, t
end

function PGF.SortByExpression(searchResultID1, searchResultID2)
    local sortTableSize, sortTable = PGF.GetUserSortingTable()
    local info1 = PGF.searchResultIDInfo[searchResultID1]
    local info2 = PGF.searchResultIDInfo[searchResultID2]
    if sortTableSize == 0 or not info1 or not info2 then
        return PGF.SortByFriendsAndAge(searchResultID1, searchResultID2)
    end
    for k, v in pairs(sortTable) do
        if info1.env[k] ~= info2.env[k] then -- works with unknown 'k' as 'nil ~= nil' is false (or 'nil == nil' is true)
            if v == "desc" then
                if type(info1.env[k]) == "boolean" then return info1.env[k] end -- true before false
                return info1.env[k] > info2.env[k]
            else -- works with unknown 'v', in this case sort ascending by default
                if type(info1.env[k]) == "boolean" then return info2.env[k] end -- false before true
                return info1.env[k] < info2.env[k]
            end
        end
    end
    -- no sorting defined or all properties are the same, fall back to default sorting
    return PGF.SortByFriendsAndAge(searchResultID1, searchResultID2)
end

function PGF.SortByFriendsAndAge(searchResultID1, searchResultID2)
    if not searchResultID1 or not searchResultID2 then return false end -- race condition

    -- look-up via table should be faster
    local info1 = PGF.searchResultIDInfo[searchResultID1]
    local info2 = PGF.searchResultIDInfo[searchResultID2]
    if not info1 or not info2 then return false end -- race condition

    -- sort applications to the top
    local isApplication1 = info1.env.appstatus ~= "none" or info1.env.pendingstatus or false
    local isApplication2 = info2.env.appstatus ~= "none" or info2.env.pendingstatus or false
    if isApplication1 ~= isApplication2 then return isApplication1 end
    if info1.env.appduration ~= info2.env.appduration then return info1.env.appduration > info2.env.appduration end

    local searchResultInfo1 = info1.searchResultInfo
    local searchResultInfo2 = info2.searchResultInfo

    -- sort by partyfit
    local hasRemainingRole1 = PGF.HasRemainingSlotsForLocalPlayerRole(info1.memberCounts)
    local hasRemainingRole2 = PGF.HasRemainingSlotsForLocalPlayerRole(info2.memberCounts)
    if hasRemainingRole1 ~= hasRemainingRole2 then return hasRemainingRole1 end

    -- sort by friends desc
    if searchResultInfo1.numBNetFriends ~= searchResultInfo2.numBNetFriends then
        return searchResultInfo1.numBNetFriends > searchResultInfo2.numBNetFriends
    end
    if searchResultInfo1.numCharFriends ~= searchResultInfo2.numCharFriends then
        return searchResultInfo1.numCharFriends > searchResultInfo2.numCharFriends
    end
    if searchResultInfo1.numGuildMates ~= searchResultInfo2.numGuildMates then
        return searchResultInfo1.numGuildMates > searchResultInfo2.numGuildMates
    end

    -- if dungeon, sort by mprating desc
    if info1.activityInfo.categoryID == C.CATEGORY_ID.DUNGEON or
       info2.activityInfo.categoryID == C.CATEGORY_ID.DUNGEON then
        if info1.env.mprating ~= info2.env.mprating then
            return info1.env.mprating > info2.env.mprating
        end
    end
    -- if arena or RBG, sort by pvprating desc
    if info1.activityInfo.categoryID == C.CATEGORY_ID.ARENA or
       info2.activityInfo.categoryID == C.CATEGORY_ID.ARENA or
       info1.activityInfo.categoryID == C.CATEGORY_ID.RATED_BATTLEGROUND or
       info2.activityInfo.categoryID == C.CATEGORY_ID.RATED_BATTLEGROUND then
        if info1.env.pvprating ~= info2.env.pvprating then
            return info1.env.pvprating > info2.env.pvprating
        end
    end

    if searchResultInfo1.isWarMode ~= searchResultInfo2.isWarMode then
        return searchResultInfo1.isWarMode == C_PvP.IsWarModeDesired()
    end

    return searchResultInfo1.age < searchResultInfo2.age
end

--- Ensures that all class-role/role-class and ranged/melees keywords are initialized to zero in the filter environment,
--- because the values would cause a semantic error otherwise (because they do not exist)
--- @generic V
--- @param env table<string, V> environment to be prepared
function PGF.InitClassRoleTypeKeywords(env)
    env.cloth = 0
    env.leather = 0
    env.mail = 0
    env.plate = 0
    env.ranged = 0
    env.ranged_strict = 0
    env.melees = 0
    env.melees_strict = 0
    for class, type in pairs(C.DPS_CLASS_TYPE) do
        local classPlural = class:lower() .. "s"
        env[classPlural] = 0
        for role, prefix in pairs(C.ROLE_PREFIX) do
            local classRolePlural = prefix .. "_" .. classPlural
            local roleClassPlural = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRolePlural] = 0
            env[roleClassPlural] = 0
        end
    end
end

--- Puts a table that maps localized boss names to a boolean that indicates if the boss was defeated
--- @generic V
--- @param resultID number search result identifier
--- @param env table<string, V> environment to be prepared
function PGF.PutEncounterNames(resultID, env)
    local encounterToBool = {}
    -- return false for all values not explicitly set to true
    local encounterToBoolMeta = {}
    encounterToBoolMeta.__index = function (table, key) return false end
    setmetatable(encounterToBool, encounterToBoolMeta)

    local encounterInfo = C_LFGList.GetSearchResultEncounterInfo(resultID); -- list of localized boss names
    if encounterInfo then
        for _, val in pairs(encounterInfo) do
            encounterToBool[val] = true
            encounterToBool[val:lower()] = true
        end
    end

    env.boss = encounterToBool
end

--- Initializes all class-role/role-class and ranged/melees keywords and increments them to their correct value
--- @generic V
--- @param resultID number search result identifier
--- @param searchResultInfo table<string, V> search result info from API
--- @param env table<string, V> environment to be prepared
function PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
    PGF.InitClassRoleTypeKeywords(env)
    for i = 1, searchResultInfo.numMembers do
        local role, class = C_LFGList.GetSearchResultMemberInfo(resultID, i)
        local classPlural = class:lower() .. "s" -- plural form of the class in english
        env[classPlural] = env[classPlural] + 1
        local armor = C.DPS_CLASS_TYPE[class].armor
        if armor then
            env[armor] = env[armor] + 1
        end
        if role then
            local classRolePlural = C.ROLE_PREFIX[role] .. "_" .. class:lower() .. "s"
            local roleClassPlural = class:lower() .. "_" .. C.ROLE_SUFFIX[role]
            env[classRolePlural] = env[classRolePlural] + 1
            env[roleClassPlural] = env[roleClassPlural] + 1
            if role == "DAMAGER" then
                if C.DPS_CLASS_TYPE[class].range and C.DPS_CLASS_TYPE[class].melee then
                    env.ranged = env.ranged + 1
                    env.melees = env.melees + 1
                elseif C.DPS_CLASS_TYPE[class].range then
                    env.ranged = env.ranged + 1
                    env.ranged_strict = env.ranged_strict + 1
                elseif C.DPS_CLASS_TYPE[class].melee then
                    env.melees = env.melees + 1
                    env.melees_strict = env.melees_strict + 1
                end
            end
        end
    end
end

function PGF.DoFilterSearchResults(results)
    --print(debugstack())
    --print("filtering, size is "..#results)

    if not PGF.Dialog:GetEnabled() then return results end
    if not results or #results == 0 then return results end

    local exp = PGF.Dialog:GetFilterExpression()
    PGF.Logger:Debug("Main: exp = "..exp)
    PGF.currentSearchExpression = exp

    local playerInfo = PGF.GetPlayerInfo()

    PGF.numResultsBeforeFilter = #results
    -- loop backwards through the results list so we can remove elements from the table
    for idx = #results, 1, -1 do
        local resultID = results[idx]
        local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID)
        -- /dump C_LFGList.GetSearchResultInfo(select(2, C_LFGList.GetSearchResults())[1])
        -- name and comment are now protected strings like "|Ks1969|k0000000000000000|k" which can only be printed
        local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
        -- /dump C_LFGList.GetApplicationInfo(select(2, C_LFGList.GetSearchResults())[1])
        local memberCounts = C_LFGList.GetSearchResultMemberCounts(resultID)
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(searchResultInfo.activityID, resultID)
        local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)

        local difficulty = PGF.GetDifficulty(searchResultInfo.activityID, activityInfo.fullName, activityInfo.shortName)

        local env = {}
        env.activity = searchResultInfo.activityID
        env.activityname = activityInfo.fullName:lower()
        env.leader = searchResultInfo.leaderName and searchResultInfo.leaderName:lower() or ""
        env.age = math.floor(searchResultInfo.age / 60) -- age in minutes
        env.agesecs = searchResultInfo.age -- age in seconds
        env.voice = searchResultInfo.voiceChat and searchResultInfo.voiceChat ~= ""
        env.voicechat = searchResultInfo.voiceChat
        env.ilvl = searchResultInfo.requiredItemLevel or 0
        env.hlvl = searchResultInfo.requiredHonorLevel or 0
        env.friends = searchResultInfo.numBNetFriends + searchResultInfo.numCharFriends + searchResultInfo.numGuildMates
        env.members = searchResultInfo.numMembers
        env.tanks = memberCounts.TANK
        env.heals = memberCounts.HEALER
        env.healers = memberCounts.HEALER
        env.dps = memberCounts.DAMAGER + memberCounts.NOROLE
        env.partyfit = PGF.HasRemainingSlotsForLocalPlayerPartyRoles(memberCounts)
        env.defeated = numGroupDefeated
        env.normal     = difficulty == C.NORMAL
        env.heroic     = difficulty == C.HEROIC
        env.mythic     = difficulty == C.MYTHIC
        env.mythicplus = difficulty == C.MYTHICPLUS
        env.myrealm = searchResultInfo.leaderName and searchResultInfo.leaderName ~= "" and searchResultInfo.leaderName:find('-') == nil or false
        env.partialid = numPlayerDefeated > 0
        env.fullid = numPlayerDefeated > 0 and numPlayerDefeated == maxBosses
        env.noid = not env.partialid and not env.fullid
        env.matchingid = groupAhead == 0 and groupBehind == 0
        env.bossesmatching = matching
        env.bossesahead = groupAhead
        env.bossesbehind = groupBehind
        env.maxplayers = activityInfo.maxNumPlayers
        env.suggestedilvl = activityInfo.ilvlSuggestion
        env.minlvl = activityInfo.minLevel
        env.categoryid = activityInfo.categoryID
        env.groupid = activityInfo.groupFinderActivityGroupID
        env.autoinv = searchResultInfo.autoAccept
        env.questid = searchResultInfo.questID
        env.declined = PGF.IsHardDeclinedGroup(searchResultInfo)
        env.harddeclined = env.declined
        env.softdeclined = PGF.IsSoftDeclinedGroup(searchResultInfo)
        env.warmode = searchResultInfo.isWarMode
        env.playstyle = searchResultInfo.playstyle
        env.earnconq  = searchResultInfo.playstyle == 1
        env.learning  = searchResultInfo.playstyle == 2
        env.beattimer = searchResultInfo.playstyle == 3
        env.push      = searchResultInfo.playstyle == 3
        env.mprating = searchResultInfo.leaderOverallDungeonScore or 0
        env.mpmaprating = 0
        env.mpmapname   = ""
        env.mpmapmaxkey = 0
        env.mpmapintime = false
        if searchResultInfo.leaderDungeonScoreInfo then
            env.mpmaprating = searchResultInfo.leaderDungeonScoreInfo.mapScore
            env.mpmapname   = searchResultInfo.leaderDungeonScoreInfo.mapName
            env.mpmapmaxkey = searchResultInfo.leaderDungeonScoreInfo.bestRunLevel
            env.mpmapintime = searchResultInfo.leaderDungeonScoreInfo.finishedSuccess
        end
        env.pvpactivityname = ""
        env.pvprating = 0
        env.pvptierx = 0
        env.pvptier = 0
        env.pvptiername = ""
        if searchResultInfo.leaderPvpRatingInfo then
            env.pvpactivityname = searchResultInfo.leaderPvpRatingInfo.activityName
            env.pvprating       = searchResultInfo.leaderPvpRatingInfo.rating
            env.pvptierx        = searchResultInfo.leaderPvpRatingInfo.tier
            env.pvptier         = C.PVP_TIER_MAP[searchResultInfo.leaderPvpRatingInfo.tier].tier
            env.pvptiername     = PVPUtil.GetTierName(searchResultInfo.leaderPvpRatingInfo.tier)
        end
        env.horde = searchResultInfo.leaderFactionGroup == 0
        env.alliance = searchResultInfo.leaderFactionGroup == 1
        env.crossfaction = searchResultInfo.crossFactionListing or false
        env.appstatus = appStatus
        env.pendingstatus = pendingStatus
        env.appduration = appDuration

        PGF.PutSearchResultMemberInfos(resultID, searchResultInfo, env)
        PGF.PutEncounterNames(resultID, env)

        env.hasbr = env.druids > 0 or env.paladins > 0 or env.warlocks > 0 or env.deathknights > 0
        env.hasbl = env.shamans > 0 or env.evokers > 0 or env.hunters > 0 or env.mages > 0
        env.hashero = env.hasbl
        env.haslust = env.hasbl

        env.brfit = env.hasbr or PGF.PlayerOrGroupHasBattleRezz() or PGF.HasRemainingSlotsForBattleRezzAfterJoin(memberCounts)
        env.blfit = env.hasbl or PGF.PlayerOrGroupHasBloodlust() or PGF.HasRemainingSlotsForBloodlustAfterJoin(memberCounts)

        env.myilvl = playerInfo.avgItemLevelEquipped
        env.myilvlpvp = playerInfo.avgItemLevelPvp
        env.mymprating = playerInfo.mymprating
        env.myaffixrating = playerInfo.affixRating[searchResultInfo.activityID] or 0
        env.mydungeonrating = playerInfo.dungeonRating[searchResultInfo.activityID] or 0
        env.myavgaffixrating = playerInfo.avgAffixRating
        env.mymedianaffixrating = playerInfo.medianAffixRating
        env.myavgdungeonrating = playerInfo.avgDungeonRating
        env.mymediandungeonrating = playerInfo.medianDungeonRating

        local aID = searchResultInfo.activityID
        env.arena2v2 = aID == 6 or aID == 491 or aID == 731 or aID == 732
        env.arena3v3 = aID == 7 or aID == 490 or aID == 733 or aID == 734

        -- Warlords of Draenor raids
        --              normal        heroic        mythic
        env.hm        = aID ==  37 or aID ==  38 or aID == 399  -- Highmaul
        env.brf       = aID ==  39 or aID ==  40 or aID == 400  -- Blackrock Foundry
        env.hfc       = aID == 409 or aID == 410 or aID == 412  -- Hellfire Citadel
        local wodraid = env.hm or env.brf or env.hfc -- all WoD raids

        -- Legion raids
        --                 normal        heroic        mythic
        env.en           = aID == 413 or aID == 414 or aID == 468  -- The Emerald Nightmare
        env.nh           = aID == 415 or aID == 416 or aID == 481  -- The Nighthold
        env.tov          = aID == 456 or aID == 457 or aID == 480  -- Trial of Valor
        env.tosg         = aID == 479 or aID == 478 or aID == 492  -- Tomb of Sargeras
        env.atbt         = aID == 482 or aID == 483 or aID == 493  -- Antorus, the Burning Throne
        local legionraid = env.en or env.nh or env.tov or env.tosg or env.atbt -- all Legion raids

        -- Battle for Azeroth raids
        --              normal        heroic        mythic
        env.uldir     = aID == 494 or aID == 495 or aID == 496  -- Uldir
        env.bod       = aID == 663 or aID == 664 or aID == 665  -- Battle of Dazar'alor
        env.daz       = env.bod
        env.cs        = aID == 666 or aID == 667 or aID == 668  -- Crucible of Storms
        env.cru       = env.cs
        env.ete       = aID == 670 or aID == 671 or aID == 672  -- The Eternal Palace
        env.tep       = env.ete
        env.nya       = aID == 687 or aID == 686 or aID == 685  -- Ny’alotha, the Waking City
        env.ny        = env.nya
        local bfaraid = env.uldir or env.bod or env.cs or env.ete or env.nya -- all BfA raids

        -- Shadowlands raids
        --             normal        heroic        mythic
        env.cn       = aID == 720  or aID == 722  or aID == 721  -- Castle Nathria
        env.sod      = aID == 743  or aID == 744  or aID == 745  -- Sanctum of Domination
        env.sfo      = aID == 1020 or aID == 1021 or aID == 1022 -- Sepulcher of the First Ones
        local slraid = env.cn or env.sod or env.sfo -- all Shadowlands raids

        -- Dragonflight raids
        --             normal         heroic         mythic
        env.voti     = aID == 1189 or aID == 1190 or aID == 1191 -- Vault of the Incarnates
        env.asc      = aID == 1235 or aID == 1236 or aID == 1237 -- Aberrus, the Shadowed Crucible
        env.atdh     = aID == 1251 or aID == 1252 or aID == 1253 -- Amirdrassil, the Dream's Hope
        local dfraid = env.voti or env.asc or env.atdh -- all Dragonflight raids

        -- Legion dungeons
        --                    normal        heroic        mythic        mythic+
        env.eoa             = aID == 425 or aID == 435 or aID == 445 or aID == 459 -- Eye of Azshara
        env.dht             = aID == 426 or aID == 436 or aID == 446 or aID == 460 -- Darkheart Thicket
        env.nl              = aID == 428 or aID == 438 or aID == 448 or aID == 462 -- Neltharion's Lair
        env.brh             = aID == 430 or aID == 440 or aID == 450 or aID == 463 -- Black Rook Hold
        env.votw            = aID == 431 or aID == 441 or aID == 451 or aID == 464 -- Vault of the Wardens
        env.cos             = aID == 433 or aID == 443 or aID == 453 or aID == 466 -- Court of Stars
        local legiondungeon = env.eoa or env.dht or env.nl or env.brh or env.votw or env.cos -- all Legion dungeons
 
        -- Battle for Azeroth dungeons
        --                 normal        heroic        mythic        mythic+       normal2
        env.ad           = aID == 501 or aID == 500 or aID == 499 or aID == 502 or aID == 543  -- Atal'Dazar
        env.tosl         = aID == 503 or aID == 505 or aID == 645 or aID == 504 or aID == 542  -- Temple of Sethraliss
        env.tos          = env.tosl
        env.tur          = aID == 506 or aID == 508 or aID == 644 or aID == 507 or aID == 541  -- The Underrot
        env.tml          = aID == 509 or aID == 511 or aID == 646 or aID == 510 or aID == 540  -- The MOTHERLODE
        env.kr           = aID == 512 or aID == 515 or aID == 513 or aID == 514                -- Kings' Rest
                                                    or aID == 660 or aID == 661
        env.fh           = aID == 516 or aID == 519 or aID == 517 or aID == 518 or aID == 539  -- Freehold
        env.sots         = aID == 520 or aID == 523 or aID == 521 or aID == 522 or aID == 538  -- Shrine of the Storm
        env.td           = aID == 524 or aID == 527 or aID == 525 or aID == 526 or aID == 537  -- Tol Dagor
        env.wm           = aID == 528 or aID == 531 or aID == 529 or aID == 530 or aID == 536  -- Waycrest Manor
        env.sob          = aID == 532 or aID == 535 or aID == 533 or aID == 534                -- Siege of Boralus
                                                    or aID == 658 or aID == 659
        env.opmj         =               aID == 682               or aID == 679  -- Operation: Mechagon - Junkyard
        env.opmw         =               aID == 684               or aID == 683  -- Operation: Mechagon - Workshop
        env.opm          = env.opmj or env.opmw     or aID == 669                -- Operation: Mechagon
        local bfadungeon = env.ad or env.tosl or env.tur or env.tml or env.kr or env.fh or env.sots or env.td or env.wm or env.sob or env.opm -- all BfA dungeons

        -- Shadowlands dungeons
        --                normal        heroic        mythic        mythic+
        env.pf          = aID == 688 or aID == 689 or aID == 690 or aID == 691  -- Plaguefall
        env.dos         = aID == 692 or aID == 693 or aID == 694 or aID == 695  -- De Other Side
        env.hoa         = aID == 696 or aID == 697 or aID == 698 or aID == 699  -- Halls of Atonement
        env.mots        = aID == 700 or aID == 701 or aID == 702 or aID == 703  -- Mists of Tirna Scithe
        env.sd          = aID == 704 or aID == 707 or aID == 706 or aID == 705  -- Sanguine Depths
        env.soa         = aID == 708 or aID == 711 or aID == 710 or aID == 709  -- Spires of Ascension
        env.nw          = aID == 712 or aID == 715 or aID == 714 or aID == 713  -- The Necrotic Wake
        env.top         = aID == 716 or aID == 719 or aID == 718 or aID == 717  -- Theater of Pain
        env.tazs        =               aID == 1018              or aID == 1016 -- Tazavesh: Streets of Wonder
        env.tazg        =               aID == 1019              or aID == 1017 -- Tazavesh: So'leah's Gambit
        env.taz         = env.tazs or env.tazg     or aID == 746                -- Tazavesh, the Veiled Market
        local sldungeon = env.pf or env.dos or env.hoa or env.mots or env.sd or env.soa or env.nw or env.top or env.taz -- all SL dungeons

        -- Shadowland Season 4 dungeons
        env.gd    = aID == 183  -- Grimrail Depot
        env.id    = aID == 180  -- Iron Docks
        env.lkara = aID == 471  -- Lower Karazahn
        env.ukara = aID == 473  -- Upper Karazhan
        env.sls4  = env.gd or env.id or env.lkara or env.ukara or env.opmj or env.opmw or env.tazs or env.tazg -- all SL Season 4 dungeons

        -- Dragonflight dungeons
        --                normal         heroic         mythic         mythic+
        env.aa          = aID == 1157 or aID == 1158 or aID == 1159 or aID == 1160 -- Algeth'ar Academy
        env.bh          = aID == 1161 or aID == 1162 or aID == 1163 or aID == 1164 -- Brackenhide Hollow
        env.hoi         = aID == 1165 or aID == 1166 or aID == 1167 or aID == 1168 -- Halls of Infusion
        env.nt          = aID == 1169 or aID == 1170 or aID == 1171 or aID == 1172 -- Neltharus
        env.rlp         = aID == 1173 or aID == 1174 or aID == 1175 or aID == 1176 -- Ruby Life Pools
        env.av          = aID == 1177 or aID == 1178 or aID == 1179 or aID == 1180 -- The Azure Vault
        env.no          = aID == 1181 or aID == 1182 or aID == 1183 or aID == 1184 -- The Nokhud Offensive
        env.lot         = aID == 1185 or aID == 1186 or aID == 1187 or aID == 1188 or aID == 1194 -- Uldaman: Legacy of Tyr
        env.doti        = aID == 1244 or aID == 1245 or aID == 1246 or aID == 1247 or aID == 1248 -- Dawn of the Infinite
        env.fall        =                aID == 1245                or aID == 1247  -- Dawn of the Infinite: Galakrond's Fall
        env.rise        =                aID == 1246                or aID == 1248  -- Dawn of the Infinite: Murozond's Rise
        local dfdungeon = env.aa or env.bh or env.hoi or env.nt or env.rlp or env.av or env.no or env.lot or env.doti -- all Dragonflight dungeons

        -- Dragonflight Season 1 dungeons
        env.tjs  = aID == 1192 -- Temple of the Jade Serpent (Mists of Pandaria)
        env.sbg  = aID == 1193 -- Shadowmoon Burial Grounds (Warlords of Draenor)
        env.hov  = aID == 461  -- Halls of Valor (Legion)
        env.cos  = aID == 466  -- Court of Stars (Legion)
        env.dfs1 = env.rlp or env.no or env.av or env.aa or env.hov or env.cos or env.sbg or env.tjs
        -- Dragonflight Season 2 dungeons
        env.vp   = aID == 1195 -- Vortex Pinnacle (Cataclysm)
        env.dfs2 = env.bh or env.hoi or env.lot or env.nt or env.fh or env.tur or env.nl or env.vp
        -- Dragonflight Season 3 dungeons
        env.tott = aID == 1274 -- Throne of the Tides (Cataclysm)
        env.teb  = aID == 184  -- The Everbloom (Warlords of Draenor)
        env.dfs2 = env.fall or env.rise or env.wm or env.ad or env.dht or env.brh or env.tott or env.teb

        -- find more IDs: /run for i=1146,2000 do local info = C_LFGList.GetActivityInfoTable(i); if info then print(i, info.fullName) end end
        -- or simply here: https://wago.tools/db2/GroupFinderActivity?sort[ID]=desc

        -- Addon filters
        --
        env.wod    = wodraid
        env.legion = legiondungeon or legionraid
        env.bfa    = bfadungeon or bfaraid
        env.sl     = sldungeon or slraid
        env.df     = dfdungeon or dfraid

        PGF.PutRaiderIOAliases(env)
        if PGF.PutRaiderIOMetrics then
            PGF.PutRaiderIOMetrics(env, searchResultInfo.leaderName, searchResultInfo.activityID)
        end
        if PGF.PutPremadeRegionInfo then
            PGF.PutPremadeRegionInfo(env, searchResultInfo.leaderName)
        end

        PGF.searchResultIDInfo[resultID] = {
            env = env,
            searchResultInfo = searchResultInfo,
            memberCounts = memberCounts,
            activityInfo = activityInfo,
        }
        if PGF.DoesPassThroughFilter(env, exp) then
            -- leaderName is usually still nil at this point if the group is new, but we can live with that
            if searchResultInfo.leaderName then PGF.currentSearchLeaders[searchResultInfo.leaderName] = true end
        else
            table.remove(results, idx)
        end
    end
    PGF.numResultsAfterFilter = #results

    table.sort(results, PGF.SortByExpression)
    return results
end

function PGF. PutRaiderIOAliases(env)
    env.lowr = env.lkara
    env.uppr = env.ukara

    -- Battle for Azeroth
    env.siege = env.sob  -- Siege of Boralus
    env.yard  = env.opmj -- Operation: Mechagon - Junkyard
    env.work  = env.opmw -- Operation: Mechagon - Workshop
    env.undr  = env.tur  -- The Underrot
    env.ml    = env.tml  -- The MOTHERLODE

    -- Shadowlands
    env.mists = env.mots -- Mists of Tirna Scithe
    env.strt  = env.tazs -- Tazavesh: Streets of Wonder
    env.gmbt  = env.tazg -- Tazavesh: So'leah's Gambit

    -- Dragonflight
    env.nelt  = env.nt   -- Neltharus
    env.uld   = env.lot  -- Uldaman: Legacy of Tyr
end

function PGF.ColorGroupTexts(self, searchResultInfo)
    if not PremadeGroupsFilterSettings.coloredGroupTexts then return end

    -- try once again to update the leaderName (this information is not immediately available)
    if searchResultInfo.leaderName then PGF.currentSearchLeaders[searchResultInfo.leaderName] = true end
    -- self.ActivityName:SetText("[" .. searchResultInfo.activityID .. "/" .. self.resultID .. "] " .. self.ActivityName:GetText()) -- DEBUG
    if not searchResultInfo.isDelisted then
        -- color name if new
        if PGF.currentSearchExpression ~= "true"                        -- not trivial search
        and PGF.currentSearchExpression == PGF.previousSearchExpression -- and the same search
        and (searchResultInfo.leaderName and not PGF.previousSearchLeaders[searchResultInfo.leaderName]) then -- and leader is new
            local color = C.COLOR_ENTRY_NEW
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        -- color name if declined
        if PGF.IsSoftDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_SOFT
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        if PGF.IsHardDeclinedGroup(searchResultInfo) then
            local color = C.COLOR_ENTRY_DECLINED_HARD
            self.Name:SetTextColor(color.R, color.G, color.B)
        end
        -- color activity if lockout
        local numGroupDefeated, numPlayerDefeated, maxBosses,
              matching, groupAhead, groupBehind = PGF.GetLockoutInfo(searchResultInfo.activityID, self.resultID)
        local color
        if numPlayerDefeated > 0 and numPlayerDefeated == maxBosses then
            color = C.COLOR_LOCKOUT_FULL
        elseif numPlayerDefeated > 0 and groupAhead == 0 and groupBehind == 0 then
            color = C.COLOR_LOCKOUT_MATCH
        end
        if color then
            self.ActivityName:SetTextColor(color.R, color.G, color.B)
        end
    end
end

function PGF.OnLFGListSearchEntryUpdate(self)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(self.resultID)
    PGF.ColorGroupTexts(self, searchResultInfo)
    PGF.ColorApplications(self, searchResultInfo)
    PGF.AddRoleIndicators(self, searchResultInfo)
    PGF.AddRatingInfo(self, searchResultInfo)
end

function PGF.OnLFGListSearchPanelUpdateResultList(self)
    PGF.Logger:Debug("PGF.OnLFGListSearchPanelUpdateResultList")
    PGF.currentSearchResults = self.results
    PGF.ResetSearchEntries()
    PGF.FilterSearchResults()
end

function PGF.FilterSearchResults()
    PGF.Logger:Debug("PGF.FilterSearchResults")
    local copy = PGF.Table_Copy_Shallow(PGF.currentSearchResults)
    local results = PGF.DoFilterSearchResults(copy)
    -- publish
    LFGListFrame.SearchPanel.results = results
    LFGListFrame.SearchPanel.totalResults = #results
    LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
end

hooksecurefunc("LFGListSearchEntry_Update", PGF.OnLFGListSearchEntryUpdate)
hooksecurefunc("LFGListSearchPanel_UpdateResultList", PGF.OnLFGListSearchPanelUpdateResultList)
