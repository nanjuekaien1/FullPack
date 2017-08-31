local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Misc")

--[[
	SoloInfo是一个告知你当前副本难度的小工具，防止我有时候单刷时进错难度了。
	instList左侧是副本ID，你可以使用"/getid"命令来获取当前副本的ID；右侧的是副本难度，常用的一般是：2为5H，4为25普通，6为25H。
]]
function module:SoloInfo()
	if not NDuiDB["Misc"]["SoloInfo"] then return end

	local instList = {
		[556] = 2,		-- 塞塔克大厅，乌鸦
		[575] = 2,		-- 乌特加德之巅，蓝龙
		[585] = 2,		-- 魔导师平台，白鸡
		[603] = 4,		-- 奥杜尔，飞机头
		[631] = 6,		-- 冰冠堡垒，无敌
	}

	local f = NDui:EventFrame({"ZONE_CHANGED_NEW_AREA", "PLAYER_DIFFICULTY_CHANGED", "PLAYER_ENTERING_WORLD"})
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
	f:SetSize(150, 70)
	f:Hide()
	B.CreateBD(f)
	B.CreateTex(f)
	f.Text = B.CreateFS(f, 12, "")
	f.Text:SetWordWrap(true)

	f:SetScript("OnEvent", function()
		local name, _, instType, diffname, _, _, _, id = GetInstanceInfo()
		if IsInInstance() and instType ~= 24 then
			if instList[id] and instList[id] ~= instType then
				f:Show()
				f.Text:SetText(DB.InfoColor..name..DB.MyColor.."\n( "..diffname.." )\n\n"..DB.InfoColor..L["Wrong Difficulty"])
			else
				f:Hide()
			end
		else
			f:Hide()
		end
	end)
	f:SetScript("OnMouseUp", function() f:Hide() end)
end

--[[
	发现稀有/事件时的通报插件
]]
function module:RareAlert()
	if not NDuiDB["Misc"]["RareAlerter"] then return end

	local cache = {}
	NDui:EventFrame("VIGNETTE_ADDED"):SetScript("OnEvent", function(_, _, id)
		if id and not cache[id] then
			local _, _, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
			local left, right, top, bottom = GetObjectIconTextureCoords(icon)
			local tex = "|TInterface\\Minimap\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Rare Found"]..tex..(name or ""))
			if NDuiDB["Misc"]["AlertinChat"] then
				print("  -> "..DB.InfoColor..L["Rare Found"]..tex..(name or ""))
			end
			PlaySoundFile("Sound\\Interface\\PVPFlagTakenMono.ogg", "master")
			cache[id] = true
		end
	end)
end

