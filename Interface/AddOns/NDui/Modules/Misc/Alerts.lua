local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:GetModule("Misc")

local format, gsub, strsplit = string.format, string.gsub, string.split
local pairs, tonumber = pairs, tonumber

function module:AddAlerts()
	self:SoloInfo()
	self:RareAlert()
	self:InterruptAlert()
	self:VersionCheck()
	self:ExplosiveAlert()
	self:PlacedItemAlert()
	self:UunatAlert()
end

--[[
	SoloInfo是一个告知你当前副本难度的小工具，防止我有时候单刷时进错难度了。
	instList左侧是副本ID，你可以使用"/getid"命令来获取当前副本的ID；右侧的是副本难度，常用的一般是：2为5H，4为25普通，6为25H。
]]

function module:SoloInfo()
	if not NDuiDB["Misc"]["SoloInfo"] then return end

	local instList = {
		[556] = 2,		-- H塞塔克大厅，乌鸦
		[575] = 2,		-- H乌特加德之巅，蓝龙
		[585] = 2,		-- H魔导师平台，白鸡
		[631] = 6,		-- 25H冰冠堡垒，无敌
		[1205] = 16,	-- M黑石，裂蹄牛
		[1651] = 23,	-- M卡拉赞，新午夜，
	}

	local f
	local function setupAlertFrame()
		if f then f:Show() return end

		f = CreateFrame("Frame", nil, UIParent)
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
		f:SetSize(150, 70)
		B.CreateBD(f)
		B.CreateSD(f)
		B.CreateTex(f)
		f.Text = B.CreateFS(f, 14, "")
		f.Text:SetWordWrap(true)
		f:SetScript("OnMouseUp", function() f:Hide() end)
	end

	local function updateAlert()
		local name, instType, diffID, diffName, _, _, _, instID = GetInstanceInfo()
		if instType ~= "none" and diffID ~= 24 and instList[instID] and instList[instID] ~= diffID then
			setupAlertFrame()
			f.Text:SetText(DB.InfoColor..name..DB.MyColor.."\n( "..diffName.." )\n\n"..DB.InfoColor..L["Wrong Difficulty"])
		else
			if f then f:Hide() end
		end
	end

	B:RegisterEvent("ZONE_CHANGED_NEW_AREA", updateAlert)
	B:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", updateAlert)
	B:RegisterEvent("PLAYER_ENTERING_WORLD", updateAlert)
end

--[[
	发现稀有/事件时的通报插件
]]
function module:RareAlert()
	if not NDuiDB["Misc"]["RareAlerter"] then return end

	local isIgnored = {
		[1153] = true,		-- 部落要塞
		[1159] = true,		-- 联盟要塞
		[1803] = true,		-- 涌泉海滩
		[1876] = true,		-- 部落激流堡
		[1943] = true,		-- 联盟激流堡
		[2111] = true,		-- 黑海岸前线
	}

	local cache = {}
	local function updateAlert(_, id)
		local _, instType, _, _, _, _, _, instID = GetInstanceInfo()
		if isIgnored[instID] then return end

		if id and not cache[id] then
			local info = C_VignetteInfo.GetVignetteInfo(id)
			if not info then return end
			local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(info.atlasName)
			if not filename then return end

			local atlasWidth = width/(txRight-txLeft)
			local atlasHeight = height/(txBottom-txTop)
			local tex = format("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t", filename, 0, 0, atlasWidth, atlasHeight, atlasWidth*txLeft, atlasWidth*txRight, atlasHeight*txTop, atlasHeight*txBottom)
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Rare Found"]..tex..(info.name or ""))
			if NDuiDB["Misc"]["AlertinChat"] then
				print("  -> "..DB.InfoColor..L["Rare Found"]..tex..(info.name or ""))
			end
			if not NDuiDB["Misc"]["RareAlertInWild"] or instType == "none" then
				--PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
				PlaySound(23404, "master")
			end
			cache[id] = true
		end
		if #cache > 666 then wipe(cache) end
	end

	B:RegisterEvent("VIGNETTE_MINIMAP_UPDATED", updateAlert)
end

--[[
	闭上你的嘴！
	打断、偷取及驱散法术时的警报
]]
local function msgChannel()
	return IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY"
end

