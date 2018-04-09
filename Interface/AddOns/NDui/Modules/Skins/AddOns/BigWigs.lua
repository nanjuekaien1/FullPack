local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Skins")

local f = NDui:EventFrame{"PLAYER_ENTERING_WORLD", "ADDON_LOADED"}
f:SetScript("OnEvent", function(self, event, addon)
	if not NDuiDB["Skins"]["Bigwigs"] or not IsAddOnLoaded("BigWigs") then
		self:UnregisterAllEvents()
		return
	end

	if event == "PLAYER_ENTERING_WORLD" then
		-- Force Settings
		if not BigWigs3DB then return end
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["font"] = DB.Font[1]
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["fontSize"] = DB.Font[2]
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["outline"] = DB.Font[3]
		BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["barStyle"] = "NDui"

		self:UnregisterEvent(event)
	elseif event == "ADDON_LOADED" and addon == "BigWigs_Plugins" then
		local bars = BigWigs:GetPlugin("Bars", true)

		local function removeStyle(bar)
			bar.candyBarBackdrop:Hide()
			local height = bar:Get("bigwigs:restoreheight")
			if height then
				bar:SetHeight(height)
			end

			local tex = bar:Get("bigwigs:restoreicon")
			if tex then
				bar:SetIcon(tex)
				bar:Set("bigwigs:restoreicon", nil)
				bar.candyBarIconFrameBackdrop:Hide()
			end

			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
			bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
			bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
		end

		local function styleBar(bar)
			local height = bar:GetHeight()
			bar:Set("bigwigs:restoreheight", height)
			bar:SetHeight(height/2)
			bar:SetTexture(DB.normTex)

			local bd = bar.candyBarBackdrop
			B.CreateBD(bd)
			B.CreateTex(bd)
			bd:ClearAllPoints()
			bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -3, 3)
			bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 3, -3)
			bd:Show()

			local tex = bar:GetIcon()
			if tex then
				local icon = bar.candyBarIconFrame
				bar:SetIcon(nil)
				icon:SetTexture(tex)
				icon:Show()
				if bar.iconPosition == "RIGHT" then
					icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
				else
					icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
				end
				icon:SetSize(height, height)
				bar:Set("bigwigs:restoreicon", tex)

				local iconBd = bar.candyBarIconFrameBackdrop
				B.CreateBD(iconBd)
				iconBd:ClearAllPoints()
				iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -3, 3)
				iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3)
				iconBd:Show()
			end

			bar.candyBarLabel:ClearAllPoints()
			bar.candyBarLabel:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
			bar.candyBarLabel:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)
			bar.candyBarDuration:ClearAllPoints()
			bar.candyBarDuration:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)
			bar.candyBarDuration:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
		end

		bars:RegisterBarStyle("NDui", {
			apiVersion = 1,
			version = 2,
			GetSpacing = function(bar) return bar:GetHeight()+5 end,
			ApplyStyle = styleBar,
			BarStopped = removeStyle,
			GetStyleName = function() return "NDui" end,
		})

		self:UnregisterEvent(event)
	end
end)