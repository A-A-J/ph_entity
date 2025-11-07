local function getEntityType(entity)
	if not entity or entity == 0 then
		return "Unknown"
	end

	if not DoesEntityExist(entity) then
		return "Unknown"
	end

	local success, result = pcall(function()
		if not DoesEntityExist(entity) then
			return "Unknown"
		end
		
		if IsEntityAPed(entity) then
			return "Ped"
		elseif IsEntityAVehicle(entity) then
			return "Vehicle"
		elseif IsEntityAnObject(entity) then
			return "Object"
		else
			return "Unknown"
		end
	end)

	return success and result or "Unknown"
end

local function getEntityInfo(entity)
	if not entity or entity == 0 then
		return nil
	end

	if not DoesEntityExist(entity) then
		return nil
	end

	local success, result = pcall(function()
		if not DoesEntityExist(entity) then
			return nil
		end

		local entityType = getEntityType(entity)
		if not entityType or entityType == "Unknown" then
			if not DoesEntityExist(entity) then
				return nil
			end
		end

		local model = 0
		local coords = vector3(0, 0, 0)
		local heading = 0.0
		local rotation = vector3(0, 0, 0)

		if not DoesEntityExist(entity) then
			return nil
		end
		
		local modelSuccess, modelResult = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			local isValid = false
			local checkSuccess = pcall(function()
				isValid = IsEntityAPed(entity) or IsEntityAVehicle(entity) or IsEntityAnObject(entity)
			end)
			if not checkSuccess or not isValid then
				return nil
			end
			return GetEntityModel(entity)
		end)
		if not modelSuccess or not modelResult or modelResult == 0 then
			return nil
		end
		model = modelResult

		if not DoesEntityExist(entity) then
			return nil
		end
		local coordsSuccess, coordsResult = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			return GetEntityCoords(entity)
		end)
		if not coordsSuccess or not coordsResult then
			return nil
		end
		coords = coordsResult

		if not DoesEntityExist(entity) then
			return nil
		end
		local headingSuccess, headingResult = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			return GetEntityHeading(entity)
		end)
		if not headingSuccess or not headingResult then
			return nil
		end
		heading = headingResult

		if not DoesEntityExist(entity) then
			return nil
		end
		local rotationSuccess, rotationResult = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			return GetEntityRotation(entity, 2)
		end)
		if not rotationSuccess or not rotationResult then
			return nil
		end
		rotation = rotationResult

		if not DoesEntityExist(entity) then
			return nil
		end
		local propsSuccess, propsResult = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			return {
				attachedTo = GetEntityAttachedTo(entity),
				isFrozen = IsEntityPositionFrozen(entity),
				isVisible = IsEntityVisible(entity),
				health = GetEntityHealth(entity),
				maxHealth = GetEntityMaxHealth(entity),
				velocity = GetEntityVelocity(entity)
			}
		end)
		if not propsSuccess or not propsResult then
			return nil
		end
		
		attachedTo = propsResult.attachedTo
		isFrozen = propsResult.isFrozen
		isVisible = propsResult.isVisible
		health = propsResult.health
		maxHealth = propsResult.maxHealth
		velocity = propsResult.velocity
		speed = math.sqrt(velocity.x ^ 2 + velocity.y ^ 2 + velocity.z ^ 2) * 3.6

		return {
			entityType = entityType,
			model = model,
			coords = coords,
			heading = heading,
			rotation = rotation,
			attachedTo = attachedTo,
			isFrozen = isFrozen,
			isVisible = isVisible,
			health = health,
			maxHealth = maxHealth,
			velocity = velocity,
			speed = speed
		}
	end)

	if not success or not result then
		return nil
	end

	local entityType = result.entityType
	local model = result.model
	local coords = result.coords
	local heading = result.heading
	local rotation = result.rotation
	local attachedTo = result.attachedTo
	local isFrozen = result.isFrozen
	local isVisible = result.isVisible
	local health = result.health
	local maxHealth = result.maxHealth
	local velocity = result.velocity
	local speed = result.speed

	local networkId = nil
	local networkIdSuccess = pcall(function()
		if DoesEntityExist(entity) then
			networkId = NetworkGetNetworkIdFromEntity(entity)
		end
	end)
	
	local info = {
		type = entityType,
		handle = entity,
		model = model,
		modelName = "",
		coords = coords,
		heading = heading,
		rotation = rotation,
		attachedTo = attachedTo,
		isFrozen = isFrozen,
		isVisible = isVisible,
		health = health,
		maxHealth = maxHealth,
		speed = speed,
		velocity = velocity,
		network_id = networkId
	}

	local modelNameSuccess, modelName = pcall(function()
		return GetEntityArchetypeName(entity)
	end)
	if modelNameSuccess and modelName then
		info.modelName = modelName
	end

	if entityType == "Vehicle" then
		local vehSuccess, vehInfo = pcall(function()
			if not DoesEntityExist(entity) then
				return nil
			end
			
			local extrasCount = 0
			local enabledExtras = 0
			for i = 0, 20 do
				if DoesExtraExist(entity, i) then
					extrasCount = extrasCount + 1
					if IsVehicleExtraTurnedOn(entity, i) then
						enabledExtras = enabledExtras + 1
					end
				end
			end
			
			local passengers = {}
			local passengerCount = 0
			local maxPassengers = GetVehicleMaxNumberOfPassengers(entity)
			for i = -1, maxPassengers - 1 do
				local ped = GetPedInVehicleSeat(entity, i)
				if ped and ped ~= 0 and DoesEntityExist(ped) then
					passengerCount = passengerCount + 1
					table.insert(passengers, ped)
				end
			end
			
			local livery = -1
			local liveryCount = 0
			local liveryName = ""
			local liverySuccess = pcall(function()
				livery = GetVehicleLivery(entity)
				liveryCount = GetVehicleLiveryCount(entity)
				if livery >= 0 and liveryCount > 0 then
					local liveryLabel = GetLiveryName(entity, livery)
					if liveryLabel and liveryLabel ~= 0 then
						liveryName = GetLabelText(liveryLabel)
					end
				end
			end)
			
			local vehicleClass = GetVehicleClass(entity)
			local vehicleClassName = ""
			local classNames = {
				[0] = "Compact",
				[1] = "Sedan",
				[2] = "SUV",
				[3] = "Coupe",
				[4] = "Muscle",
				[5] = "Sports Classic",
				[6] = "Sports",
				[7] = "Super",
				[8] = "Motorcycle",
				[9] = "Off-road",
				[10] = "Industrial",
				[11] = "Utility",
				[12] = "Van",
				[13] = "Cycle",
				[14] = "Boat",
				[15] = "Helicopter",
				[16] = "Plane",
				[17] = "Service",
				[18] = "Emergency",
				[19] = "Military",
				[20] = "Commercial",
				[21] = "Train"
			}
			vehicleClassName = classNames[vehicleClass] or "Unknown"
			
			local numDoors = GetNumberOfVehicleDoors(entity)
			
			return {
				plate = GetVehicleNumberPlateText(entity),
				plateIndex = GetVehicleNumberPlateTextIndex(entity),
				bodyHealth = GetVehicleBodyHealth(entity),
				engineHealth = GetVehicleEngineHealth(entity),
				fuelLevel = GetVehicleFuelLevel(entity),
				dirtLevel = GetVehicleDirtLevel(entity),
				vehicleClass = vehicleClass,
				vehicleClassName = vehicleClassName,
				numSeats = GetVehicleModelNumberOfSeats(model) - 1,
				numDoors = numDoors,
				maxPassengers = maxPassengers,
				passengerCount = passengerCount,
				extrasCount = extrasCount,
				enabledExtras = enabledExtras,
				livery = livery,
				liveryCount = liveryCount,
				liveryName = liveryName,
				isEngineOn = GetIsVehicleEngineRunning(entity),
				isLocked = GetVehicleDoorLockStatus(entity) == 2
			}
		end)
		if vehSuccess and vehInfo then
			info.plate = vehInfo.plate
			info.plateIndex = vehInfo.plateIndex
			info.bodyHealth = vehInfo.bodyHealth
			info.engineHealth = vehInfo.engineHealth
			info.fuelLevel = vehInfo.fuelLevel
			info.dirtLevel = vehInfo.dirtLevel
			info.vehicleClass = vehInfo.vehicleClass
			info.vehicleClassName = vehInfo.vehicleClassName
			info.numSeats = vehInfo.numSeats
			info.numDoors = vehInfo.numDoors
			info.maxPassengers = vehInfo.maxPassengers
			info.passengerCount = vehInfo.passengerCount
			info.extrasCount = vehInfo.extrasCount
			info.enabledExtras = vehInfo.enabledExtras
			info.livery = vehInfo.livery
			info.liveryCount = vehInfo.liveryCount
			info.liveryName = vehInfo.liveryName
			info.isEngineOn = vehInfo.isEngineOn
			info.isLocked = vehInfo.isLocked
		end
	end

	if entityType == "Ped" then
		local pedSuccess, pedInfo = pcall(function()
			local isPlayer = IsPedAPlayer(entity)
			local playerId = nil
			local networkId = nil
			if isPlayer then
				local playerIndex = NetworkGetPlayerIndexFromPed(entity)
				if playerIndex ~= -1 then
					playerId = GetPlayerServerId(playerIndex)
					networkId = NetworkGetNetworkIdFromEntity(entity)
				end
			end
			return {
				isPlayer = isPlayer,
				playerId = playerId,
				networkId = networkId,
				armour = GetPedArmour(entity),
				isDead = IsPedDeadOrDying(entity, true),
				isInVehicle = IsPedInAnyVehicle(entity, false),
				vehicle = IsPedInAnyVehicle(entity, false) and GetVehiclePedIsIn(entity, false) or nil
			}
		end)
		if pedSuccess then
			info.isPlayer = pedInfo.isPlayer
			info.playerId = pedInfo.playerId
			info.network_id = pedInfo.networkId
			info.armour = pedInfo.armour
			info.isDead = pedInfo.isDead
			info.isInVehicle = pedInfo.isInVehicle
			info.vehicle = pedInfo.vehicle
		end
	end

	return info
end

Entity = {
	getEntityType = getEntityType,
	getEntityInfo = getEntityInfo
}

return Entity

