local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_AuctionHouseUI"] = function()
	local function reskinAuctionButton(button)
		B.Reskin(button)
		button:SetSize(22,22)
	end

	local function reskinSellPanel(frame)
		B.StripTextures(frame)

		local itemDisplay = frame.ItemDisplay
		B.StripTextures(itemDisplay)
		B.CreateBDFrame(itemDisplay, .25)

		local itemButton = itemDisplay.ItemButton
		if itemButton.IconMask then itemButton.IconMask:Hide() end
		if itemButton.IconBorder then itemButton.IconBorder:SetAlpha(0) end
		itemButton.EmptyBackground:Hide()
		itemButton:SetPushedTexture("")
		itemButton.Highlight:SetColorTexture(1, 1, 1, .25)
		itemButton.Highlight:SetAllPoints(itemButton.Icon)
		local bg = B.ReskinIcon(itemButton.Icon)
		hooksecurefunc(itemButton.IconBorder, "SetVertexColor", function(_, r, g, b) bg:SetBackdropBorderColor(r, g, b) end)
		hooksecurefunc(itemButton.IconBorder, "Hide", function() bg:SetBackdropBorderColor(0, 0, 0) end)

		B.ReskinInput(frame.QuantityInput.InputBox)
		B.Reskin(frame.QuantityInput.MaxButton)
		B.ReskinInput(frame.PriceInput.MoneyInputFrame.GoldBox)
		B.ReskinInput(frame.PriceInput.MoneyInputFrame.SilverBox)
		if frame.SecondaryPriceInput then
			B.ReskinInput(frame.SecondaryPriceInput.MoneyInputFrame.GoldBox)
			B.ReskinInput(frame.SecondaryPriceInput.MoneyInputFrame.SilverBox)
		end
		B.ReskinDropDown(frame.DurationDropDown.DropDown)
		B.Reskin(frame.PostButton)
		if frame.BuyoutModeCheckButton then B.ReskinCheck(frame.BuyoutModeCheckButton) end
	end

	local function reskinListIcon(frame)
		if not frame.tableBuilder then return end

		for i = 1, 22 do
			local row = frame.tableBuilder.rows[i]
			if row then
				for j = 1, 4 do
					local cell = row.cells and row.cells[j]
					if cell and cell.Icon then
						if not cell.styled then
							cell.Icon.bg = B.ReskinIcon(cell.Icon)
							if cell.IconBorder then cell.IconBorder:Hide() end
							cell.styled = true
						end
						cell.Icon.bg:SetShown(cell.Icon:IsShown())
					end
				end
			end
		end
	end

	local function reskinSummaryIcon(frame)
		for i = 1, 23 do
			local child = select(i, frame.ScrollFrame.scrollChild:GetChildren())
			if child and child.Icon then
				if not child.styled then
					child.Icon.bg = B.ReskinIcon(child.Icon)
					child.styled = true
				end
				child.Icon.bg:SetShown(child.Icon:IsShown())
			end
		end
	end

	local function reskinListHeader(frame)
		local maxHeaders = frame.HeaderContainer:GetNumChildren()
		for i = 1, maxHeaders do
			local header = select(i, frame.HeaderContainer:GetChildren())
			if header and not header.styled then
				header:DisableDrawLayer("BACKGROUND")
				header.bg = B.CreateBDFrame(header)
				local hl = header:GetHighlightTexture()
				hl:SetColorTexture(1, 1, 1, .1)
				hl:SetAllPoints(header.bg)

				header.styled = true
			end

			if header.bg then
				header.bg:SetPoint("BOTTOMRIGHT", i < maxHeaders and -5 or 0, -2)
			end
		end

		reskinListIcon(frame)
	end

	local function reskinSellList(frame, hasHeader)
		B.StripTextures(frame)
		if frame.RefreshFrame then
			reskinAuctionButton(frame.RefreshFrame.RefreshButton)
		end
		B.ReskinScroll(frame.ScrollFrame.scrollBar)
		if hasHeader then
			B.CreateBDFrame(frame.ScrollFrame, .25)
			hooksecurefunc(frame, "RefreshScrollFrame", reskinListHeader)
		else
			hooksecurefunc(frame, "RefreshScrollFrame", reskinSummaryIcon)
		end
	end

	local function reskinItemDisplay(frame)
		local itemDisplay = frame.ItemDisplay
		B.StripTextures(itemDisplay)
		local bg = B.CreateBDFrame(itemDisplay, .25)
		bg:SetPoint("TOPLEFT", 3, -3)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)
		local itemButton = itemDisplay.ItemButton
		itemButton.CircleMask:Hide()
		itemButton.IconBorder:SetAlpha(0)
		B.ReskinIcon(itemButton.Icon)
	end

	B.ReskinPortraitFrame(AuctionHouseFrame)
	B.StripTextures(AuctionHouseFrame.MoneyFrameBorder)
	B.CreateBDFrame(AuctionHouseFrame.MoneyFrameBorder, .25)
	B.StripTextures(AuctionHouseFrame.MoneyFrameInset)
	B.ReskinTab(AuctionHouseFrameBuyTab)
	AuctionHouseFrameBuyTab:SetPoint("BOTTOMLEFT", 20, -31)
	B.ReskinTab(AuctionHouseFrameSellTab)
	B.ReskinTab(AuctionHouseFrameAuctionsTab)

	local searchBar = AuctionHouseFrame.SearchBar
	reskinAuctionButton(searchBar.FavoritesSearchButton)
	B.ReskinInput(searchBar.SearchBox)
	B.ReskinFilterButton(searchBar.FilterButton)
	B.Reskin(searchBar.SearchButton)
	B.ReskinInput(searchBar.FilterButton.LevelRangeFrame.MinLevel)
	B.ReskinInput(searchBar.FilterButton.LevelRangeFrame.MaxLevel)

	B.StripTextures(AuctionHouseFrame.CategoriesList)
	B.ReskinScroll(AuctionHouseFrame.CategoriesList.ScrollFrame.ScrollBar)

	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.SelectedTexture:SetColorTexture(0, .6, 1, .3)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .1)
	end)
	
	local itemList = AuctionHouseFrame.BrowseResultsFrame.ItemList
	B.StripTextures(itemList, 3)
	B.CreateBDFrame(itemList.ScrollFrame, .25)
	B.ReskinScroll(itemList.ScrollFrame.scrollBar)
	hooksecurefunc(itemList, "RefreshScrollFrame", reskinListHeader)

	local itemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	B.Reskin(itemBuyFrame.BackButton)
	B.Reskin(itemBuyFrame.BidFrame.BidButton)
	B.Reskin(itemBuyFrame.BuyoutFrame.BuyoutButton)
	B.ReskinInput(AuctionHouseFrameGold)
	B.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(itemBuyFrame)
	local itemList = itemBuyFrame.ItemList
	B.StripTextures(itemList)
	reskinAuctionButton(itemList.RefreshFrame.RefreshButton)
	B.CreateBDFrame(itemList.ScrollFrame, .25)
	B.ReskinScroll(itemList.ScrollFrame.scrollBar)
	hooksecurefunc(itemList, "RefreshScrollFrame", reskinListHeader)

	local commBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	B.Reskin(commBuyFrame.BackButton)
	local buyDisplay = commBuyFrame.BuyDisplay
	B.StripTextures(buyDisplay)
	B.ReskinInput(buyDisplay.QuantityInput.InputBox)
	B.Reskin(buyDisplay.BuyButton)
	reskinItemDisplay(buyDisplay)
	local itemList = commBuyFrame.ItemList
	B.StripTextures(itemList)
	B.CreateBDFrame(itemList, .25)
	reskinAuctionButton(itemList.RefreshFrame.RefreshButton)
	B.ReskinScroll(itemList.ScrollFrame.scrollBar)

	local wowTokenResults = AuctionHouseFrame.WoWTokenResults
	B.StripTextures(wowTokenResults)
	B.StripTextures(wowTokenResults.TokenDisplay)
	B.CreateBDFrame(wowTokenResults.TokenDisplay, .25)
	B.Reskin(wowTokenResults.Buyout)
	B.ReskinScroll(wowTokenResults.DummyScrollBar)

	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinItemDisplay(AuctionHouseFrameAuctionsFrame)

	B.ReskinTab(AuctionHouseFrameAuctionsFrameAuctionsTab)
	B.ReskinTab(AuctionHouseFrameAuctionsFrameBidsTab)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameGold)
	B.ReskinInput(AuctionHouseFrameAuctionsFrameSilver)
	B.Reskin(AuctionHouseFrameAuctionsFrame.CancelAuctionButton)
	B.Reskin(AuctionHouseFrameAuctionsFrame.BidFrame.BidButton)
	B.Reskin(AuctionHouseFrameAuctionsFrame.BuyoutFrame.BuyoutButton)

	local buyDialog = AuctionHouseFrame.BuyDialog
	B.StripTextures(buyDialog)
	B.SetBD(buyDialog)
	B.Reskin(buyDialog.BuyNowButton)
	B.Reskin(buyDialog.CancelButton)
