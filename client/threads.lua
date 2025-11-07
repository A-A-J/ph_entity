local Config = require 'shared.config'

CreateThread(function()
	while true do
		Wait(0)
		
		if enabled and selectedEntity and DoesEntityExist(selectedEntity) then
			if IsControlJustPressed(0, 47) then
				local info = Entity.getEntityInfo(selectedEntity)
				if info then
					lib.setClipboard(tostring(info.model))
					UI.sendEntityInfoToUI(nil)
				end
			elseif IsControlJustPressed(0, 38) then
				local info = Entity.getEntityInfo(selectedEntity)
				if info and info.coords then
					local text = string.format("vector3(%.3f, %.3f, %.3f)", info.coords.x, info.coords.y, info.coords.z)
					lib.setClipboard(text)
					UI.sendEntityInfoToUI(nil)
				end
			elseif IsControlJustPressed(0, 45) then
				local info = Entity.getEntityInfo(selectedEntity)
				if info and info.rotation then
					local text = string.format("vector3(%.2f, %.2f, %.2f)", info.rotation.x, info.rotation.y, info.rotation.z)
					lib.setClipboard(text)
					UI.sendEntityInfoToUI(nil)
				end
			elseif IsControlJustPressed(0, 36) then
				local info = Entity.getEntityInfo(selectedEntity)
				if info and info.heading then
					lib.setClipboard(string.format("%.3f", info.heading))
					UI.sendEntityInfoToUI(nil)
				end
			elseif IsControlJustPressed(0, 20) then
				local info = Entity.getEntityInfo(selectedEntity)
				if info then
					local text = ""
					
					text = text .. string.format("%s: %s\n", locale('ui.entity'), tostring(info.handle))
					text = text .. string.format("%s: %s\n", locale('ui.type'), info.type)
					if info.network_id then
						text = text .. string.format("%s: %s\n", locale('ui.network_id'), tostring(info.network_id))
					end
					text = text .. string.format("%s: %s\n", locale('ui.model_hash'), tostring(info.model))
					if info.modelName and info.modelName ~= "" then
						text = text .. string.format("Model Name: %s\n", info.modelName)
					end
					if info.coords then
						text = text .. string.format("%s: vector3(%.3f, %.3f, %.3f)\n", 
							locale('ui.coordinates'), info.coords.x, info.coords.y, info.coords.z)
					end
					if info.rotation then
						text = text .. string.format("%s: vector3(%.2f, %.2f, %.2f)\n", 
							locale('ui.rotation'), info.rotation.x, info.rotation.y, info.rotation.z)
					end
					if info.heading then
						text = text .. string.format("%s: %.3f\n", locale('ui.heading'), info.heading)
					end
					if info.speed then
						text = text .. string.format("%s: %.2f km/h\n", locale('ui.speed'), info.speed)
					end
					if info.health and info.maxHealth then
						text = text .. string.format("%s: %s / %s\n", locale('ui.health'), tostring(info.health), tostring(info.maxHealth))
					end
					text = text .. string.format("Frozen: %s\n", tostring(info.isFrozen))
					text = text .. string.format("Visible: %s\n", tostring(info.isVisible))
					if info.attachedTo and info.attachedTo ~= 0 then
						text = text .. string.format("Attached To: %s\n", tostring(info.attachedTo))
					end
					
					if info.type == "Vehicle" then
						text = text .. "\n--- Vehicle Info ---\n"
						if info.plate then
							text = text .. string.format("%s: %s\n", locale('ui.plate'), info.plate)
						end
						if info.vehicleClassName then
							text = text .. string.format("%s: %s (Class %s)\n", locale('ui.class'), info.vehicleClassName, tostring(info.vehicleClass or 0))
						end
						if info.numDoors then
							text = text .. string.format("%s: %s\n", locale('ui.doors'), tostring(info.numDoors))
						end
						if info.numSeats then
							text = text .. string.format("%s: %s\n", locale('ui.seats'), tostring(info.numSeats))
						end
						if info.passengerCount and info.maxPassengers then
							text = text .. string.format("%s: %s / %s\n", locale('ui.passengers'), tostring(info.passengerCount), tostring(info.maxPassengers))
						end
						if info.extrasCount and info.enabledExtras then
							text = text .. string.format("%s: %s / %s\n", locale('ui.extras'), tostring(info.enabledExtras), tostring(info.extrasCount))
						end
						if info.livery and info.livery >= 0 and info.liveryCount > 0 then
							local liveryText = tostring(info.livery)
							if info.liveryName and info.liveryName ~= "NULL" and info.liveryName ~= "" then
								liveryText = liveryText .. " (" .. info.liveryName .. ")"
							end
							liveryText = liveryText .. " / " .. tostring(info.liveryCount)
							text = text .. string.format("%s: %s\n", locale('ui.livery'), liveryText)
						end
						if info.bodyHealth then
							text = text .. string.format("%s: %.1f\n", locale('ui.body_health'), info.bodyHealth)
						end
						if info.engineHealth then
							text = text .. string.format("%s: %.1f\n", locale('ui.engine_health'), info.engineHealth)
						end
						if info.fuelLevel then
							text = text .. string.format("%s: %.1f\n", locale('ui.fuel_level'), info.fuelLevel)
						end
						if info.dirtLevel then
							text = text .. string.format("Dirt Level: %.2f\n", info.dirtLevel)
						end
						text = text .. string.format("Engine On: %s\n", tostring(info.isEngineOn))
						text = text .. string.format("Locked: %s\n", tostring(info.isLocked))
					end
					
					if info.type == "Ped" then
						text = text .. "\n--- Ped Info ---\n"
						text = text .. string.format("%s: %s\n", locale('ui.is_player'), tostring(info.isPlayer))
						if info.playerId then
							text = text .. string.format("%s: %s\n", locale('ui.player_id'), tostring(info.playerId))
						end
						if info.armour then
							text = text .. string.format("%s: %s\n", locale('ui.armour'), tostring(info.armour))
						end
						if info.isDead ~= nil then
							text = text .. string.format("Is Dead: %s\n", tostring(info.isDead))
						end
						if info.isInVehicle ~= nil then
							text = text .. string.format("In Vehicle: %s\n", tostring(info.isInVehicle))
							if info.vehicle then
								text = text .. string.format("Vehicle Handle: %s\n", tostring(info.vehicle))
							end
						end
					end
					
					lib.setClipboard(text)
					UI.sendEntityInfoToUI(nil)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)

		if enabled then
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)

			local hitCoords, hitEntity = Utils.raycastFromCamera()

			if hitCoords then
				local placed = vector3(hitCoords.x, hitCoords.y, hitCoords.z - 0.03)
				Utils.placeBallAt(placed)

				if hitEntity and hitEntity ~= 0 and hitEntity ~= PlayerPedId() and hitEntity ~= ball then
					local isValidEntity = false
					if DoesEntityExist(hitEntity) then
						local checkSuccess, checkResult = pcall(function()
							return IsEntityAPed(hitEntity) or IsEntityAVehicle(hitEntity) or IsEntityAnObject(hitEntity)
						end)
						if checkSuccess and checkResult then
							local modelCheckSuccess, modelCheckResult = pcall(function()
								if not DoesEntityExist(hitEntity) then
									return false
								end
								local model = GetEntityModel(hitEntity)
								return model ~= nil and model ~= 0
							end)
							if modelCheckSuccess and modelCheckResult then
								isValidEntity = true
							end
						end
					end
					
					if isValidEntity then
						selectedEntity = hitEntity
						
						if lastEntity ~= selectedEntity then
							if lastEntity and DoesEntityExist(lastEntity) then
								FreezeEntityPosition(lastEntity, false)
							end
							if DoesEntityExist(selectedEntity) then
								FreezeEntityPosition(selectedEntity, true)
							end
							lastEntity = selectedEntity
						end
					else
						selectedEntity = nil
						if lastEntity and DoesEntityExist(lastEntity) then
							FreezeEntityPosition(lastEntity, false)
							lastEntity = nil
						end
					end
				else
					selectedEntity = nil
					if lastEntity and DoesEntityExist(lastEntity) then
						FreezeEntityPosition(lastEntity, false)
						lastEntity = nil
					end
				end
			else
				selectedEntity = nil
				if lastEntity and DoesEntityExist(lastEntity) then
					FreezeEntityPosition(lastEntity, false)
					lastEntity = nil
				end
			end

			local currentTime = GetGameTimer()
			if currentTime - lastInfoUpdate >= Config.InfoUpdateInterval then
				lastInfoUpdate = currentTime

				if selectedEntity and selectedEntity ~= 0 then
					if DoesEntityExist(selectedEntity) then
						local info = Entity.getEntityInfo(selectedEntity)
						if info then
							UI.sendEntityInfoToUI(info)
						else
							selectedEntity = nil
							UI.sendEntityInfoToUI(nil)
						end
					else
						selectedEntity = nil
						if lastEntity and DoesEntityExist(lastEntity) then
							FreezeEntityPosition(lastEntity, false)
						end
						lastEntity = nil
						UI.sendEntityInfoToUI(nil)
					end
				else
					UI.sendEntityInfoToUI(nil)
				end
			end
		else
			Wait(250)
		end
	end
end)

