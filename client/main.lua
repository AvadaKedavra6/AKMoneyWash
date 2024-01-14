-- [[ Client file ]] --

-- // ESX var \\ --
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    end
    if ESX.IsPlayerLoaded() then

        ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

-- // Menu Var \\ --
local open = false
local _S = MoneyWash.Strings
local SliderPannel = {
    Minimum = 0,
    Index = 0,
}
local loading = 0
local blackMoney = 0
local washMenu = RageUI.CreateMenu(MoneyWash.Interaction.Wash.nameMenu, MoneyWash.Interaction.Wash.descMenu, nil, nil,MoneyWash.Interaction.Wash.TextureDictionary, MoneyWash.Interaction.Wash.TextureName)
local progressMenu = RageUI.CreateSubMenu(washMenu, MoneyWash.Interaction.Wash.nameMenu, MoneyWash.Interaction.Wash.descMenu)

-- DISPLAY GLARE OFF
washMenu.Display.Glare = false
washMenu.EnableMouse = true
progressMenu.Display.Glare = false

-- DISPLAY GLARE OFF
washMenu.Closed = function()
    SliderPannel.Index = 0
	open = false 
    FreezeEntityPosition(PlayerPedId(), false)
end

local Animation = MoneyWash.Animation

-- // Function GetBlackMoney \\ --
function GetBlackMoney()
    ESX.TriggerServerCallback("tnMoneyWash:GetMoney", function(dataMoney)
        blackMoney = dataMoney
    end)
end

-- // Function Digits \\ --
function Digits(a)
    return ESX.Math.GroupDigits(a)
end

local BikerCounterfeit = exports[MoneyWash.IPLResourceName]:GetBikerCounterfeitObject()

-- // Function Dryer \\ --
function ChangeDryer(status)
    Citizen.CreateThread(function()
        if status then
            BikerCounterfeit.Dryer1.Set(BikerCounterfeit.Dryer1.off)
            RefreshInterior(BikerCounterfeit.interiorId)
            Citizen.Wait(1000)
            BikerCounterfeit.Dryer1.Set(BikerCounterfeit.Dryer1.on)
            RefreshInterior(BikerCounterfeit.interiorId)
        else 
            BikerCounterfeit.Dryer1.Set(BikerCounterfeit.Dryer1.off)
            RefreshInterior(BikerCounterfeit.interiorId)
            Citizen.Wait(1000)
            BikerCounterfeit.Dryer1.Set(BikerCounterfeit.Dryer1.open)
            RefreshInterior(BikerCounterfeit.interiorId)
        end
    end)
end

RegisterNetEvent('tnMoneyWash:ChangeDryer')
AddEventHandler('tnMoneyWash:ChangeDryer', function(status)
    ChangeDryer(status)
end)

-- // Check If Player Wash \\ --
local PlayerIsWashing = true 
function GetIfPlayerIsWashing()
    ESX.TriggerServerCallback("tnMoneyWash:GetIfPlayerIsWashing", function(dataStatus)
        PlayerIsWashing = dataStatus
    end)
end

RegisterNetEvent('tnMoneyWash:SetIfPlayerIsWashingForClient')
AddEventHandler('tnMoneyWash:SetIfPlayerIsWashingForClient', function(status)
    PlayerIsWashing = status
end)

