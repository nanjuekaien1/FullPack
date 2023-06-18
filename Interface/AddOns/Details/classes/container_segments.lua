
local Details = _G.Details
local _
local addonName, Details222 = ...

local combatClass = Details.combate
local segmentClass = Details.historico
local timeMachine = Details.timeMachine
local bitBand = bit.band

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--API

--reset only the overall data
function Details:ResetSegmentOverallData()
	return segmentClass:ResetOverallData()
end

--reset segments and overall data
function Details:ResetSegmentData()
	return segmentClass:ResetAllCombatData()
end

--returns the current active segment
function Details:GetCurrentCombat()
	return Details.tabela_vigente
end

function Details:GetOverallCombat()
	return Details.tabela_overall
end

function Details:GetCombat(combat)
	if (not combat) then
		return Details.tabela_vigente

	elseif (type(combat) == "number") then
		if (combat == -1) then --overall
			return Details.tabela_overall

		elseif (combat == 0) then --current
			return Details.tabela_vigente
		else
			return Details.tabela_historico.tabelas[combat]
		end

	elseif (type(combat) == "string") then
		if (combat == "overall") then
			return Details.tabela_overall
		elseif (combat == "current") then
			return Details.tabela_vigente
		end
	end

	return nil
end

--returns a private table containing all stored segments
function Details:GetCombatSegments()
	return Details.tabela_historico.tabelas
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--internal

function segmentClass:CreateNewSegmentDatabase()
	local newSegmentDatabase = {tabelas = {}}
	setmetatable(newSegmentDatabase, segmentClass)
	return newSegmentDatabase
end

