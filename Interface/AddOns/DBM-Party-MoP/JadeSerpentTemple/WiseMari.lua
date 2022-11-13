local mod	= DBM:NewMod(672, "DBM-Party-MoP", 1, 313)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,challenge,timewalker"

mod:SetRevision("20221108201332")
mod:SetCreatureID(56448)
mod:SetEncounterID(1418)
mod:SetUsedIcons(8)
mod:SetHotfixNoticeRev(20221108000000)
mod:SetMinSyncRevision(20221108000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 397783 397801",
	"SPELL_AURA_APPLIED 397797 397799",
	"SPELL_AURA_REMOVED 397797"
--	"SPELL_DAMAGE 115167",
--	"SPELL_MISSED 115167"
)

--This verion of mod is for the retail redesign
--TODO, Corrupted Geyser spawn is not in combat log so I can't implement it in this mod yet til its added
--[[
ability.id = 397783 and type = "begincast"
 or ability.id = 397797 and type = "applydebuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnCorruptedVortex			= mod:NewTargetAnnounce(397797, 3)

local specWarnWashAway				= mod:NewSpecialWarningDodge(397783, nil, nil, nil, 2, 2)
local specWarnCorruptedVortex		= mod:NewSpecialWarningMoveAway(397797, nil, nil, nil, 1, 2)
local yellCorruptedVortex			= mod:NewYell(397797)
local yellCorruptedVortexFades		= mod:NewShortFadesYell(397797)
--local specWarnCorruptedGeyser		= mod:NewSpecialWarningDodge(397793, nil, nil, nil, 2, 2)
local specWarnHydrolance			= mod:NewSpecialWarningInterrupt(397801, "HasInterrupt", nil, nil, 1, 2)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(397799, nil, nil, nil, 1, 8)

local timerWashAwayCD				= mod:NewCDTimer(41.3, 397783, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON)--41-44
local timerCorruptedVortexCD		= mod:NewCDTimer(14.2, 397797, nil, nil, nil, 3, nil, DBM_COMMON_L.HEALER_ICON)
--local timerCorruptedGeyserCD		= mod:NewCDTimer(5.5, 397793, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerCorruptedVortexCD:Start(8.5-delay)
	timerWashAwayCD:Start(20.6-delay)
	--timerCorruptedGeyserCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 397783 then
		specWarnWashAway:Show()
		specWarnWashAway:Play("watchstep")
		timerWashAwayCD:Start()
		timerCorruptedVortexCD:Restart(17.2)
	elseif spellId == 397801 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnHydrolance:Show(args.sourceName)
		specWarnHydrolance:Play("kickcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 397797 then
		if self:AntiSpam(5, 1) then
			timerCorruptedVortexCD:Start()
		end
		if args:IsPlayer() then
			specWarnCorruptedVortex:Show()
			specWarnCorruptedVortex:Play("runout")
			yellCorruptedVortex:Yell()
			yellCorruptedVortexFades:Countdown(spellId)
		end
	elseif spellId == 397799 and args:IsPlayer() and self:AntiSpam(4, 2) then
		specWarnGTFO:Show(args.spellName)
		specWarnGTFO:Play("watchfeet")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 397797 then
		if args:IsPlayer() then
			yellCorruptedVortexFades:Cancel()
		end
	end
end

--[[
function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 115167 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
--]]
