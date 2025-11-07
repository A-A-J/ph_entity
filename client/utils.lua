local Config = require 'shared.config'

ball = nil

local function rotToDir(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function placeBallAt(coords)
	if not ball or not DoesEntityExist(ball) then
		ball = CreateObjectNoOffset(Config.TennisModel, coords.x, coords.y, coords.z, false, false, false)
		SetEntityCollision(ball, false, false)
		FreezeEntityPosition(ball, true)
		SetEntityInvincible(ball, true)
		SetEntityAsMissionEntity(ball, true, true)
	else
		SetEntityCoordsNoOffset(ball, coords.x, coords.y, coords.z, false, false, true)
	end
end

local function removeBall()
	if ball and DoesEntityExist(ball) then
		DeleteObject(ball)
		ball = nil
	end
end

local function raycastFromCamera()
	local camCoords = GetGameplayCamCoord()
	local camRot = GetGameplayCamRot(2)
	local dir = rotToDir(camRot)
	local farCoords = camCoords + dir * 200.0

	local handle = StartShapeTestRay(
		camCoords.x, camCoords.y, camCoords.z,
		farCoords.x, farCoords.y, farCoords.z,
		-1, PlayerPedId(), 7
	)
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
	if hit and endCoords and entityHit and entityHit ~= 0 then
		return endCoords, entityHit
	end
	return nil, nil
end

Utils = {
	ball = ball,
	placeBallAt = placeBallAt,
	removeBall = removeBall,
	raycastFromCamera = raycastFromCamera
}

return Utils