end

C.themes["Blizzard_AuctionUI"] = function()
	local r, g, b = DB.r, DB.g, DB.b

	B.SetBD(AuctionFrame, 2, -10, 0, 10)
	B.CreateBD(AuctionProgressFrame)
	B.CreateSD(AuctionProgressFrame)

	AuctionProgressBar:SetStatusBarTexture(DB.bdTex)
	B.CreateBDFrame(AuctionProgressBar, .25)
	B.ReskinIcon(AuctionProgressBar.Icon)

	AuctionProgressBar.Text:ClearAllPoints()
	AuctionProgressBar.Text:SetPoint("CENTER", 0, 1)
	B.ReskinClose(AuctionProgressFrameCancelButton, "LEFT", AuctionProgressBar, "RIGHT", 4, 0)
	select(14, AuctionProgressFrameCancelButton:GetRegions()):SetPoint("CENTER", 0, 2)

	AuctionFrame:DisableDrawLayer("ARTWORK")
	AuctionPortraitTexture:Hide()
	for i = 1, 4 do
		select(i, AuctionProgressFrame:GetRegions()):Hide()
	end
	AuctionProgressBar.Border:Hide()
	BrowseFilterScrollFrame:GetRegions():Hide()
	select(2, BrowseFilterScrollFrame:GetRegions()):Hide()
	BrowseScrollFrame:GetRegions():Hide()
	select(2, BrowseScrollFrame:GetRegions()):Hide()
	BidScrollFrame:GetRegions():Hide()
	select(2, BidScrollFrame:GetRegions()):Hide()
	AuctionsScrollFrame:GetRegions():Hide()
	select(2, AuctionsScrollFrame:GetRegions()):Hide()
	BrowseQualitySort:DisableDrawLayer("BACKGROUND")
	BrowseLevelSort:DisableDrawLayer("BACKGROUND")
	BrowseDurationSort:DisableDrawLayer("BACKGROUND")
	BrowseHighBidderSort:DisableDrawLayer("BACKGROUND")
	BrowseCurrentBidSort:DisableDrawLayer("BACKGROUND")
	BidQualitySort:DisableDrawLayer("BACKGROUND")
	BidLevelSort:DisableDrawLayer("BACKGROUND")
	BidDurationSort:DisableDrawLayer("BACKGROUND")
	BidBuyoutSort:DisableDrawLayer("BACKGROUND")
	BidStatusSort:DisableDrawLayer("BACKGROUND")
	BidBidSort:DisableDrawLayer("BACKGROUND")
	AuctionsQualitySort:DisableDrawLayer("BACKGROUND")
	AuctionsDurationSort:DisableDrawLayer("BACKGROUND")
	AuctionsHighBidderSort:DisableDrawLayer("BACKGROUND")
	AuctionsBidSort:DisableDrawLayer("BACKGROUND")
	select(6, BrowseCloseButton:GetRegions()):Hide()
	select(6, BrowseBuyoutButton:GetRegions()):Hide()
	select(6, BrowseBidButton:GetRegions()):Hide()
	select(6, BidCloseButton:GetRegions()):Hide()
	select(6, BidBuyoutButton:GetRegions()):Hide()
	select(6, BidBidButton:GetRegions()):Hide()

	hooksecurefunc("FilterButton_SetUp", function(button)
		button:SetNormalTexture("")
	end)

	local lastSkinnedTab = 1
	AuctionFrame:HookScript("OnShow", function()
		local tab = _G["AuctionFrameTab"..lastSkinnedTab]

		while tab do
			B.ReskinTab(tab)
			lastSkinnedTab = lastSkinnedTab + 1
			tab = _G["AuctionFrameTab"..lastSkinnedTab]
		end
	end)

	local abuttons = {"BrowseBidButton", "BrowseBuyoutButton", "BrowseCloseButton", "BrowseSearchButton", "BrowseResetButton", "BidBidButton", "BidBuyoutButton", "BidCloseButton", "AuctionsCloseButton", "AuctionsCancelAuctionButton", "AuctionsCreateAuctionButton", "AuctionsNumStacksMaxButton", "AuctionsStackSizeMaxButton"}
	for i = 1, #abuttons do
		B.Reskin(_G[abuttons[i]])
	end

	BrowseCloseButton:ClearAllPoints()
	BrowseCloseButton:SetPoint("BOTTOMRIGHT", AuctionFrameBrowse, "BOTTOMRIGHT", 66, 13)
	BrowseBuyoutButton:ClearAllPoints()
	BrowseBuyoutButton:SetPoint("RIGHT", BrowseCloseButton, "LEFT", -1, 0)
	BrowseBidButton:ClearAllPoints()
	BrowseBidButton:SetPoint("RIGHT", BrowseBuyoutButton, "LEFT", -1, 0)
	BidBuyoutButton:ClearAllPoints()
	BidBuyoutButton:SetPoint("RIGHT", BidCloseButton, "LEFT", -1, 0)
	BidBidButton:ClearAllPoints()
	BidBidButton:SetPoint("RIGHT", BidBuyoutButton, "LEFT", -1, 0)
	AuctionsCancelAuctionButton:ClearAllPoints()
	AuctionsCancelAuctionButton:SetPoint("RIGHT", AuctionsCloseButton, "LEFT", -1, 0)

	-- Blizz needs to be more consistent

	BrowseBidPriceSilver:SetPoint("LEFT", BrowseBidPriceGold, "RIGHT", 1, 0)
	BrowseBidPriceCopper:SetPoint("LEFT", BrowseBidPriceSilver, "RIGHT", 1, 0)
	BidBidPriceSilver:SetPoint("LEFT", BidBidPriceGold, "RIGHT", 1, 0)
	BidBidPriceCopper:SetPoint("LEFT", BidBidPriceSilver, "RIGHT", 1, 0)
	StartPriceSilver:SetPoint("LEFT", StartPriceGold, "RIGHT", 1, 0)
	StartPriceCopper:SetPoint("LEFT", StartPriceSilver, "RIGHT", 1, 0)
	BuyoutPriceSilver:SetPoint("LEFT", BuyoutPriceGold, "RIGHT", 1, 0)
	BuyoutPriceCopper:SetPoint("LEFT", BuyoutPriceSilver, "RIGHT", 1, 0)

	local function reskinAuctionButtons(button, i)
		local bu = _G[button..i]
		local it = _G[button..i.."Item"]
		local ic = _G[button..i.."ItemIconTexture"]

		if bu and it then
			it:SetNormalTexture("")
			it:SetPushedTexture("")
			it:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			B.ReskinIcon(ic)
			it.IconBorder:SetAlpha(0)
			B.StripTextures(bu)

			local bg = B.CreateBDFrame(bu, .25)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 5)

			bu:SetHighlightTexture(DB.bdTex)
			local hl = bu:GetHighlightTexture()
			hl:SetVertexColor(r, g, b, .2)
			hl:ClearAllPoints()
			hl:SetPoint("TOPLEFT", 0, -1)
			hl:SetPoint("BOTTOMRIGHT", -1, 6)
		end
	end

	for i = 1, NUM_BROWSE_TO_DISPLAY do
		reskinAuctionButtons("BrowseButton", i)
	end

	for i = 1, NUM_BIDS_TO_DISPLAY do
		reskinAuctionButtons("BidButton", i)
	end

	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		reskinAuctionButtons("AuctionsButton", i)
	end

	local auctionhandler = CreateFrame("Frame")
	auctionhandler:RegisterEvent("NEW_AUCTION_UPDATE")
	auctionhandler:SetScript("OnEvent", function()
		local AuctionsItemButtonIconTexture = AuctionsItemButton:GetNormalTexture()
		if AuctionsItemButtonIconTexture then
			AuctionsItemButtonIconTexture:SetTexCoord(unpack(DB.TexCoord))
			AuctionsItemButtonIconTexture:SetInside()
		end
		AuctionsItemButton.IconBorder:SetTexture("")
	end)

	B.CreateBD(AuctionsItemButton, .25)
	local _, AuctionsItemButtonNameFrame = AuctionsItemButton:GetRegions()
	AuctionsItemButtonNameFrame:Hide()
	local hl = AuctionsItemButton:GetHighlightTexture()
	hl:SetColorTexture(1, 1, 1, .25)
	hl:SetInside()

	B.ReskinClose(AuctionFrameCloseButton, "TOPRIGHT", AuctionFrame, "TOPRIGHT", -4, -14)
	B.ReskinScroll(BrowseScrollFrameScrollBar)
	B.ReskinScroll(AuctionsScrollFrameScrollBar)
	B.ReskinScroll(BrowseFilterScrollFrameScrollBar)
	B.ReskinDropDown(PriceDropDown)
	B.ReskinDropDown(DurationDropDown)
	B.ReskinInput(BrowseName)
	B.ReskinArrow(BrowsePrevPageButton, "left")
	B.ReskinArrow(BrowseNextPageButton, "right")
	B.ReskinCheck(ExactMatchCheckButton)
	B.ReskinCheck(IsUsableCheckButton)
	B.ReskinCheck(ShowOnPlayerCheckButton)

	BrowsePrevPageButton:SetPoint("TOPLEFT", 660, -60)
	BrowseNextPageButton:SetPoint("TOPRIGHT", 67, -60)
	BrowsePrevPageButton:GetRegions():SetPoint("LEFT", BrowsePrevPageButton, "RIGHT", 2, 0)

	BrowseDropDownLeft:SetAlpha(0)
	BrowseDropDownMiddle:SetAlpha(0)
	BrowseDropDownRight:SetAlpha(0)

	local a1, p, a2, x, y = BrowseDropDownButton:GetPoint()
	BrowseDropDownButton:SetPoint(a1, p, a2, x, y-4)
	BrowseDropDownButton:SetSize(16, 16)
	B.Reskin(BrowseDropDownButton, true)

	local tex = BrowseDropDownButton:CreateTexture(nil, "OVERLAY")
	tex:SetTexture(DB.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	BrowseDropDownButton.bgTex = tex

	local bg = B.CreateBDFrame(BrowseDropDown, 0)
	bg:SetPoint("TOPLEFT", 16, -5)
	bg:SetPoint("BOTTOMRIGHT", 109, 11)
	B.CreateGradient(bg)

	BrowseDropDownButton:HookScript("OnEnter", B.Texture_OnEnter)
	BrowseDropDownButton:HookScript("OnLeave", B.Texture_OnLeave)

	local inputs = {"BrowseMinLevel", "BrowseMaxLevel", "BrowseBidPriceGold", "BrowseBidPriceSilver", "BrowseBidPriceCopper", "BidBidPriceGold", "BidBidPriceSilver", "BidBidPriceCopper", "StartPriceGold", "StartPriceSilver", "StartPriceCopper", "BuyoutPriceGold", "BuyoutPriceSilver", "BuyoutPriceCopper", "AuctionsStackSizeEntry", "AuctionsNumStacksEntry"}
	for i = 1, #inputs do
		B.ReskinInput(_G[inputs[i]])
	end

	-- [[ WoW token ]]

	local BrowseWowTokenResults = BrowseWowTokenResults

	B.Reskin(BrowseWowTokenResults.Buyout)
	B.ReskinPortraitFrame(WowTokenGameTimeTutorial)
	B.Reskin(StoreButton)
	WowTokenGameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
	WowTokenGameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	WowTokenGameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
	WowTokenGameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	-- Token

	do
		local Token = BrowseWowTokenResults.Token
		local icon = Token.Icon
		local iconBorder = Token.IconBorder

		Token.ItemBorder:Hide()
		iconBorder:SetTexture(DB.bdTex)
		iconBorder:SetDrawLayer("BACKGROUND")
		iconBorder:SetOutside(icon)
		icon:SetTexCoord(unpack(DB.TexCoord))
	end
end