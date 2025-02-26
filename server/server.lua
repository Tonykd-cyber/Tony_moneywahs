ESX = exports["es_extended"]:getSharedObject()
local ox_inventory = exports.ox_inventory
 
RegisterNetEvent('Tonykd:add', function ()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'black_money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local metadata = {description = string.format(items)}
        ox_inventory:RemoveItem(src, 'black_money', items)
        ox_inventory:AddItem(src, 'blackmoney_box', 1, metadata)
end)

RegisterNetEvent('Tonykd:remove', function ()
    local src = source
    local blackmoneybox = ox_inventory:Search(source, 1, 'blackmoney_box')
    for k, v in pairs(blackmoneybox) do
 
        blackmoneybox = v
        break
    end
    print(blackmoneybox.metadata.description)
    ox_inventory:AddItem(src, 'money', blackmoneybox.metadata.description)
    ox_inventory:RemoveItem(src, 'blackmoney_box', 1)
end)  


ESX.RegisterServerCallback("Tonykd:getPOLICECount", function(source, cb)
	local policeCount = 0
	local xPlayers = ESX.GetExtendedPlayers('job', 'police')
	for _, xPlayer in pairs(xPlayers) do
		policeCount = policeCount + 1
	end
    cb(policeCount)
	 
end)



 
 