function module:InterruptAlert()
	if not NDuiDB["Misc"]["Interrupt"] then return end

	local function isAllyPet(sourceFlags)
		if sourceFlags == DB.MyPetFlags or (not NDuiDB["Misc"]["OwnInterrupt"] and (sourceFlags == DB.PartyPetFlags or sourceFlags == DB.RaidPetFlags)) then
			return true
		end
	end

	local infoType = {
		["SPELL_INTERRUPT"] = L["Interrupt"],
		["SPELL_STOLEN"] = L["Steal"],
		["SPELL_DISPEL"] = L["Dispel"],
		["SPELL_AURA_BROKEN_SPELL"] = L["BrokenSpell"],
	}

	local blackList = {
		[99] = true,		-- 夺魂咆哮
		[122] = true,		-- 冰霜新星
		[1776] = true,		-- 凿击
		[1784] = true,		-- 潜行
		[5246] = true,		-- 破胆怒吼
		[8122] = true,		-- 心灵尖啸
		[31661] = true,		-- 龙息术
		[33395] = true,		-- 冰冻术
		[64695] = true,		-- 陷地
		[82691] = true,		-- 冰霜之环
		[102359] = true,	-- 群体缠绕
		[105421] = true,	-- 盲目之光
		[115191] = true,	-- 潜行
		[157997] = true,	-- 寒冰新星
		[197214] = true,	-- 裂地术
		[198121] = true,	-- 冰霜撕咬
		[207167] = true,	-- 致盲冰雨
		[207685] = true,	-- 悲苦咒符
		[226943] = true,	-- 心灵炸弹
		[228600] = true,	-- 冰川尖刺
	}

	local function updateAlert(_, ...)
		if not NDuiDB["Misc"]["Interrupt"] then return end
		if not IsInGroup() then return end
		if NDuiDB["Misc"]["AlertInInstance"] and (not IsInInstance() or IsPartyLFG()) then return end

		local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, spellID, _, _, extraskillID, _, _, auraType = ...
		if not sourceGUID or sourceName == destName then return end

		if UnitInRaid(sourceName) or UnitInParty(sourceName) or isAllyPet(sourceFlags) then
			local infoText = infoType[eventType]
			if infoText then
				if infoText == L["BrokenSpell"] then
					if not NDuiDB["Misc"]["BrokenSpell"] then return end
					if auraType and auraType == AURA_TYPE_BUFF or blackList[spellID] then return end
					SendChatMessage(format(infoText, sourceName..GetSpellLink(extraskillID), destName..GetSpellLink(spellID)), msgChannel())
				else
					if NDuiDB["Misc"]["OwnInterrupt"] and sourceName ~= DB.MyName and not isAllyPet(sourceFlags) then return end
					SendChatMessage(format(infoText, sourceName..GetSpellLink(spellID), destName..GetSpellLink(extraskillID)), msgChannel())
				end
			end
		end
	end

	B:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", updateAlert)
end

--[[
	NDui版本过期提示
]]
function module:VersionCheck()
	local f = CreateFrame("Frame", nil, nil, "MicroButtonAlertTemplate")
	f:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 20, 70)
	f.Text:SetText("")
	f:Hide()

	local function CompareVersion(new, old)
		local new1, new2 = strsplit(".", new)
		new1, new2 = tonumber(new1), tonumber(new2)
		local old1, old2 = strsplit(".", old)
		old1, old2 = tonumber(old1), tonumber(old2)
		if new1 > old1 or new2 > old2 then
			return "IsNew"
		elseif new1 < old1 or new2 < old2 then
			return "IsOld"
		end
	end

	local checked = not NDuiADB["VersionCheck"]
	local function UpdateVersionCheck(_, ...)
		local prefix, msg, distType, author = ...
		if prefix ~= "NDuiVersionCheck" then return end
		if Ambiguate(author, "none") == DB.MyName then return end

		local status = CompareVersion(msg, NDuiADB["DetectVersion"])
		if status == "IsNew" then
			NDuiADB["DetectVersion"] = msg
		elseif status == "IsOld" then
			C_ChatInfo.SendAddonMessage("NDuiVersionCheck", NDuiADB["DetectVersion"], distType)
		end

		if not checked then
			if CompareVersion(NDuiADB["DetectVersion"], DB.Version) == "IsNew" then
				local release = gsub(NDuiADB["DetectVersion"], "(%d)$", "0")
				f.Text:SetText(format(L["Outdated NDui"], release))
				f:Show()
			end
			checked = true
		end
	end
	B:RegisterEvent("CHAT_MSG_ADDON", UpdateVersionCheck)

	C_ChatInfo.RegisterAddonMessagePrefix("NDuiVersionCheck")
	if IsInGuild() then
		C_ChatInfo.SendAddonMessage("NDuiVersionCheck", DB.Version, "GUILD")
	end

	local prevTime = 0
	local function SendGroupCheck()
		if not IsInGroup() or (GetTime()-prevTime < 30) then return end
		prevTime = GetTime()
		C_ChatInfo.SendAddonMessage("NDuiVersionCheck", DB.Version, msgChannel())
	end
	SendGroupCheck()
	B:RegisterEvent("GROUP_ROSTER_UPDATE", SendGroupCheck)
