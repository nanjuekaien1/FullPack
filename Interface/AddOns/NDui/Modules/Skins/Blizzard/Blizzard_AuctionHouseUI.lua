local _, ns = ...
local B, C, L, DB = unpack(ns)

C.themes["Blizzard_AuctionHouseUI"] = function()
	local function reskinAuctionButton(button)
		B.Reskin(button)
		button:SetSize(22, 22)
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
		if frame.BuyoutModeCheckButton then
			B.ReskinCheck(frame.BuyoutModeCheckButton)
			frame.BuyoutModeCheckButton:SetSize(28, 28)
		end
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
					if child.IconBorder then child.IconBorder:SetAlpha(0) end
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
		if itemButton.CircleMask then itemButton.CircleMask:Hide() end
		itemButton.IconBorder:SetAlpha(0)
		B.ReskinIcon(itemButton.Icon)
	end

	local function reskinItemList(frame, hasHeader)
		B.StripTextures(frame)
		B.CreateBDFrame(frame.ScrollFrame, .25)
		B.ReskinScroll(frame.ScrollFrame.scrollBar)
		if frame.RefreshFrame then
			reskinAuctionButton(frame.RefreshFrame.RefreshButton)
		end
		if hasHeader then
			hooksecurefunc(frame, "RefreshScrollFrame", reskinListHeader)
		end
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
	reskinItemList(AuctionHouseFrame.BrowseResultsFrame.ItemList, true)

	hooksecurefunc("FilterButton_SetUp", function(button)
		button.NormalTexture:SetAlpha(0)
		button.SelectedTexture:SetColorTexture(0, .6, 1, .3)
		button.HighlightTexture:SetColorTexture(1, 1, 1, .1)
	end)

	local itemBuyFrame = AuctionHouseFrame.ItemBuyFrame
	B.Reskin(itemBuyFrame.BackButton)
	B.Reskin(itemBuyFrame.BidFrame.BidButton)
	B.Reskin(itemBuyFrame.BuyoutFrame.BuyoutButton)
	B.ReskinInput(AuctionHouseFrameGold)
	B.ReskinInput(AuctionHouseFrameSilver)
	reskinItemDisplay(itemBuyFrame)
	reskinItemList(itemBuyFrame.ItemList, true)

	local commBuyFrame = AuctionHouseFrame.CommoditiesBuyFrame
	B.Reskin(commBuyFrame.BackButton)
	local buyDisplay = commBuyFrame.BuyDisplay
	B.StripTextures(buyDisplay)
	B.ReskinInput(buyDisplay.QuantityInput.InputBox)
	B.Reskin(buyDisplay.BuyButton)
	reskinItemDisplay(buyDisplay)
	reskinItemList(commBuyFrame.ItemList)

	local wowTokenResults = AuctionHouseFrame.WoWTokenResults
	B.StripTextures(wowTokenResults)
	B.StripTextures(wowTokenResults.TokenDisplay)
	B.CreateBDFrame(wowTokenResults.TokenDisplay, .25)
	B.Reskin(wowTokenResults.Buyout)
	B.ReskinScroll(wowTokenResults.DummyScrollBar)

	local gameTimeTutorial = wowTokenResults.GameTimeTutorial
	B.ReskinPortraitFrame(gameTimeTutorial)
	B.Reskin(gameTimeTutorial.RightDisplay.StoreButton)
	gameTimeTutorial.LeftDisplay.Label:SetTextColor(1, 1, 1)
	gameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(1, .8, 0)
	gameTimeTutorial.RightDisplay.Label:SetTextColor(1, 1, 1)
	gameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(1, .8, 0)

	local woWTokenSellFrame = AuctionHouseFrame.WoWTokenSellFrame
	B.StripTextures(woWTokenSellFrame)
	B.Reskin(woWTokenSellFrame.PostButton)
	B.StripTextures(woWTokenSellFrame.DummyItemList)
	B.CreateBDFrame(woWTokenSellFrame.DummyItemList, .25)
	B.ReskinScroll(woWTokenSellFrame.DummyItemList.DummyScrollBar)
	reskinAuctionButton(woWTokenSellFrame.DummyRefreshButton)
	reskinItemDisplay(woWTokenSellFrame)

	reskinSellPanel(AuctionHouseFrame.ItemSellFrame)
	reskinSellPanel(AuctionHouseFrame.CommoditiesSellFrame)
	reskinSellList(AuctionHouseFrame.CommoditiesSellList, true)
	reskinSellList(AuctionHouseFrame.ItemSellList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.SummaryList)
	reskinSellList(AuctionHouseFrameAuctionsFrame.AllAuctionsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.BidsList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.CommoditiesList, true)
	reskinSellList(AuctionHouseFrameAuctionsFrame.ItemList, true)
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

	local multisellFrame = AuctionHouseMultisellProgressFrame
	B.StripTextures(multisellFrame)
	B.SetBD(multisellFrame)
	local progressBar = multisellFrame.ProgressBar
	B.StripTextures(progressBar)
	progressBar:SetStatusBarTexture(DB.normTex)
	B.CreateBDFrame(progressBar, .25)
	B.ReskinClose(multisellFrame.CancelButton, "LEFT", progressBar, "RIGHT", 3, 0)
end