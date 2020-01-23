local mod	= DBM:NewMod(2367, "DBM-Nyalotha", nil, 1180)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200122150554")
mod:SetCreatureID(157231)
mod:SetEncounterID(2335)
mod:SetZone()
mod:SetUsedIcons(4, 3, 2, 1)
mod:SetHotfixNoticeRev(20191109000000)--2019, 11, 09
--mod:SetMinSyncRevision(20190716000000)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 312528 306928 312529 306929 307260 306953 318078 312530 306930",
	"SPELL_AURA_APPLIED 312328 312329 307471 307472 307358 306942 318078 308149 312099 306447 306931 306933",
	"SPELL_AURA_APPLIED_DOSE 312328 307358",
	"SPELL_AURA_REMOVED 312328 307358 306447 306933 306931",
	"SPELL_AURA_REMOVED_DOSE 312328 307358",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_SPELLCAST_START boss1",
	"UNIT_POWER_FREQUENT boss1"
)

--TODO, add tracking of tasty Morsel carriers to infoframe?
--TODO, see if seenAdds solved the fixate timer issue, or if something else wonky still going on with it
--[[
(ability.id = 312528 or ability.id = 306928 or ability.id = 312529 or ability.id = 306929 or ability.id = 307260 or ability.id = 306953) and type = "begincast"
 or (ability.id = 307471 or ability.id = 312530 or ability.id = 306930) and type = "cast"
 or (ability.id = 306447 or ability.id = 306931 or ability.id = 306933) and type = "applybuff"
--]]
local warnHunger							= mod:NewStackAnnounce(312328, 2, nil, false, 2)--Mythic
local warnUmbralMantle						= mod:NewSpellAnnounce(306447, 2)
local warnUmbralEruption					= mod:NewSpellAnnounce(308157, 2)
local warnNoxiousMantle						= mod:NewSpellAnnounce(306931, 2)
local warnBubblingOverflow					= mod:NewCountAnnounce(314736, 2)
local warnEntropicMantle					= mod:NewSpellAnnounce(306933, 2)
local warnCrush								= mod:NewTargetNoFilterAnnounce(307471, 3, nil, "Tank")
local warnDissolve							= mod:NewTargetNoFilterAnnounce(307472, 3, nil, "Tank")
local warnDebilitatingSpit					= mod:NewTargetNoFilterAnnounce(307358, 3, nil, false)
local warnFrenzy							= mod:NewTargetNoFilterAnnounce(306942, 2)
local warnFixate							= mod:NewTargetAnnounce(307260, 2)
local warnEntropicBuildup					= mod:NewCountAnnounce(308177, 2)
local warnEntropicBreath					= mod:NewSpellAnnounce(306930, 2, nil, "Tank")
local warnTastyMorsel						= mod:NewTargetNoFilterAnnounce(312099, 1)

local specWarnUncontrollablyRavenous		= mod:NewSpecialWarningSpell(312329, nil, nil, nil, 3, 2)--Mythic
local specWarnCrushTaunt					= mod:NewSpecialWarningTaunt(307471, nil, nil, nil, 3, 2)
local specWarnDissolveTaunt					= mod:NewSpecialWarningTaunt(307472, nil, nil, nil, 1, 2)
local specWarnSlurryBreath					= mod:NewSpecialWarningDodge(306736, nil, nil, nil, 2, 2)
local specWarnDebilitatingSpit				= mod:NewSpecialWarningYou(307358, nil, nil, nil, 1, 2)
local specWarnFixate						= mod:NewSpecialWarningRun(307260, nil, nil, nil, 4, 2)
local yellFixate							= mod:NewYell(307260, nil, true, 2)
local specWarnUmbralEruption				= mod:NewSpecialWarningDodge(308157, false, nil, 2, 2, 2)--Because every 8-10 seconds is excessive, let user opt in for this
local specWarnGTFO							= mod:NewSpecialWarningGTFO(308149, nil, nil, nil, 1, 8)