function segmentClass:AddToOverallData(combatObject)
	local zoneName, zoneType = GetInstanceInfo()
	if (zoneType ~= "none" and combatObject:GetCombatTime() <= Details.minimum_overall_combat_time) then
		return
	end

	if (Details.overall_clear_newboss) then
		--only for raids
		if (combatObject.instance_type == "raid" and combatObject.is_boss) then
			if (Details.last_encounter ~= Details.last_encounter2) then
				if (Details.debug) then
					Details:Msg("(debug) new boss detected 'overall_clear_newboss' is true, cleaning overall data.")
				end
				for index, combat in ipairs(Details.tabela_historico.tabelas) do
					combat.overall_added = false
				end
				segmentClass:ResetOverallData()
			end
		end
	end

	if (combatObject.overall_added) then
		Details:Msg("error > attempt to add a segment already added > func historico:AddToOverallData()")
		return
	end

	local mythicInfo = combatObject.is_mythic_dungeon
	if (mythicInfo) then
		--do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			Details:Msg("error > attempt to add a TrashOverallSegment > func historico:AddToOverallData()")
			return

		elseif (mythicInfo.OverallSegment) then
			Details:Msg("error > attempt to add a OverallSegment > func historico:AddToOverallData()")
			return
		end
	end

	--store the segments added to the overall data
	Details.tabela_overall.segments_added = Details.tabela_overall.segments_added or {}
	local startDate = combatObject.data_inicio

	local combatName = combatObject:GetCombatName(true)
	local combatTime = combatObject:GetCombatTime()
	local combatType = combatObject:GetCombatType()

	table.insert(Details.tabela_overall.segments_added, 1, {name = combatName, elapsed = combatTime, clock = startDate, type = combatType})

	if (#Details.tabela_overall.segments_added > 40) then
		table.remove(Details.tabela_overall.segments_added, 41)
	end

	if (Details.debug) then
		Details:Msg("(debug) adding the segment to overall data: " .. (combatObject:GetCombatName(true) or "no name") .. " with time of: " .. (combatObject:GetCombatTime() or "no time"))
	end

	Details.tabela_overall = Details.tabela_overall + combatObject
	combatObject.overall_added = true

	if (not Details.tabela_overall.overall_enemy_name) then
		Details.tabela_overall.overall_enemy_name = combatObject.is_boss and combatObject.is_boss.name or combatObject.enemy
	else
		if (Details.tabela_overall.overall_enemy_name ~= (combatObject.is_boss and combatObject.is_boss.name or combatObject.enemy)) then
			Details.tabela_overall.overall_enemy_name = "-- x -- x --"
		end
	end

	if (Details.tabela_overall.start_time == 0) then
		Details.tabela_overall:SetStartTime(combatObject.start_time)
		Details.tabela_overall:SetEndTime(combatObject.end_time)
	else
		Details.tabela_overall:SetStartTime(combatObject.start_time - Details.tabela_overall:GetCombatTime())
		Details.tabela_overall:SetEndTime(combatObject.end_time)
	end

	if (Details.tabela_overall.data_inicio == 0) then
		Details.tabela_overall.data_inicio = Details.tabela_vigente.data_inicio or 0
	end

	Details.tabela_overall:seta_data(Details._detalhes_props.DATA_TYPE_END)
	Details:ClockPluginTickOnSegment()

	for id, instance in Details:ListInstances() do
		if (instance:IsEnabled()) then
			if (instance:GetSegment() == DETAILS_SEGMENTID_OVERALL) then
				instance:ForceRefresh()
			end
		end
	end
end

---return true if the combatObject can be added to the overall data
---@param self details
---@param combatObject table
---@return boolean canAdd
function Details:CanAddCombatToOverall(combatObject)
	--already added
	if (combatObject.overall_added) then
		return false
	end

	--already scheduled to add
	if (Details.schedule_add_to_overall) then --deprecated
		for _, combat in ipairs(Details.schedule_add_to_overall) do
			if (combat == combatObject) then
				return false
			end
		end
	end

	--special cases
	local mythicInfo = combatObject.is_mythic_dungeon
	if (mythicInfo) then
		--do not add overall mythic+ dungeon segments
		if (mythicInfo.TrashOverallSegment) then
			return false

		elseif (mythicInfo.OverallSegment) then
			return false
		end
	end

	--raid boss - flag 0x1
	if (bitBand(Details.overall_flag, 0x1) ~= 0) then
		if (combatObject.is_boss and combatObject.instance_type == "raid" and not combatObject.is_pvp) then
			if (combatObject:GetCombatTime() >= 30) then
				return true
			end
		end
	end

	--raid trash - flag 0x2
	if (bitBand(Details.overall_flag, 0x2) ~= 0) then
		if (combatObject.is_trash and combatObject.instance_type == "raid") then
			return true
		end
	end

	--dungeon boss - flag 0x4
	if (bitBand(Details.overall_flag, 0x4) ~= 0) then
		if (combatObject.is_boss and combatObject.instance_type == "party" and not combatObject.is_pvp) then
			return true
		end
	end

	--dungeon trash - flag 0x8
	if (bitBand(Details.overall_flag, 0x8) ~= 0) then
		if ((combatObject.is_trash or combatObject.is_mythic_dungeon_trash) and combatObject.instance_type == "party") then
			return true
		end
	end

	--any combat
	if (bitBand(Details.overall_flag, 0x10) ~= 0) then
		return true
	end

	--is a PvP combat
	if (combatObject.is_pvp or combatObject.is_arena) then
		return true
	end

	return false
end

---add the combat to the segment table, check adding to overall
---@param combatObject combat
function segmentClass:AddCombat(combatObject)
	---@type combat[]
	local segmentTable = self.tabelas
	---@type number
	local maxSegmentsAllowed = Details.segments_amount

	--check all instances for freeze state
	if (#segmentTable < maxSegmentsAllowed) then
		---@type combat
		local oldestCombatObject = segmentTable[#segmentTable]
		--if there's no segment stored, then this as the first segment
		if (not oldestCombatObject) then
			oldestCombatObject = combatObject
		end
		Details:InstanciaCallFunction(Details.CheckFreeze, #segmentTable + 1, oldestCombatObject)
	end

	--add to the first index of the segment table
	table.insert(segmentTable, 1, combatObject)

	--count boss tries
	---@type string
	local bossName = combatObject.is_boss and combatObject.is_boss.name
	if (bossName) then
		local tryNumber = Details.encounter_counter[bossName]

		if (not tryNumber) then
			---@type combat
			local previousCombatObject
			for i = 2, #segmentTable do
				previousCombatObject = segmentTable[i]
				if (previousCombatObject and previousCombatObject.is_boss and previousCombatObject.is_boss.name and previousCombatObject.is_boss.try_number and previousCombatObject.is_boss.name == bossName and not previousCombatObject.is_boss.killed) then
					tryNumber = previousCombatObject.is_boss.try_number + 1
					break
				end
			end

			if (not tryNumber) then
				tryNumber = 1
			end
		else
			tryNumber = Details.encounter_counter[bossName] + 1
		end

		Details.encounter_counter[bossName] = tryNumber
		combatObject.is_boss.try_number = tryNumber
	end

	--see if can add the encounter to overall data
	local canAddToOverall = Details:CanAddCombatToOverall(combatObject)

	if (canAddToOverall) then
		if (Details.debug) then
			Details:Msg("(debug) overall data flag match addind the combat to overall data.")
		end
		segmentClass:AddToOverallData(combatObject)
	end

	--erase trash segments
	if (segmentTable[2]) then
		---@type combat
		local previousCombatObject = segmentTable[2]
		---@type actorcontainer
		local containerDamage = previousCombatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
		---@type actorcontainer
		local containerHeal = previousCombatObject:GetContainer(DETAILS_ATTRIBUTE_HEAL)

		--regular cleanup
		for _, actorObject in containerDamage:ListActors() do
			---@cast actorObject actor
			--clear last events table
			actorObject.last_events_table =  nil
			Details222.TimeMachine.RemoveActor(actorObject)
		end

		for _, actorObject in containerHeal:ListActors() do
			---@cast actorObject actor
			actorObject.last_events_table =  nil
			Details222.TimeMachine.RemoveActor(actorObject)
		end

		if (Details.trash_auto_remove) then
			---@type combat
			local thirdCombat = segmentTable[3]

			if (thirdCombat and not thirdCombat.is_mythic_dungeon_segment) then
				if ((thirdCombat.is_trash and not thirdCombat.is_boss) or(thirdCombat.is_temporary)) then
					--verify again the time machine
					for _, actorObject in thirdCombat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE):ListActors() do
						Details222.TimeMachine.RemoveActor(actorObject)
					end
					for _, actorObject in thirdCombat:GetContainer(DETAILS_ATTRIBUTE_HEAL):ListActors() do
						Details222.TimeMachine.RemoveActor(actorObject)
					end

					--remove
					local combatObjectRemoved = table.remove(segmentTable, 3)
					if (combatObjectRemoved) then
						Details:DestroyCombat(combatObjectRemoved)
						Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
					end
				end
			end
		end
	end

	local segmentsTable = Details.tabela_historico.tabelas

	--check if the segment table is full
	if (#segmentsTable > maxSegmentsAllowed) then
		---@type combat
		local combatObjectToBeRemoved
		---@type number
		local segmentIdToBeRemoved

		--verify if the last combat is a boss and if there's more bosses with the same bossId in the segment table
		--then check which combat has the least amount of elapsed time and remove it
		--won't remove the latest 3 segments as they are fresh and the player may still look into them
		local bossId = combatObject.is_boss and combatObject.is_boss.id

		---@type combat
		local oldestSegment = segmentsTable[#segmentsTable]
		local oldestBossId = oldestSegment.is_boss and oldestSegment.is_boss.id

		if (Details.zone_type == "raid" and bossId and oldestBossId and bossId == oldestBossId) then
			---@type combat
			local shorterCombatObject
			---@type number
			local shorterSegmentId
			local minTime = 99999

			for segmentId = 4, #segmentsTable do
				---@type combat
				local thisCombatObject = segmentsTable[segmentId]
				if (thisCombatObject.is_boss and thisCombatObject.is_boss.id == bossId and thisCombatObject:GetCombatTime() < minTime and not thisCombatObject.is_boss.killed) then
					shorterCombatObject = thisCombatObject
					shorterSegmentId = segmentId
					minTime = thisCombatObject:GetCombatTime()
				end
			end

			if (shorterCombatObject) then
				combatObjectToBeRemoved = shorterCombatObject
				segmentIdToBeRemoved = shorterSegmentId
			end
		end

		--if couldn't find a boss to remove, then remove the oldest segment
		if (not combatObjectToBeRemoved) then
			combatObjectToBeRemoved = segmentsTable[#segmentsTable]
			segmentIdToBeRemoved = #segmentsTable
		end

		--check time machine
		for _, actorObject in combatObjectToBeRemoved:GetContainer(DETAILS_ATTRIBUTE_DAMAGE):ListActors() do
			Details222.TimeMachine.RemoveActor(actorObject)
		end
		for _, actorObject in combatObjectToBeRemoved:GetContainer(DETAILS_ATTRIBUTE_HEAL):ListActors() do
			Details222.TimeMachine.RemoveActor(actorObject)
		end

		--remove it
		segmentsTable = Details.tabela_historico.tabelas
		---@type combat
		local combatObjectRemoved = table.remove(segmentsTable, segmentIdToBeRemoved)
		if (combatObjectRemoved) then
			Details:DestroyCombat(combatObjectRemoved)
			Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
		end
	end

	Details:InstanceCall(function(instanceObject) instanceObject:RefreshCombat() end)

	--update the combat shown on all instances
	Details:InstanciaCallFunction(Details.AtualizaSegmentos_AfterCombat, self)
end

---verify if the instance is freezed, if true unfreeze it
---@param instanceObject instance
---@param segmentId number
---@param combatObject combat
function Details:CheckFreeze(instanceObject, segmentId, combatObject)
	if (instanceObject.freezed) then
		if (instanceObject:GetSegmentId() == segmentId) then
			instanceObject:RefreshCombat()
			instanceObject:UnFreeze()
		end
	end
end

function Details:SetOverallResetOptions(resetOnNewBoss, resetOnNewChallenge, resetOnLogoff, resetOnNewPVP)
	if (resetOnNewBoss == nil) then
		resetOnNewBoss = Details.overall_clear_newboss
	end
	if (resetOnNewChallenge == nil) then
		resetOnNewChallenge = Details.overall_clear_newchallenge
	end
	if (resetOnLogoff == nil) then
		resetOnLogoff = Details.overall_clear_logout
	end
	if (resetOnNewPVP == nil) then
		resetOnNewPVP = Details.overall_clear_pvp
	end

	Details.overall_clear_newboss = resetOnNewBoss
	Details.overall_clear_newchallenge = resetOnNewChallenge
	Details.overall_clear_logout = resetOnLogoff
	Details.overall_clear_pvp = resetOnNewPVP
end

function segmentClass:ResetOverallData()
	Details:CloseBreakdownWindow()

	Details:DestroyCombat(Details.tabela_overall)
	Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
	Details.tabela_overall = combatClass:NovaTabela()

	for index, instanceObject in ipairs(Details:GetAllInstances()) do
		if (instanceObject:IsEnabled()) then
			local segmentId = instanceObject:GetSegmentId()
			if (segmentId == DETAILS_SEGMENTID_OVERALL) then
				instanceObject:InstanceReset()
				instanceObject:ReajustaGump()
			end
		end
	end

	if (Details.schedule_add_to_overall) then --deprecated
		Details:Destroy(Details.schedule_add_to_overall)
	end

	--stop bar testing if any
	Details:StopTestBarUpdate()
	Details:ClockPluginTickOnSegment()
end

function segmentClass:ResetAllCombatData()
	if (Details.bosswindow) then
		Details.bosswindow:Reset()
	end

	--stop bar testing if any
	Details:StopTestBarUpdate()

	if (Details.tabela_vigente.verifica_combate) then --finaliza a checagem se esta ou n�o no combate
		Details:CancelTimer(Details.tabela_vigente.verifica_combate)
	end

	Details.last_closed_combat = nil

	--remove mythic dungeon schedules if any
	Details.schedule_mythicdungeon_trash_merge = nil
	Details.schedule_mythicdungeon_endtrash_merge = nil
	Details.schedule_mythicdungeon_overallrun_merge = nil

	--clear other schedules
	Details.schedule_flag_boss_components = nil
	Details.schedule_store_boss_encounter = nil
	--_detalhes.schedule_remove_overall = nil

	--fecha a janela de informa��es do jogador
	Details:CloseBreakdownWindow()

	--empty temporary tables
	Details.atributo_damage:ClearTempTables()

	for i = #Details.tabela_historico.tabelas, 1, -1 do
		---@type combat
		local combtaObjectRemoved = table.remove(Details.tabela_historico.tabelas, i)
		Details:DestroyCombat(combtaObjectRemoved)
		Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
	end

	--the current combat when finished will be moved to the first index of "tabela_historico.tabelas", need the check if the current combat was already destroyed
	if (not Details.tabela_vigente.__destroyed) then
		Details:DestroyCombat(Details.tabela_vigente)
		if (Details.tabela_vigente == Details.tabela_historico.tabelas[1]) then
			table.remove(Details.tabela_historico.tabelas, 1)
		end
		Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")
	end

	Details:DestroyCombat(Details.tabela_overall) --not creating a new one immediatelly
	Details:SendEvent("DETAILS_DATA_SEGMENTREMOVED")

	Details:Destroy(Details.spellcache)

	if (Details.schedule_add_to_overall) then --deprecated
		Details:Destroy(Details.schedule_add_to_overall)
	end

	Details:PetContainerCleanup()
	Details:ResetSpecCache(true)

	-- novo container de historico
	Details.tabela_historico = segmentClass:CreateNewSegmentDatabase() --joga fora a tabela antiga e cria uma nova
	-- nova tabela do overall e current
	Details.tabela_overall = combatClass:NovaTabela() --joga fora a tabela antiga e cria uma nova
	-- cria nova tabela do combate atual
	Details.tabela_vigente = combatClass:NovaTabela(nil, Details.tabela_overall)

	--novo container para armazenar pets
	Details.tabela_pets = Details.container_pets:NovoContainer()
	Details:UpdateContainerCombatentes()
	Details.container_pets:BuscarPets()

	---@type instance[]
	local allInstances = Details:GetAllInstances()

	for i = 1, #allInstances do
		---@type instance
		local instance = allInstances[i]
		if (instance:IsEnabled()) then
			Details:UpdateCombatObjectInUse(instance)
		end
	end

	--marca o addon como fora de combate
	Details.in_combat = false
	--zera o contador de combates
	Details:GetOrSetCombatId(0)

	--clear caches
	Details:ClearSpellCache()
	Details:Destroy(Details.ShieldCache)
	Details:Destroy(Details.cache_damage_group)
	Details:Destroy(Details.cache_healing_group)

	--reinicia a time machine
	Details222.TimeMachine.Restart()
	Details:UpdateParserGears()

	if (not InCombatLockdown() and not UnitAffectingCombat("player")) then
		--workarround for the "script run too long" issue while outside the combat lockdown
		local cleargarbage = function()
			collectgarbage()
		end
		local successful, errortext = pcall(cleargarbage)
		if (not successful) then
			Details:Msg("couldn't call collectgarbage()")
		end
	else
		Details.schedule_hard_garbage_collect = true
	end

	Details:InstanciaCallFunction(Details.UpdateCombatObjectInUse) -- atualiza o instancia.showing para as novas tabelas criadas
	Details:InstanciaCallFunction(Details.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
	Details:InstanciaCallFunction(Details.ResetaGump) --_detalhes:ResetaGump("de todas as instancias")
	Details:InstanciaCallFunction(Details.FadeHandler.Fader, "IN", nil, "barras")

	Details:RefreshMainWindow(-1) --atualiza todas as instancias

	Details:SendEvent("DETAILS_DATA_RESET", nil, nil)
end

function Details.refresh:r_historico(este_historico)
	setmetatable(este_historico, segmentClass)
	--este_historico.__index = historico
end

--[[
		elseif (_detalhes.trash_concatenate) then

			if (true) then
				return
			end

			if (_terceiro_combate) then
				if (_terceiro_combate.is_trash and _segundo_combate.is_trash and not _terceiro_combate.is_boss and not _segundo_combate.is_boss) then
					--tabela 2 deve ser deletada e somada a tabela 1
					if (_detalhes.debug) then
						detalhes:Msg("(debug) concatenating two trash segments.")
					end

					_segundo_combate = _segundo_combate + _terceiro_combate
					_detalhes.tabela_overall = _detalhes.tabela_overall - _terceiro_combate

					_segundo_combate.is_trash = true

					--verificar novamente a time machine
					for _, jogador in ipairs(_terceiro_combate [1]._ActorTable) do --damage
						Details222.TimeMachine.RemoveActor(jogador)
					end
					for _, jogador in ipairs(_terceiro_combate [2]._ActorTable) do --heal
						Details222.TimeMachine.RemoveActor(jogador)
					end
					--remover
					_table_remove(self.tabelas, 3)
					_detalhes:SendEvent("DETAILS_DATA_SEGMENTREMOVED", nil, nil)
				end
			end
--]]