--[[
	闭上你的嘴！
	打断/偷取法术时的警报。
]]
function module:InterruptAlert()
	if not NDuiDB["Misc"]["Interrupt"] then return end

	NDui:EventFrame("COMBAT_LOG_EVENT_UNFILTERED"):SetScript("OnEvent", function(_, _, ...)
		if not IsInGroup() then return end
		local _, eventType, _, _, sourceName, _, _, _, destName, _, _, spellID, _, _, extraskillID = ...
		if UnitInRaid(sourceName) or UnitInParty(sourceName) then
			if NDuiDB["Misc"]["OwnInterrupt"] and sourceName ~= UnitName("player") then return end

			local function SendChatMsg(infoText)
				SendChatMessage(format(infoText, sourceName..GetSpellLink(spellID), destName..GetSpellLink(extraskillID)), IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
			end
			if eventType == "SPELL_INTERRUPT" then
				SendChatMsg(L["Interrupt"])
			elseif eventType == "SPELL_STOLEN" then
				SendChatMsg(L["Steal"])
			end
		end
	end)
end

--[[
	向左走向右走
	克洛苏斯给没脑子的助手
]]
function module:BeamTool()
	local f
	local function KrosusGo()
		if f then f:Show() return end
		f = CreateFrame("Frame", "NDui_BeamTool", UIParent)
		f:SetSize(100, 100)
		f:SetPoint("BOTTOMRIGHT", -350, 50)
		B.CreateBD(f)
		B.CreateTex(f)
		B.CreateMF(f)
		B.CreateFS(f, 14, "First Beam:", false, "TOP", 0, -5)
		f.text = B.CreateFS(f, 20, "", false, "TOP", 0, -25)

		local close = CreateFrame("Button", nil, f)
		close:SetPoint("BOTTOM")
		close:SetSize(20, 20)
		B.CreateFS(close, 14, "X")
		B.CreateGT(close, "ANCHOR_TOP", CLOSE, "system")
		close:SetScript("OnClick", function()
			f:Hide()
			f.text:SetText("")
		end)

		local function CreateBu(anchor, text)
			local bu = B.CreateButton(f, 40, 40, text, 20)
			bu:SetPoint(anchor)
			bu:SetScript("OnClick", function()
				f.text:SetText(text)
				if text == "左" then
					if DBMUpdateKrosusBeam then DBMUpdateKrosusBeam(true) end
					if BigWigsKrosusFirstBeamWasLeft then BigWigsKrosusFirstBeamWasLeft(true) end
					print("First beam on LEFT")
				else
					if DBMUpdateKrosusBeam then DBMUpdateKrosusBeam(false) end
					if BigWigsKrosusFirstBeamWasLeft then BigWigsKrosusFirstBeamWasLeft(false) end
					print("First beam on RIGHT")
				end
			end)
		end
		CreateBu("BOTTOMLEFT", "左")
		CreateBu("BOTTOMRIGHT", "右")
	end

	SlashCmdList["NDUI_BEAMTOOL"] = function() KrosusGo() end
	SLASH_NDUI_BEAMTOOL1 = "/kro"
end

--[[
	骂那些用反光棱镜的臭傻逼
]]
function module:ReflectingAlert()
	if not NDuiDB["Misc"]["ReflectingAlert"] then return end

	NDui:EventFrame("UNIT_SPELLCAST_SUCCEEDED"):SetScript("OnEvent", function(_, _, ...)
		if not IsInGroup() then return end
		local unit, spellName, _, _, spell = ...
		if spell ~= 163219 then return end
		if UnitInRaid(unit) or UnitInParty(unit) then
			local unitName = GetUnitName(unit)
			local name, itemLink = GetItemInfo(112384)
			SendChatMessage(format(L["Reflecting Prism"], unitName, itemLink or name), IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
		end
	end)
end

--[[
	工程移形换影装置使用通报
]]
function module:SwapingAlert()
	if not NDuiDB["Misc"]["SwapingAlert"] then return end

	NDui:EventFrame("COMBAT_LOG_EVENT_UNFILTERED"):SetScript("OnEvent", function(_, _, ...)
		if not IsInGroup() then return end
		local _, eventType, _, _, sourceName, _, _, _, destName, _, _, spellID, _, _, extraskillID = ...
		if eventType ~= "SPELL_CAST_SUCCESS" or spellID ~= 161399 then return end
		if UnitInRaid(sourceName) or UnitInParty(sourceName) then
			local name, itemLink = GetItemInfo(111820)
			SendChatMessage(format(L["Swapblaster"], sourceName, destName, itemLink or name), IsPartyLFG() and "INSTANCE_CHAT" or IsInRaid() and "RAID" or "PARTY")
		end
	end)
end

--[[
	NDui版本过期提示
]]
function module:VersionCheck()
	if not NDuiDB["Settings"]["VersionCheck"] then return end
	if not NDuiADB["DetectVersion"] then NDuiADB["DetectVersion"] = DB.Version end
	if not IsInGuild() then return end

	NDui:EventFrame("CHAT_MSG_ADDON"):SetScript("OnEvent", function(self, event, ...)
		local prefix, msg, distType, sender = ...
		if distType ~= "GUILD" then return end

		if prefix == "NDuiVersionCheck" then
			local a1, a2, a3 = string.split(".", msg)
			local c1, c2, c3 = string.split(".", NDuiADB["DetectVersion"])
			if a1 > c1 or a2 > c2 or a3 > c3 then
				NDuiADB["DetectVersion"] = msg
			end

			if not self.checked then
				local b1, b2, b3 = string.split(".", DB.Version)
				if c1 > b1 or c2 > b2 then
					print(format(L["Outdated NDui"], NDuiADB["DetectVersion"]))
				elseif c1 < b1 or c2 < b2 then
					SendAddonMessage("NDuiVersionCheck", DB.Version, "GUILD")
				end
				self.checked = true
			end
		end
	end)
	RegisterAddonMessagePrefix("NDuiVersionCheck")
	SendAddonMessage("NDuiVersionCheck", DB.Version, "GUILD")
end

--[[
	通报M月之姐妹的星界易伤情况
]]
function module:SistersAlert()
	if not NDuiDB["Misc"]["SistersAlert"] then return end

	local data = {}
	local tarSpell = 236330
	local myID = UnitGUID("player")

	NDui:EventFrame("COMBAT_LOG_EVENT_UNFILTERED"):SetScript("OnEvent", function(_, _, ...)
		if not UnitIsGroupAssistant("player") and not UnitIsGroupLeader("player") then return end

		local _, eventType, _, _, sourceName, _, _, destGUID, _, _, _, spellID = ...
		if eventType == "SPELL_DAMAGE" and spellID == 234998 and destGUID == myID then
			local name, _, _, count = UnitDebuff("player", GetSpellInfo(tarSpell))
			if not name then return end
			if not data[sourceName] then data[sourceName] = {} end
			if count == 0 then count = 1 end
			tinsert(data[sourceName], count)
		elseif eventType == "SPELL_AURA_REMOVED" and spellID == tarSpell and destGUID == myID then
			SendChatMessage("------------", "RAID")
			for player, value in pairs(data) do
				SendChatMessage(player..": "..table.concat(value, ", "), "RAID")
			end
			data = {}
		end
	end)
end