local timerCrushCD							= mod:NewCDTimer(25.1, 307471, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON, nil, 2, 4)
local timerSlurryBreathCD					= mod:NewCDTimer(17, 306736, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerDebilitatingSpitCD				= mod:NewCDTimer(30.1, 306953, nil, nil, nil, 5, nil, DBM_CORE_HEALER_ICON)
local timerFixateCD							= mod:NewCDTimer(30.2, 307260, nil, nil, nil, 3, nil, DBM_CORE_DAMAGE_ICON)
local timerUmbralEruptionCD					= mod:NewNextTimer(10, 308157, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)
local timerBubblingOverflowCD				= mod:NewNextTimer(10, 314736, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)
local timerEntropicBuildupCD				= mod:NewNextTimer(10, 308177, nil, nil, nil, 5, nil, DBM_CORE_HEROIC_ICON)

local berserkTimer							= mod:NewBerserkTimer(360)

--mod:AddRangeFrameOption(6, 264382)
mod:AddInfoFrameOption(307358, true)
mod:AddSetIconOption("SetIconOnDebilitating", 306953, true, false, {1, 2, 3, 4})

mod.vb.phase = 0
mod.vb.eruptionCount = 0
mod.vb.bubblingCount = 0
mod.vb.buildupCount = 0
mod.vb.fixateCount = 0
mod.vb.bossPowerUpdateRate = 4
local SpitStacks = {}
local orbTimersHeroic = {0, 25, 25, 37, 20}
local orbTimersNormal = {0, 25, 25, 25, 25}
local umbralTimers = {10, 10, 10, 10, 10, 8, 8, 8, 8, 8, 6, 6, 6, 6, 6}
local bubblingTimers = {10, 10, 9.5, 9, 11, 10, 11, 11, 8, 8, 8}
local seenAdds = {}

local function umbralEruptionLoop(self)
	self.vb.eruptionCount = self.vb.eruptionCount + 1
	if self.Options.SpecWarn308157dodge then
		specWarnUmbralEruption:Show()
		specWarnUmbralEruption:Play("watchstep")
	else
		warnUmbralEruption:Show()
	end
	local timer = umbralTimers[self.vb.eruptionCount+1]
	if timer then
		timerUmbralEruptionCD:Start(timer)
		self:Schedule(timer, umbralEruptionLoop, self)
	end
end

local function bubblingOverflowLoop(self)
	self.vb.bubblingCount = self.vb.bubblingCount + 1
	warnBubblingOverflow:Show(self.vb.bubblingCount)
	local timer = bubblingTimers[self.vb.bubblingCount+1]
	if timer then
		timerBubblingOverflowCD:Start(timer)
		self:Schedule(timer, bubblingOverflowLoop, self)
	end
end

local function entropicBuildupLoop(self)
	self.vb.buildupCount = self.vb.buildupCount + 1
	warnEntropicBuildup:Show(self.vb.buildupCount)
	local timer = self:IsHard() and orbTimersHeroic[self.vb.buildupCount+1] or self:IsEasy() and orbTimersNormal[self.vb.buildupCount+1]
	if timer then
		timerEntropicBuildupCD:Start(timer)
		self:Schedule(timer, entropicBuildupLoop, self)
	end
end

local function updateBreathTimer(self)
	--Update Breath timer
	local bossPower = UnitPower("boss1")
	local breathTimerTotal = 100 / self.vb.bossPowerUpdateRate
	local bossProgress = (100 - bossPower) / self.vb.bossPowerUpdateRate
	--Using update method to both start a new timer and update an existing one because it supports both
	timerSlurryBreathCD:Update(bossProgress, breathTimerTotal)
end

function mod:SpitTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") and self:AntiSpam(5, 5) then
		specWarnDebilitatingSpit:Show()
		specWarnDebilitatingSpit:Play("targetyou")
	else
		warnDebilitatingSpit:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.phase = 0
	self.vb.fixateCount = 0
	self.vb.bossPowerUpdateRate = 4
	table.wipe(SpitStacks)
	table.wipe(seenAdds)
	timerDebilitatingSpitCD:Start(10.7-delay)--START
	timerCrushCD:Start(15.1-delay)--Time til script begins
	timerSlurryBreathCD:Start(26.6-delay)--Technically it should be 25 but there is a pause before boss begins gaining power
	timerFixateCD:Start(self:IsMythic() and 16.1 or 31)
	berserkTimer:Start(360-delay)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
--	if self.Options.RangeFrame then
--		DBM.RangeCheck:Hide()
--	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 312528 or spellId == 306928 or spellId == 312529 or spellId == 306929 then--Umbral and Bubbling Breaths
		specWarnSlurryBreath:Show()
		specWarnSlurryBreath:Play("breathsoon")
		--timerSlurryBreathCD:Start(timer)
	elseif spellId == 312530 or spellId == 306930 then--Entropic Breaths
		warnEntropicBreath:Show()
		--timerSlurryBreathCD:Start(timer)
	elseif (spellId == 318078 or spellId == 307260) and not seenAdds[args.sourceGUID] and self:AntiSpam(5, 3) then
		self.vb.fixateCount = self.vb.fixateCount + 1
		seenAdds[args.sourceGUID] = true
		local timer = self:IsMythic() and self.vb.fixateCount == 1 and 16.1 or 30.2
		timerFixateCD:Start(timer)
	elseif spellId == 306953 then
		timerDebilitatingSpitCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 312328 then
		warnHunger:Show(args.destName, args.amount or 1)
	elseif spellId == 312329 then
		specWarnUncontrollablyRavenous:Show()
		specWarnUncontrollablyRavenous:Play("stilldanger")
	elseif spellId == 307471 then
		if args:IsPlayer() then
			warnCrush:Show(args.destName)
		--Not dead, and the nearby tank in a 3 tank setup (or any tank in 2 tank setup)
		elseif self:IsTank() and (self:CheckNearby(8, args.destName) or self:GetNumAliveTanks() < 3) and not UnitIsDeadOrGhost("player") then
			specWarnCrushTaunt:Show(args.destName)
			specWarnCrushTaunt:Play("tauntboss")
		else
			warnCrush:Show(args.destName)
		end
	elseif spellId == 307472 then
		if args:IsPlayer() then
			warnDissolve:Show(args.destName)
		--Not dead, and the nearby tank in a 3 tank setup (or any tank in 2 tank setup)
		elseif self:IsTank() and (self:CheckNearby(8, args.destName) or self:GetNumAliveTanks() < 3) and not UnitIsDeadOrGhost("player") then
			specWarnDissolveTaunt:Show(args.destName)
			specWarnDissolveTaunt:Play("tauntboss")
		else
			warnDissolve:Show(args.destName)
		end
	elseif spellId == 307358 then
		local amount = args.amount or 1
		SpitStacks[args.destName] = amount
		if amount == 1 then
			warnDebilitatingSpit:CombinedShow(0.5, args.destName)
			if args:IsPlayer() and self:AntiSpam(4, 5) then
				specWarnDebilitatingSpit:Show()
				specWarnDebilitatingSpit:Play("targetyou")
			end
			if self.Options.SetIconOnDebilitating then
				self:SetIcon(args.destName, #SpitStacks)
			end
		end
		if self.Options.InfoFrame then
			if #SpitStacks == 1 then
				DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307358))
				DBM.InfoFrame:Show(10, "table", SpitStacks, 1)
			else
				DBM.InfoFrame:UpdateTable(SpitStacks)
			end
		end
	elseif spellId == 306942 then
		warnFrenzy:Show(args.destName)
	elseif spellId == 318078 then
		warnFixate:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnFixate:Show()
			specWarnFixate:Play("justrun")
			yellFixate:Yell()
		end
	elseif spellId == 306447 then
		self.vb.phase = self.vb.phase + 1
		warnUmbralMantle:Show()
		if not self:IsLFR() then
			--Schedule P1 Loop
			self.vb.eruptionCount = 0
			timerUmbralEruptionCD:Start(10)--Damage at 12, so warning 2 seconds before seems right
			self:Schedule(10, umbralEruptionLoop, self)
		end
		updateBreathTimer(self)
	elseif spellId == 306931 then
		self.vb.phase = self.vb.phase + 1
		warnNoxiousMantle:Show()
		if not self:IsLFR() then
			--Unschedule P1 loop
			timerUmbralEruptionCD:Stop()
			self:Unschedule(umbralEruptionLoop)
			--Schedule P2 Loop
			self.vb.bubblingCount = 0
			timerBubblingOverflowCD:Start(10)
			self:Schedule(10, bubblingOverflowLoop, self)
		end
		updateBreathTimer(self)
	elseif spellId == 306933 then
		self.vb.phase = self.vb.phase + 1
		warnEntropicMantle:Show()
		if not self:IsLFR() then
			--Unschedule P1 loop (future proofing)
			timerUmbralEruptionCD:Stop()
			self:Unschedule(umbralEruptionLoop)
			--Unschedule P2 loop
			timerBubblingOverflowCD:Stop()
			self:Unschedule(bubblingOverflowLoop)
			--Schedue P3 Loop
			self.vb.buildupCount = 0
			entropicBuildupLoop(self)--Might need adjusting, harder to verifiy in transcriptor
		end
		updateBreathTimer(self)
	elseif spellId == 308149 and args:IsPlayer() then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	elseif spellId == 312099 then
		warnTastyMorsel:Show(args.destName)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 312328 then
		warnHunger:Show(args.destName, args.amount or 0)
	elseif spellId == 307358 then
		local amount = args.amount or 0
		if amount == 0 then
			SpitStacks[args.destName] = nil
			if self.Options.SetIconOnDebilitating then
				self:SetIcon(args.destName, 0)
			end
		else
			SpitStacks[args.destName] = args.amount
		end
		if self.Options.InfoFrame then
			if #SpitStacks == 0 then
				DBM.InfoFrame:Hide()
			else
				DBM.InfoFrame:UpdateTable(SpitStacks)
			end
		end
	elseif spellId == 306447 then
		timerUmbralEruptionCD:Stop()
		self:Unschedule(umbralEruptionLoop)
	elseif spellId == 306931 then
		timerBubblingOverflowCD:Stop()
		self:Unschedule(bubblingOverflowLoop)
	elseif spellId == 306933 then
		timerEntropicBuildupCD:Stop()
		self:Unschedule(entropicBuildupLoop)
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 270290 and destGUID == UnitGUID("player") and self:AntiSpam(2, 4) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 152311 then

	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	if msg:find("spell:306448") then--Umbral Mantle
		self.vb.phase = self.vb.phase + 1
		warnUmbralMantle:Show()
	elseif msg:find("spell:306934") then--Entropic Mantle
		self.vb.phase = self.vb.phase + 1
		warnEntropicMantle:Show()
	elseif msg:find("spell:306932") then--Noxious Mantle
		self.vb.phase = self.vb.phase + 1
		warnNoxiousMantle:Show()
	end
