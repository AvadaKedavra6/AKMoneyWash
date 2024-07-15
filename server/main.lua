-- [[ Server File ]] --

-- // ESX Var \\--
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- // Other Var \\ --
local PlayerIsWashing = false
local _S = MoneyWash.Strings
local _N = _S['Notification']
local Logs = MoneyWash.Logs

-- // Function Date \\ --
function GetLogsDate() 
	date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local hour = math.floor(date.hour + 1)
    if hour == 24 then hour = '00' end

	date = "" .. date.day .. "/" .. date.month .. "/" .. date.year.." - "..hour..":"..date.min..":"..date.sec
	return date
end

local function n(src)return GetPlayerName(src)end
local function d(nb)return ESX.Math.GroupDigits(nb) end

-- // Function to wash \\ --
RegisterNetEvent('AKMoneyWash:Wash')
AddEventHandler('AKMoneyWash:Wash', function(moneyToRemove, moneyToGive)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.getAccount("black_money").money >= moneyToRemove then
        xPlayer.removeAccountMoney("black_money", moneyToRemove)
        xPlayer.addMoney(moneyToGive)
        TriggerClientEvent("esx:showAdvancedNotification", _src, MoneyWash.Notification.Name, _N['Success'], _S['FinishLaunder']:format(ESX.Math.GroupDigits(moneyToRemove), ESX.Math.GroupDigits(moneyToGive)), MoneyWash.Notification.Char, 0)
        
        -- // webhook (config in config.lua)
        local ww = {
            {   ["author"] = { 
                    ["name"] = Logs['Name'], 
                    ['image'] = Logs['Image'] 
                }, 
                ["thumbnail"] = { 
                    ["url"] = Logs['Image'] 
                }, 
                ["color"] = Logs['Color'], 
                ["title"] = _S['Laudering'], 
                ["description"] = (_S['FinalLog']):format(n(_src), _src, d(moneyToRemove), d(moneyToGive)), 
                ["footer"] = 
                { 
                    ["text"] = GetLogsDate(), 
                    ["icon_url"] = Logs['Image']  
                }, 
            } 
        }
        PerformHttpRequest(Logs['Webhook'], function(err, text, headers) end, 'POST', json.encode({username = Logs['Name'], embeds = ww, avatar_url = Logs['Image'] }), { ['Content-Type'] = 'application/json' })
    else
        TriggerClientEvent("esx:showAdvancedNotification", _src, MoneyWash.Notification.Name, _N['Error'], _S['NotEnoughBlackMoney'], MoneyWash.Notification.Char, 0)
    end
end)

RegisterNetEvent('AKMoneyWash:SetIfPlayerIsWashing')
AddEventHandler('AKMoneyWash:SetIfPlayerIsWashing', function(status)
    PlayerIsWashing = status
    TriggerClientEvent('AKMoneyWash:SetIfPlayerIsWashingForClient', -1, status)
end)

ESX.RegisterServerCallback("AKMoneyWash:GetIfPlayerIsWashing", function(source, cb)
    cb(PlayerIsWashing)
end)

RegisterNetEvent('AKMoneyWash:ChangeDryerToAll')
AddEventHandler('AKMoneyWash:ChangeDryerToAll', function(status)
    TriggerClientEvent('AKMoneyWash:ChangeDryer', -1, status)
end)

ESX.RegisterServerCallback("AKMoneyWash:GetMoney", function(source, cb)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    cb(xPlayer.getAccount('black_money').money)
end)

-- [[ Author : AvadaKedavra ]] --
