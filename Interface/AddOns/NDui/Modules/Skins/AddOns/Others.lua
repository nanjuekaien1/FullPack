local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local _G = _G
local strfind = strfind

function S:FriendGroups()
	if not IsAddOnLoaded("FriendGroups") then return end

	if FriendGroups_UpdateFriendButton then
		local function replaceButtonStatus(self, texture)
			self:SetPoint("TOPLEFT", 4, 1)
			self.bg:Show()
			if strfind(texture, "PlusButton") then
				self:SetAtlas("Soulbinds_Collection_CategoryHeader_Collapse", true)
			elseif strfind(texture, "MinusButton") then
				self:SetAtlas("Soulbinds_Collection_CategoryHeader_Expand", true)
			else
				self:SetPoint("TOPLEFT", 4, -3)
				self.bg:Hide()
			end
		end

		hooksecurefunc("FriendGroups_UpdateFriendButton", function(button)
			if not button.styled then
				local bg = B.CreateBDFrame(button.status, .25)
				bg:SetInside(button.status, 3, 3)
				button.status.bg = bg
				hooksecurefunc(button.status, "SetTexture", replaceButtonStatus)

				button.styled = true
			end
		end)
	end
end

function S:PostalSkin()
	if not IsAddOnLoaded("Postal") then return end
	if not PostalOpenAllButton then return end -- outdate postal

	B.Reskin(PostalSelectOpenButton)
	B.Reskin(PostalSelectReturnButton)
	B.Reskin(PostalOpenAllButton)
	B.ReskinArrow(Postal_ModuleMenuButton, "down")
	B.ReskinArrow(Postal_OpenAllMenuButton, "down")
	B.ReskinArrow(Postal_BlackBookButton, "down")
	for i = 1, 7 do
		B.ReskinCheck(_G["PostalInboxCB"..i])
	end

	Postal_ModuleMenuButton:ClearAllPoints()
	Postal_ModuleMenuButton:SetPoint("RIGHT", MailFrame.CloseButton, "LEFT", -2, 0)
	Postal_OpenAllMenuButton:SetPoint("LEFT", PostalOpenAllButton, "RIGHT", 2, 0)
	Postal_BlackBookButton:SetPoint("LEFT", SendMailNameEditBox, "RIGHT", 2, 0)
end

function S:SoulbindsTalents()
	if not IsAddOnLoaded("SoulbindsTalents") then return end

	hooksecurefunc("PanelTemplates_SetNumTabs", function(frame, num)
		if frame == _G.PlayerTalentFrame and num == 4 then
			if _G.PlayerTalentFrameTab4 then
				B.ReskinTab(_G.PlayerTalentFrameTab4)
			end
		elseif frame == _G.SoulbindAnchor then
			for i = 1, 4 do
				local tab = _G["SoulbindViewerTab"..i]
				if tab then
					B.ReskinTab(tab)
				end
			end
		end
	end)
end

local function restyleMRTWidget(self)
	local iconTexture = self.iconTexture
	local bar = self.statusbar

	if not self.styled then
		B.SetBD(iconTexture)
		self.__bg = B.SetBD(bar)
		self.background:SetAllPoints(bar)

		self.styled = true
	end
	iconTexture:SetTexCoord(unpack(DB.TexCoord))

	local parent = self.parent
	if parent.optionIconPosition == 3 or parent.optionIconTitles then
		-- do nothing
	elseif parent.optionIconPosition == 2 then
		self.icon:SetPoint("RIGHT", self, 3, 0)
	else
		self.icon:SetPoint("LEFT", self, -3, 0)
	end
	self.__bg:SetShown(parent.optionAlphaTimeLine ~= 0)
end

local MRTLoaded
local function LoadMRTSkin()
	if MRTLoaded then return end
	MRTLoaded = true

	local name = "MRTRaidCooldownCol"
	for i = 1, 10 do
		local column = _G[name..i]
		local lines = column and column.lines
		if lines then
			for j = 1, #lines do
				local line = lines[j]
				if line.UpdateStyle then
					hooksecurefunc(line, "UpdateStyle", restyleMRTWidget)
					line:UpdateStyle()
				end
			end
		end
	end
end

function S:MRT_Skin()
	if not IsAddOnLoaded("MRT") then return end

	local isEnabled = VMRT and VMRT.ExCD2 and VMRT.ExCD2.enabled
	if isEnabled then
		LoadMRTSkin()
	else
		hooksecurefunc(MRTOptionsFrameExCD2, "Load", function(self)
			if self.chkEnable then
				self.chkEnable:HookScript("OnClick", LoadMRTSkin)
			end
		end)
	end
end

function S:OtherSkins()
	if not C.db["Skins"]["BlizzardSkins"] then return end

	S:FriendGroups()
	S:PostalSkin()
	S:SoulbindsTalents()
	S:MRT_Skin()
end