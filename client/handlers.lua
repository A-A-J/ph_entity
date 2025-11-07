local Config = require 'shared.config'

enabled = false
selectedEntity = nil
lastEntity = nil
lastInfoUpdate = 0

RegisterNUICallback('copyToClipboard', function(data, cb)
	if data and data.text then
		lib.setClipboard(data.text)
		UI.sendEntityInfoToUI(nil)
	end
	cb('ok')
end)

RegisterNetEvent('ph_select_entity:toggle', function()
	enabled = not enabled
	if not enabled then
		Utils.removeBall()
		selectedEntity = nil
		if lastEntity and DoesEntityExist(lastEntity) then
			FreezeEntityPosition(lastEntity, false)
		end
		lastEntity = nil
		UI.sendEntityInfoToUI(nil)
		SetNuiFocus(false, false)
	else
		RequestModel(Config.TennisModel)
		while not HasModelLoaded(Config.TennisModel) do
			Wait(10)
		end
		SetNuiFocus(false, false)
	end
end)

