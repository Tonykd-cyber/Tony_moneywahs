ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory
local ox_target = exports.ox_target
local drawZones = true
local hasjob = false
lib.locale()

ox_target:addBoxZone({

    coords = vec3(-3180.8682, 1074.8475, 25.4841),
    size = vec3(2, 2, 2),
    rotation = 152.1132,
    debug = false,
    drawSprite = true,
    options = {
        {
            name = 'Tonykd_start',
			event = "Tonykd:start",
			icon = "fas fa-laptop-code",
			label = locale("A1"),
        }
    }
})

RegisterNetEvent("Tonykd:start")
AddEventHandler("Tonykd:start", function()
    ESX.TriggerServerCallback("Tonykd:getPOLICECount", function(cb)
        policeCount = cb
		print(policeCount)
			if policeCount >= Config.policeCount  then	
				local blackmoney = ox_inventory:Search('count', 'black_money') 
				if  blackmoney >= 1  then 
					if  hasjob then
								local alert2 = lib.alertDialog({
									header = locale('A2'),
									content = locale('A3'),
									centered = true,
									cancel = true
								})
								if alert2 == 'confirm' then
									Removeped()
									RemoveBlip(Pedblip)
									hasjob = false
								end

					else
							local alert = lib.alertDialog({
								header = locale('A4'),
								content = locale('A5'),
								centered = true,
								cancel = true
							})
						if alert == 'confirm' then
							if lib.progressBar({
								label = locale('A6'),
								duration = 1000,
								position = 'bottom',
								useWhileDead = false,
								canCancel = false,
								disable = { car = true, move = true, combat = true },
								anim = { dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab' },
								prop = { model = 'p_ld_heist_bag_s', bone = 40269, pos = vec3(0.0454, 0.2131, -0.1887), rot = vec3(66.4762, 7.2424, -71.9051) }
							}) then 
								TriggerEvent("Tonykd:go")
								TriggerServerEvent('Tonykd:add')
									lib.defaultNotify({
										title = locale('A4'),
										description = locale('A7'),
										duration = 7000,
										status = 'success'
									})
								hasjob = true	
							end		
						end
					end
				else
					lib.notify({
						title = locale('A8'), 
						type = 'error'
					}) 
				end	
			else
				lib.notify({
					title = locale('A16'), 
					type = 'error'
				}) 		
			end	
	end)

end)
RegisterNetEvent("Tonykd:go")
AddEventHandler("Tonykd:go", function()

		location = Config.PedLocations[math.random(#Config.PedLocations)]
		Pedblip = AddBlipForCoord(location.x, location.y, location.z)
		SetBlipSprite(Pedblip, 801)
		SetBlipColour(Pedblip, Config.LocationColour)
		BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locale('A9'))
        EndTextCommandSetBlipName(Pedblip)
		SetBlipRoute(Pedblip, true)
		Spawnped()

		if ESX.PlayerData.job.name == 'police' then
			lib.notify({
				id = '911',
				title = locale('A10'), 
				description = locale('A11'), 
				position = 'top',
				duration = 30000,
			 
				icon = 'fa-solid fa-handcuffs',
				iconColor = '#ffffff'
			})
 			police911 = AddBlipForCoord(vector3(location.x+30, location.y+30, location.z+30))
			SetBlipSprite(police911 , 161)
			SetBlipScale(police911 , 3.0)
			SetBlipColour(police911, 3)
			PulseBlip(police911)
			Wait(100000)
			RemoveBlip(police911)
		end
 
end)

ox_target:addModel(Config.Ped, {
	{
		name = 'igclaypain_model',
		event = "Tonykd:del", 
		icon = "fas fa-box",
		label = locale('A12'), 
	}
})
 
RegisterNetEvent("Tonykd:del")
AddEventHandler("Tonykd:del", function()

	  local playerPed = PlayerPedId()
	  local playerCoords = GetEntityCoords(playerPed)
	  local modelFilter = {GetHashKey("ig_claypain")}
	  local closestPed, closestDistance = ESX.Game.GetClosestPed(playerCoords, modelFilter)
	  if closestPed  and  hasjob then
		if lib.progressBar({
            label = locale('A13'), 
            duration = 30000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = { car = true, move = true, combat = true },
			anim = { dict = 'special_ped@jane@monologue_5@monologue_5c', clip = 'brotheradrianhasshown_2' },
			prop = { model = 'h4_prop_h4_cash_bag_01a', bone = 28422, pos = vec3(0.12, 0.00, -0.01), rot = vec3(0.1, -360, 90) }
		}) then 
			RemoveBlip(Pedblip)
			Removeped()
			lib.defaultNotify({
				title = locale('A4'), 
				description = locale('A14'), 
				duration = 7000,
				status = 'success'
			})
			hasjob = false
			TriggerServerEvent('Tonykd:remove')
			Timeouttarget() 
		end
	 else
			Timeouttarget()
			lib.notify({
				title = locale('A4'),
				description = locale('A15'),
				duration = 7000,
				type = 'success'
			})
	  end
end)
 
function Timeouttarget()

	ox_target:removeModel('ig_claypain', 'igclaypain_model')
	local Timeout = ESX.SetTimeout(50000, function()
	  ox_target:addModel(Config.Ped, {
		  {
			  name = 'igclaypain_model',
			  event = "Tonykd:del", 
			  icon = "fas fa-box",
			  label = locale('A12'),
		  }
	  })
	end)
	
end	

function Spawnped()

	local PedHash = Config.Ped[math.random(#Config.Ped)]
	RequestModel(PedHash)
	while not HasModelLoaded(PedHash) do
		Citizen.Wait(0)
	end
	Pedgus = CreatePed(0, PedHash, location.x, location.y, location.z-1.0, location.w, false, true)
	FreezeEntityPosition(Pedgus, true)
	SetEntityInvincible(Pedgus, true)
	SetPedKeepTask(Pedgus, true)
	SetBlockingOfNonTemporaryEvents(Pedgus, true)

end 

function Removeped()

	SetPedKeepTask(Pedgus, false)
	ClearPedTasks(Pedgus)
	SetPedAsNoLongerNeeded(Pedgus)
	FreezeEntityPosition(Pedgus, false)
	SetPedComponentVariation(Pedgus, 5, 26, 13, 0)
	
end

 