end
--]]

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 307469 then--Crush & Dissolve Cover
		timerCrushCD:Start()
	elseif spellId == 306736 then--Slurry Breath
		updateBreathTimer(self)
	end
end


function mod:UNIT_SPELLCAST_START(uId, _, spellId)
	if spellId == 306953 then
		self:BossUnitTargetScanner(uId, "SpitTarget")
	end
end

do
	local lastPower = 0
	--Starts at 4 per second and increases to 5, etc as fight progresses
	--Still not perfect because it seems to support non even numbers internally but api isn't gonna report only whole numbers
	--I have two logs that have energy rate/timing pegged at exactly 5.85 where as it'd end up rounding to 6 since blizz would only send whole number energy updates thus shorting timer by teeny bit
	--Case and point to above issue 17.0, 17.1, 21.9, 17.0, 17.1. to get 17.1 update rate would HAVE to be less than 6 but greater than 5. About 5.85
	function mod:UNIT_POWER_FREQUENT(uId, type)
		local bossPower = UnitPower("boss1") --Get Boss Power
		if bossPower > lastPower then
			local currentRate = bossPower - lastPower
			if currentRate ~= self.vb.bossPowerUpdateRate then
				self.vb.bossPowerUpdateRate = currentRate
				updateBreathTimer(self)
			end
		end
		lastPower = bossPower
	end
end
