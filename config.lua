-- [[ Config file ]] --

-- Initialize Var
MoneyWash = {}

-- Percentage to remove black money
MoneyWash.Percentage = 15

MoneyWash.IPLResourceName = 'bob74_ipl'

-- Positions
MoneyWash.Positions = {
    Enter = vector3(2890.1353, 4391.5693, 50.3367),
    Exit = vector3(1137.8916015625,-3198.6887207031,-39.665676116943),
    Wash = vector3(1122.3729, -3194.4744, -40.3985),
}

-- Marker
MoneyWash.Marker = {
    type = 22,
    R = 255,
    G = 255,
    B = 255,
}

-- Notif
MoneyWash.Notification = {
    Name = 'LJT',
    Char = 'CHAR_LJT'
}

-- Animation
MoneyWash.Animation = {
    Dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
    Name = "weed_spraybottle_crouch_base_inspector"
}

-- Interactions
MoneyWash.Interaction = {
    Wash = {
        ["TextureDictionary"] = nil,
        ["TextureName"] = nil,
        ["interactDistance"] = 2.0,
        ["notif"] = "Press ~INPUT_CONTEXT~ for wash your black money",
        ["marker"] = true,
        ["markerDist"] = 12.0,
        ["nameMenu"] = "Whitening",
        ["descMenu"] = "Launder Money"
    },

    Enter = {
        ["TextureDictionary"] = nil,
        ["TextureName"] = nil,
        ["interactDistance"] = 1.0,
        ["notif"] = "Press ~INPUT_CONTEXT~ for enter",
        ["marker"] = false,
        ["markerDist"] = 1.0,
    },

    Exit = {
        ["TextureDictionary"] = nil,
        ["TextureName"] = nil,
        ["interactDistance"] = 2.0,
        ["notif"] = "Press ~INPUT_CONTEXT~ for exit",
        ["marker"] = false,
        ["markerDist"] = 10.0,
    },
}

-- Logs
MoneyWash.Logs = {
    ['Name'] = "AKMoneyWash",
    ['Image'] = 'https://media.discordapp.net/attachments/1089959405145038849/1089960703789637783/bettercallsaul.png',
    ['Color'] = "3447003",
    ['Webhook'] = '', -- webhook discord to know who use money wash
}

-- Text editable
MoneyWash.Strings = {
    ['Notification'] = {
        ['Success'] = '~g~Success',
        ['Error'] = '~r~Error'
    },
    ['FinishLaunder'] = "You've juste laundered ~r~%s$~s~ and get ~g~%s$~s~.",
    ['NotEnoughBlackMoney'] = "You don't have enough black money.",
    ['Laudering'] = 'Money Laundering',
    ['FinalLog'] = 'Player : %s [%s]\nLaundered amount : %s $\nAmount received : %s $',
    ['Launder'] = 'Launder',
    ['MoneyToLaunder'] = 'Black Money to be laundered : ~r~%s $~s~',
    ['MoneyLaundered'] = 'Money laundered : ~g~%s $~s~',
    ['Quantity'] = 'Quantity',
    ['SomeoneUsesThisMachine'] = '~r~Someone already uses this machine.',
    ['Progress'] = 'Laundering in progress : ~p~%s %~s~',
}

-- [[ Author : AvadaKedavra ]] --