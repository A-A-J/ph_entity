local function sendEntityInfoToUI(info)
	if not info then
		SendNUIMessage({
			action = 'hideEntityInfo'
		})
		return
	end
	
	local localeData = {
		title = locale('title'),
		entity = locale('ui.entity'),
		type = locale('ui.type'),
		network_id = locale('ui.network_id'),
		model_hash = locale('ui.model_hash'),
		coordinates = locale('ui.coordinates'),
		rotation = locale('ui.rotation'),
		heading = locale('ui.heading'),
		speed = locale('ui.speed'),
		health = locale('ui.health'),
		plate = locale('ui.plate'),
		class = locale('ui.class'),
		doors = locale('ui.doors'),
		seats = locale('ui.seats'),
		passengers = locale('ui.passengers'),
		extras = locale('ui.extras'),
		livery = locale('ui.livery'),
		body_health = locale('ui.body_health'),
		engine_health = locale('ui.engine_health'),
		fuel_level = locale('ui.fuel_level'),
		is_player = locale('ui.is_player'),
		player_id = locale('ui.player_id'),
		armour = locale('ui.armour'),
		actions = {
			copy_model = locale('ui.actions.copy_model'),
			copy_coords = locale('ui.actions.copy_coords'),
			copy_rotation = locale('ui.actions.copy_rotation'),
			copy_heading = locale('ui.actions.copy_heading'),
			copy_all = locale('ui.actions.copy_all')
		}
	}
	
	SendNUIMessage({
		action = 'showEntityInfo',
		entityInfo = info,
		locale = localeData
	})
end

UI = {
	sendEntityInfoToUI = sendEntityInfoToUI
}

return UI