end

--[[
	大米完成时，通报打球统计
]]
function module:ExplosiveAlert()
	if not NDuiDB["Misc"]["ExplosiveCount"] then return end

	local eventList = {
		["SWING_DAMAGE"] = 13,
		["RANGE_DAMAGE"] = 16,
		["SPELL_DAMAGE"] = 16,
		["SPELL_PERIODIC_DAMAGE"] = 16,
		["SPELL_BUILDING_DAMAGE"] = 16,
	}

	local cache = NDuiDB["Misc"]["ExplosiveCache"]
	local function updateCount(_, ...)
		local _, eventType, _, _, sourceName, _, _, destGUID = ...
		local index = eventList[eventType]
		if index and B.GetNPCID(destGUID) == 120651 then
			local overkill = select(index, ...)
			if overkill and overkill > 0 then
				local name = strsplit("-", sourceName or UNKNOWN)
				if not cache[name] then cache[name] = 0 end
				cache[name] = cache[name] + 1
			end
		end
	end

	local function startCount()
		wipe(cache)
		B:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", updateCount)
	end

	local function endCount()
		local text
		for name, count in pairs(cache) do
			text = (text or L["ExplosiveCount"])..name.."("..count..") "
		end
		if text then SendChatMessage(text, "PARTY") end
		B:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", updateCount)
	end

	local function pauseCount()
		local name, _, instID = GetInstanceInfo()
		if name and instID == 8 then
			B:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", updateCount)
		else
			B:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", updateCount)
		end
	end

	local function checkAffixes(event)
		local affixes = C_MythicPlus.GetCurrentAffixes()
		if not affixes then return end
		if affixes[3] and affixes[3].id == 13 then
			B:RegisterEvent("CHALLENGE_MODE_START", startCount)
			B:RegisterEvent("CHALLENGE_MODE_COMPLETED", endCount)
			B:RegisterEvent(event, pauseCount)
		end
		B:UnregisterEvent(event, checkAffixes)
	end
	B:RegisterEvent("PLAYER_ENTERING_WORLD", checkAffixes)
end

--[[
	放大餐时叫一叫
]]
function module:PlacedItemAlert()
	local GetTime = GetTime
	local itemList = {
		[226241] = true,	-- 宁神圣典
		[256230] = true,	-- 静心圣典
		[185709] = true,	-- 焦糖鱼宴
		[259409] = true,	-- 海帆盛宴
		[259410] = true,	-- 船长盛宴
		[276972] = true,	-- 秘法药锅
		[286050] = true,	-- 鲜血大餐
		[265116] = true,	-- 工程战复
	}

	local lastTime = 0
	local function checkSpell(_, unit, _, spellID)
		if not NDuiDB["Misc"]["PlacedItemAlert"] then return end
		if (UnitInRaid(unit) or UnitInParty(unit)) and spellID and itemList[spellID] and lastTime ~= GetTime() then
			local who = UnitName(unit)
			local link = GetSpellLink(spellID)
			local name = GetSpellInfo(spellID)
			SendChatMessage(format(L["Place item"], who, link or name), msgChannel())
			lastTime = GetTime()
		end
	end
	B:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", checkSpell)
end

-- 乌纳特踩圈通报
function module:UunatAlert()
	local data = {}
	local function isBuffBlock()
		for i = 1, 16 do
			local name, _, _, _, _, _, _, _, _, spellID = UnitDebuff("player", i)
			if not name then break end
			if name and spellID == 284733 then
				return true
			end
		end
	end

	B:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", function(_, ...)
		if not NDuiDB["Misc"]["UunatAlert"] then return end
		local _, eventType, _, _, _, _, _, _, destName, _, _, spellID = ...
		if eventType == "SPELL_DAMAGE" and spellID == 285214 and not isBuffBlock() then
			data[destName] = (data[destName] or 0) + 1
			SendChatMessage(format(L["UunatAlertString"], destName, data[destName]), msgChannel())
		end
	end)

	B:RegisterEvent("ENCOUNTER_END", function()
		wipe(data)
	end)
end