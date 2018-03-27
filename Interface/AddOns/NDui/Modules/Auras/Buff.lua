local B, C, L, DB = unpack(select(2, ...))
local module = NDui:RegisterModule("Auras")

local BuffFrame = BuffFrame
local IconsPerRow, IconSize, margin, offset = C.Auras.IconsPerRow, C.Auras.IconSize - 2, C.Auras.Spacing, 12
local BuffAnchor

function module:OnLogin()
	BuffAnchor = CreateFrame("Frame", "NDuiBuffFrame", UIParent)
	BuffAnchor:SetSize(IconSize, IconSize)
	BuffAnchor.mover = B.Mover(BuffAnchor, "Buffs/Debuffs", "BuffAnchor", C.Auras.BuffPos, (IconSize + margin)*IconsPerRow, (IconSize + offset)*3)
	BuffAnchor:ClearAllPoints()
	BuffAnchor:SetPoint("TOPRIGHT", BuffAnchor.mover)

	TempEnchant1:ClearAllPoints()
	TempEnchant1:SetPoint("TOPRIGHT", BuffAnchor)
	TempEnchant2:ClearAllPoints()
	TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -margin, 0)
	TempEnchant3:ClearAllPoints()
	TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -margin, 0)
	TempEnchant3:Hide()
	BuffFrame.ignoreFramePositionManager = true
end

local function styleButton(bu, isDebuff)
	if not bu or bu.styled then return end
	local name = bu:GetName()

	local iconSize, fontSize = IconSize, DB.Font[2]
	if isDebuff then iconSize, fontSize = IconSize + 5, DB.Font[2] + 2 end

	local border = _G[name.."Border"]
	if border then border:Hide() end

	local icon = _G[name.."Icon"]
	icon:SetAllPoints()
	icon:SetTexCoord(unpack(DB.TexCoord))
	icon:SetDrawLayer("BACKGROUND", 1)

	local duration = _G[name.."Duration"]
	duration:ClearAllPoints()
	duration:SetPoint("TOP", bu, "BOTTOM", 2, 2)
	duration:SetFont(DB.Font[1], fontSize, DB.Font[3])

	local count = _G[name.."Count"]
	count:ClearAllPoints()
	count:SetParent(bu)
	count:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -1, -3)
	count:SetFont(DB.Font[1], fontSize, DB.Font[3])

	bu:SetSize(iconSize, iconSize)
	bu.HL = bu:CreateTexture(nil, "HIGHLIGHT")
	bu.HL:SetColorTexture(1, 1, 1, .3)
	bu.HL:SetAllPoints(icon)
	B.CreateSD(bu, 3, 3)

	bu.styled = true
end

local function ReskinBuffs()
	local buff, previousBuff, aboveBuff, index
	local numBuffs = 0
	local slack = BuffFrame.numEnchants

	for i = 1, BUFF_ACTUAL_DISPLAY do
		buff = _G["BuffButton"..i]
		styleButton(buff)

		numBuffs = numBuffs + 1
		index = numBuffs + slack
		buff:ClearAllPoints()
		if index > 1 and mod(index, IconsPerRow) == 1 then
			if index == IconsPerRow + 1 then
				buff:SetPoint("TOP", BuffAnchor, "BOTTOM", 0, -offset)
			else
				buff:SetPoint("TOP", aboveBuff, "BOTTOM", 0, -offset)
			end
			aboveBuff = buff
		elseif numBuffs == 1 and slack == 0 then
			buff:SetPoint("TOPRIGHT", BuffAnchor)
		elseif numBuffs == 1 and slack > 0 then
			buff:SetPoint("TOPRIGHT", _G["TempEnchant"..slack], "TOPLEFT", -margin, 0)
		else
			buff:SetPoint("RIGHT", previousBuff, "LEFT", -margin, 0)
		end
		previousBuff = buff
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", ReskinBuffs)

local function ReskinTempEnchant()
	for i = 1, NUM_TEMP_ENCHANT_FRAMES do
		local bu = _G["TempEnchant"..i]
		styleButton(bu)
	end
end
hooksecurefunc("TemporaryEnchantFrame_Update", ReskinTempEnchant)

local function ReskinDebuffs(buttonName, i)
	local debuff = _G[buttonName..i]
	local previous = _G[buttonName..(i-1)]
	styleButton(debuff, true)

	debuff:ClearAllPoints()
	if i == 1 then
		debuff:SetPoint("TOPRIGHT", BuffAnchor.mover, "BOTTOMRIGHT", 0, -offset)
	elseif i == IconsPerRow + 1 then
		debuff:SetPoint("TOP", _G[buttonName.."1"], "BOTTOM", 0, -offset)
	elseif i < IconsPerRow*2 + 1 then
		debuff:SetPoint("RIGHT", previous, "LEFT", -margin, 0)
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", ReskinDebuffs)

local function updateDebuffBorder(buttonName, index, filter)
	local unit = PlayerFrame.unit
	local name, _, _, _, debuffType = UnitAura(unit, index, filter)
	if not name then return end
	local bu = _G[buttonName..index]
	if not (bu and bu.Shadow) then return end

	if filter == "HARMFUL" then
		local color = DebuffTypeColor[debuffType or "none"]
		bu.Shadow:SetBackdropBorderColor(color.r, color.g, color.b)
	end
end
hooksecurefunc("AuraButton_Update", updateDebuffBorder)

local function FlashOnEnd(self)
	if self.timeLeft < 10 then
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", FlashOnEnd)