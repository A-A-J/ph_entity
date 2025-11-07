lib.addCommand('edebug', {
    help = locale('command.edebug.help'),
    restricted = 'group.admin'
}, function(source)
    TriggerClientEvent('ph_select_entity:toggle', source)
end)