-- // Open Menu \\ --
function OpenWashMenu()
    GetIfPlayerIsWashing()
	if open then 
		open = false 
		RageUI.Visible(washMenu, false)
		return 
	else
		open = true 
		RageUI.Visible(washMenu, true)
		Citizen.CreateThread(function()
			while open do 

                -- // Main Menu \\ --
				RageUI.IsVisible(washMenu, function()
                    if blackMoney > 0 then
                        if not PlayerIsWashing then 
                            if SliderPannel.Index > 0 then
                                RageUI.Button(_S['Launder'], nil, { RightLabel = "→" }, true, {
                                onSelected = function()
                                    ESX.Streaming.RequestAnimDict(Animation.Dict, function()

                                        --TaskPlayAnim(PlayerPedId(), Animation.Dict, Animation.Name, 1.0, -1.0, 15000, 1, 1, true, true, true)
                                        local pos = MoneyWash.Positions.Wash
                                        TaskPlayAnimAdvanced(PlayerPedId(), Animation.Dict, Animation.Name, pos.x, pos.y-0.5, pos.z, 0.0, 0.0, 0.0, 1.0, -1.0, 15000, 1, 1, true, true, true)
                                    end)

                                    FreezeEntityPosition(PlayerPedId(), true)
                                    washMenu.Closable = false

                                    TriggerServerEvent('tnMoneyWash:ChangeDryerToAll', true)
                                    TriggerServerEvent('tnMoneyWash:SetIfPlayerIsWashing', true)
                                end
                                }, progressMenu)
                            else
                                    RageUI.Button(_S['Launder'], nil, {}, false, {})
                            end

                            RageUI.Separator((_S['MoneyToLaunder']):format(Digits(SliderPannel.Index)))
                            RageUI.Separator((_S['MoneyLaundered']):format(Digits(math.floor(SliderPannel.Index - Round(SliderPannel.Index * (MoneyWash.Percentage/100))))))
                            RageUI.SliderPanel(SliderPannel.Index, SliderPannel.Minimum, _S['Quantity'], blackMoney, {
                                onSliderChange = function(Index)
                                    SliderPannel.Index = Index
                            end
                            }, 1)
                        else 
                            RageUI.Separator("")
                            RageUI.Separator(_S['SomeoneUsesThisMachine'])
                            RageUI.Separator("")
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~".._S['NotEnoughBlackMoney'])
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(progressMenu, function()
                    RageUI.PercentagePanel(loading, (_S['Progress']):format(math.floor(loading*100)), "", "", {})
                    if loading < 1.0 then
                        progressMenu.Closable = false
                        loading = loading + 0.001
                    else loading = 0 end
                    if loading >= 1.0 then
                        progressMenu.Closable = true
                        washMenu.Closable = true
                        RageUI.CloseAll()
                        open = false
                        loading = 0
                        FreezeEntityPosition(PlayerPedId(), false) 
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent('tnMoneyWash:Wash', SliderPannel.Index, math.floor(SliderPannel.Index - Round(SliderPannel.Index * (MoneyWash.Percentage/100))))
                        
                        TriggerServerEvent('tnMoneyWash:ChangeDryerToAll', false)
                        TriggerServerEvent('tnMoneyWash:SetIfPlayerIsWashing', false)
                    end
                end)
				Wait(0)
			end
		end)
	end
end

-- // Wash Position \\ --
Citizen.CreateThread(function()
    while true do
    local wait = 1000
  
        local plyCoords = GetEntityCoords(PlayerPedId(), false)       
        local dist = #(plyCoords-MoneyWash.Positions.Wash)
  
         
        if dist <= MoneyWash.Interaction.Wash.markerDist then
        wait = 0
        if MoneyWash.Interaction.Wash.marker then
          DrawMarker(MoneyWash.Marker.type, MoneyWash.Positions.Wash.x, MoneyWash.Positions.Wash.y, MoneyWash.Positions.Wash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, MoneyWash.Marker.R, MoneyWash.Marker.G, MoneyWash.Marker.B, 255, 0, 1, 2, 1, nil, nil, 0)
        end
     
          if dist <= MoneyWash.Interaction.Wash.interactDistance then
          wait = 0
          --Visual.Subtitle(MoneyWash.Interaction.Wash.notif, 1)
          ESX.ShowHelpNotification(MoneyWash.Interaction.Wash.notif, false, false, 1)
          if IsControlJustPressed(1,51) then
            RageUI.CloseAll() 
            GetIfPlayerIsWashing()
            OpenWashMenu()
            GetBlackMoney()
            SliderPannel.Index = 0
            FreezeEntityPosition(PlayerPedId(), true)
          end
        end
          end
    Citizen.Wait(wait)
    end
end)

-- // Enter Position \\ --
Citizen.CreateThread(function()
    while true do
    local wait = 1000
  
        local plyCoords = GetEntityCoords(PlayerPedId(), false)       
        local dist = #(plyCoords-MoneyWash.Positions.Enter)
  
         
        if dist <= MoneyWash.Interaction.Enter.markerDist then
        wait = 0
        if MoneyWash.Interaction.Enter.marker then
          DrawMarker(MoneyWash.Marker.type, MoneyWash.Positions.Enter.x, MoneyWash.Positions.Enter.y, MoneyWash.Positions.Enter.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, MoneyWash.Marker.R, MoneyWash.Marker.G, MoneyWash.Marker.B, 255, 0, 1, 2, 1, nil, nil, 0)
        end
     
          if dist <= MoneyWash.Interaction.Enter.interactDistance then
          wait = 0
          --Visual.Subtitle(MoneyWash.Interaction.Enter.notif, 1)
          ESX.ShowHelpNotification(MoneyWash.Interaction.Enter.notif, false, false, 1)
          if IsControlJustPressed(1,51) then
            RageUI.CloseAll() 
            DoScreenFadeOut(1500)
            Wait(1500)
                DisplayRadar(false)
            Wait(50)
                SetEntityCoords(PlayerPedId(), MoneyWash.Positions.Exit.x, MoneyWash.Positions.Exit.y, MoneyWash.Positions.Exit.z-1)
            Wait(150)
            DoScreenFadeIn(1500)
          end
        end
          end
    Citizen.Wait(wait)
    end
end)

-- // Exit Position \\ --
Citizen.CreateThread(function()
    while true do
    local wait = 1000
  
        local plyCoords = GetEntityCoords(PlayerPedId(), false)       
        local dist = #(plyCoords-MoneyWash.Positions.Exit)
  
         
        if dist <= MoneyWash.Interaction.Exit.markerDist then
        wait = 0
        if MoneyWash.Interaction.Exit.marker then
          DrawMarker(MoneyWash.Marker.type, MoneyWash.Positions.Exit.x, MoneyWash.Positions.Exit.y, MoneyWash.Positions.Exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, MoneyWash.Marker.R, MoneyWash.Marker.G, MoneyWash.Marker.B, 255, 0, 1, 2, 1, nil, nil, 0)
        end
     
          if dist <= MoneyWash.Interaction.Exit.interactDistance then
          wait = 0
          --Visual.Subtitle(MoneyWash.Interaction.Exit.notif, 1)
          ESX.ShowHelpNotification(MoneyWash.Interaction.Exit.notif, false, false, 1)
          if IsControlJustPressed(1,51) then
            RageUI.CloseAll() 
            DoScreenFadeOut(1500)
            Wait(1500)
                DisplayRadar(true)
            Wait(50)
                SetEntityCoords(PlayerPedId(), MoneyWash.Positions.Enter.x, MoneyWash.Positions.Enter.y, MoneyWash.Positions.Enter.z-1)
            Wait(150)
            DoScreenFadeIn(1500)
          end
        end
          end
    Citizen.Wait(wait)
    end
end)

-- [[ Author : AvadaKedavra ]] --