return({
game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255, 0, 255)\">Starting BinisJ Nigga</font>")

--[[

	BinisJ!

	Rayfield Interface Suite
	by Sirius

	shlex | Designing + Programming
	iRay  | Programming
	Max   | Programming

]]

if debugX then
	warn('Initialising Rayfield')
end

local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

-- Loads and executes a function hosted on a remote URL. Cancels the request if the requested URL takes too long to respond.
-- Errors with the function are caught and logged to the output
local function loadWithTimeout(url: string, timeout: number?): ...any
	assert(type(url) == "string", "Expected string, got " .. type(url))
	timeout = timeout or 5
	local requestCompleted = false
	local success, result = false, nil

	local requestThread = task.spawn(function()
		local fetchSuccess, fetchResult = pcall(game.HttpGet, game, url) -- game:HttpGet(url)
		-- If the request fails the content can be empty, even if fetchSuccess is true
		if not fetchSuccess or #fetchResult == 0 then
			if #fetchResult == 0 then
				fetchResult = "Empty response" -- Set the error message
			end
			success, result = false, fetchResult
			requestCompleted = true
			return
		end
		local content = fetchResult -- Fetched content
		local execSuccess, execResult = pcall(function()
			return loadstring(content)()
		end)
		success, result = execSuccess, execResult
		requestCompleted = true
	end)

	local timeoutThread = task.delay(timeout, function()
		if not requestCompleted then
			warn(`Request for {url} timed out after {timeout} seconds`)
			task.cancel(requestThread)
			result = "Request timed out"
			requestCompleted = true
		end
	end)

	-- Wait for completion or timeout
	while not requestCompleted do
		task.wait()
	end
	-- Cancel timeout thread if still running when request completes
	if coroutine.status(timeoutThread) ~= "dead" then
		task.cancel(timeoutThread)
	end
	if not success then
		warn(`Failed to process {url}: {result}`)
	end
	return if success then result else nil
end

local requestsDisabled = true --getgenv and getgenv().DISABLE_RAYFIELD_REQUESTS
local InterfaceBuild = '3K3W'
local Release = "Build 1.672"
local RayfieldFolder = "Rayfield"
local ConfigurationFolder = RayfieldFolder.."/Configurations"
local ConfigurationExtension = ".rfld"
local settingsTable = {
	General = {
		-- if needs be in order just make getSetting(name)
		rayfieldOpen = {Type = 'bind', Value = 'K', Name = 'Rayfield Keybind'},
		-- buildwarnings
		-- rayfieldprompts

	},
	System = {
		usageAnalytics = {Type = 'toggle', Value = true, Name = 'Anonymised Analytics'},
	}
}

local HttpService = getService('HttpService')
local RunService = getService('RunService')

-- Environment Check
local useStudio = RunService:IsStudio() or false

local settingsCreated = false
local cachedSettings
local request = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request



local function loadSettings()
	local file = nil
	
	local success, result =	pcall(function()
		task.spawn(function()
			if isfolder and isfolder(RayfieldFolder) then
				if isfile and isfile(RayfieldFolder..'/settings'..ConfigurationExtension) then
					file = readfile(RayfieldFolder..'/settings'..ConfigurationExtension)
				end
			end

			-- for debug in studio
			if useStudio then
				file = [[
		{"General":{"rayfieldOpen":{"Value":"K","Type":"bind","Name":"Rayfield Keybind","Element":{"HoldToInteract":false,"Ext":true,"Name":"Rayfield Keybind","Set":null,"CallOnChange":true,"Callback":null,"CurrentKeybind":"K"}}},"System":{"usageAnalytics":{"Value":false,"Type":"toggle","Name":"Anonymised Analytics","Element":{"Ext":true,"Name":"Anonymised Analytics","Set":null,"CurrentValue":false,"Callback":null}}}}
	]]
			end


			if file then
				local success, decodedFile = pcall(function() return HttpService:JSONDecode(file) end)
				if success then
					file = decodedFile
				else
					file = {}
				end
			else
				file = {}
			end


			if not settingsCreated then 
				cachedSettings = file
				return
			end

			if file ~= {} then
				for categoryName, settingCategory in pairs(settingsTable) do
					if file[categoryName] then
						for settingName, setting in pairs(settingCategory) do
							if file[categoryName][settingName] then
								setting.Value = file[categoryName][settingName].Value
								setting.Element:Set(setting.Value)
							end
						end
					end
				end
			end
		end)
	end)
	
	if not success then 
		if writefile then
			warn('Rayfield had an issue accessing configuration saving capability.')
		end
	end
end

if debugX then
	warn('Now Loading Settings Configuration')
end

loadSettings()

if debugX then
	warn('Settings Loaded')
end

--if not cachedSettings or not cachedSettings.System or not cachedSettings.System.usageAnalytics then
--	local fileFunctionsAvailable = isfile and writefile and readfile

--	if not fileFunctionsAvailable and not useStudio then
--		warn('Rayfield Interface Suite | Sirius Analytics:\n\n\nAs you don\'t have file functionality with your executor, we are unable to save whether you want to opt in or out to analytics.\nIf you do not want to take part in anonymised usage statistics, let us know in our Discord at sirius.menu/discord and we will manually opt you out.')
--		analytics = true	
--	else
--		prompt.create(
--			'Help us improve',
--	            [[Would you like to allow Sirius to collect usage statistics?

--<font transparency='0.4'>No data is linked to you or your personal activity.</font>]],
--			'Continue',
--			'Cancel',
--			function(result)
--				settingsTable.System.usageAnalytics.Value = result
--				analytics = result
--			end
--		)
--	end

--	repeat task.wait() until analytics ~= nil
--end

if debugX then
	warn('Moving on to continue initialisation')
end

local RayfieldLibrary = {
	Flags = {},
	Theme = {
		Default = {
			TextColor = Color3.fromRGB(240, 240, 240),

			Background = Color3.fromRGB(25, 25, 25),
			Topbar = Color3.fromRGB(34, 34, 34),
			Shadow = Color3.fromRGB(20, 20, 20),

			NotificationBackground = Color3.fromRGB(20, 20, 20),
			NotificationActionsBackground = Color3.fromRGB(230, 230, 230),

			TabBackground = Color3.fromRGB(80, 80, 80),
			TabStroke = Color3.fromRGB(85, 85, 85),
			TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			SelectedTabTextColor = Color3.fromRGB(50, 50, 50),

			ElementBackground = Color3.fromRGB(35, 35, 35),
			ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
			SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
			ElementStroke = Color3.fromRGB(50, 50, 50),
			SecondaryElementStroke = Color3.fromRGB(40, 40, 40),

			SliderBackground = Color3.fromRGB(50, 138, 220),
			SliderProgress = Color3.fromRGB(50, 138, 220),
			SliderStroke = Color3.fromRGB(58, 163, 255),

			ToggleBackground = Color3.fromRGB(30, 30, 30),
			ToggleEnabled = Color3.fromRGB(0, 146, 214),
			ToggleDisabled = Color3.fromRGB(100, 100, 100),
			ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
			ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),

			DropdownSelected = Color3.fromRGB(40, 40, 40),
			DropdownUnselected = Color3.fromRGB(30, 30, 30),

			InputBackground = Color3.fromRGB(30, 30, 30),
			InputStroke = Color3.fromRGB(65, 65, 65),
			PlaceholderColor = Color3.fromRGB(178, 178, 178)
		},

		Ocean = {
			TextColor = Color3.fromRGB(230, 240, 240),

			Background = Color3.fromRGB(20, 30, 30),
			Topbar = Color3.fromRGB(25, 40, 40),
			Shadow = Color3.fromRGB(15, 20, 20),

			NotificationBackground = Color3.fromRGB(25, 35, 35),
			NotificationActionsBackground = Color3.fromRGB(230, 240, 240),

			TabBackground = Color3.fromRGB(40, 60, 60),
			TabStroke = Color3.fromRGB(50, 70, 70),
			TabBackgroundSelected = Color3.fromRGB(100, 180, 180),
			TabTextColor = Color3.fromRGB(210, 230, 230),
			SelectedTabTextColor = Color3.fromRGB(20, 50, 50),

			ElementBackground = Color3.fromRGB(30, 50, 50),
			ElementBackgroundHover = Color3.fromRGB(40, 60, 60),
			SecondaryElementBackground = Color3.fromRGB(30, 45, 45),
			ElementStroke = Color3.fromRGB(45, 70, 70),
			SecondaryElementStroke = Color3.fromRGB(40, 65, 65),

			SliderBackground = Color3.fromRGB(0, 110, 110),
			SliderProgress = Color3.fromRGB(0, 140, 140),
			SliderStroke = Color3.fromRGB(0, 160, 160),

			ToggleBackground = Color3.fromRGB(30, 50, 50),
			ToggleEnabled = Color3.fromRGB(0, 130, 130),
			ToggleDisabled = Color3.fromRGB(70, 90, 90),
			ToggleEnabledStroke = Color3.fromRGB(0, 160, 160),
			ToggleDisabledStroke = Color3.fromRGB(85, 105, 105),
			ToggleEnabledOuterStroke = Color3.fromRGB(50, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(45, 65, 65),

			DropdownSelected = Color3.fromRGB(30, 60, 60),
			DropdownUnselected = Color3.fromRGB(25, 40, 40),

			InputBackground = Color3.fromRGB(30, 50, 50),
			InputStroke = Color3.fromRGB(50, 70, 70),
			PlaceholderColor = Color3.fromRGB(140, 160, 160)
		},

		AmberGlow = {
			TextColor = Color3.fromRGB(255, 245, 230),

			Background = Color3.fromRGB(45, 30, 20),
			Topbar = Color3.fromRGB(55, 40, 25),
			Shadow = Color3.fromRGB(35, 25, 15),

			NotificationBackground = Color3.fromRGB(50, 35, 25),
			NotificationActionsBackground = Color3.fromRGB(245, 230, 215),

			TabBackground = Color3.fromRGB(75, 50, 35),
			TabStroke = Color3.fromRGB(90, 60, 45),
			TabBackgroundSelected = Color3.fromRGB(230, 180, 100),
			TabTextColor = Color3.fromRGB(250, 220, 200),
			SelectedTabTextColor = Color3.fromRGB(50, 30, 10),

			ElementBackground = Color3.fromRGB(60, 45, 35),
			ElementBackgroundHover = Color3.fromRGB(70, 50, 40),
			SecondaryElementBackground = Color3.fromRGB(55, 40, 30),
			ElementStroke = Color3.fromRGB(85, 60, 45),
			SecondaryElementStroke = Color3.fromRGB(75, 50, 35),

			SliderBackground = Color3.fromRGB(220, 130, 60),
			SliderProgress = Color3.fromRGB(250, 150, 75),
			SliderStroke = Color3.fromRGB(255, 170, 85),

			ToggleBackground = Color3.fromRGB(55, 40, 30),
			ToggleEnabled = Color3.fromRGB(240, 130, 30),
			ToggleDisabled = Color3.fromRGB(90, 70, 60),
			ToggleEnabledStroke = Color3.fromRGB(255, 160, 50),
			ToggleDisabledStroke = Color3.fromRGB(110, 85, 75),
			ToggleEnabledOuterStroke = Color3.fromRGB(200, 100, 50),
			ToggleDisabledOuterStroke = Color3.fromRGB(75, 60, 55),

			DropdownSelected = Color3.fromRGB(70, 50, 40),
			DropdownUnselected = Color3.fromRGB(55, 40, 30),

			InputBackground = Color3.fromRGB(60, 45, 35),
			InputStroke = Color3.fromRGB(90, 65, 50),
			PlaceholderColor = Color3.fromRGB(190, 150, 130)
		},

		Light = {
			TextColor = Color3.fromRGB(40, 40, 40),

			Background = Color3.fromRGB(245, 245, 245),
			Topbar = Color3.fromRGB(230, 230, 230),
			Shadow = Color3.fromRGB(200, 200, 200),

			NotificationBackground = Color3.fromRGB(250, 250, 250),
			NotificationActionsBackground = Color3.fromRGB(240, 240, 240),

			TabBackground = Color3.fromRGB(235, 235, 235),
			TabStroke = Color3.fromRGB(215, 215, 215),
			TabBackgroundSelected = Color3.fromRGB(255, 255, 255),
			TabTextColor = Color3.fromRGB(80, 80, 80),
			SelectedTabTextColor = Color3.fromRGB(0, 0, 0),

			ElementBackground = Color3.fromRGB(240, 240, 240),
			ElementBackgroundHover = Color3.fromRGB(225, 225, 225),
			SecondaryElementBackground = Color3.fromRGB(235, 235, 235),
			ElementStroke = Color3.fromRGB(210, 210, 210),
			SecondaryElementStroke = Color3.fromRGB(210, 210, 210),

			SliderBackground = Color3.fromRGB(150, 180, 220),
			SliderProgress = Color3.fromRGB(100, 150, 200), 
			SliderStroke = Color3.fromRGB(120, 170, 220),

			ToggleBackground = Color3.fromRGB(220, 220, 220),
			ToggleEnabled = Color3.fromRGB(0, 146, 214),
			ToggleDisabled = Color3.fromRGB(150, 150, 150),
			ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
			ToggleDisabledStroke = Color3.fromRGB(170, 170, 170),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(180, 180, 180),

			DropdownSelected = Color3.fromRGB(230, 230, 230),
			DropdownUnselected = Color3.fromRGB(220, 220, 220),

			InputBackground = Color3.fromRGB(240, 240, 240),
			InputStroke = Color3.fromRGB(180, 180, 180),
			PlaceholderColor = Color3.fromRGB(140, 140, 140)
		},

		Amethyst = {
			TextColor = Color3.fromRGB(240, 240, 240),

			Background = Color3.fromRGB(30, 20, 40),
			Topbar = Color3.fromRGB(40, 25, 50),
			Shadow = Color3.fromRGB(20, 15, 30),

			NotificationBackground = Color3.fromRGB(35, 20, 40),
			NotificationActionsBackground = Color3.fromRGB(240, 240, 250),

			TabBackground = Color3.fromRGB(60, 40, 80),
			TabStroke = Color3.fromRGB(70, 45, 90),
			TabBackgroundSelected = Color3.fromRGB(180, 140, 200),
			TabTextColor = Color3.fromRGB(230, 230, 240),
			SelectedTabTextColor = Color3.fromRGB(50, 20, 50),

			ElementBackground = Color3.fromRGB(45, 30, 60),
			ElementBackgroundHover = Color3.fromRGB(50, 35, 70),
			SecondaryElementBackground = Color3.fromRGB(40, 30, 55),
			ElementStroke = Color3.fromRGB(70, 50, 85),
			SecondaryElementStroke = Color3.fromRGB(65, 45, 80),

			SliderBackground = Color3.fromRGB(100, 60, 150),
			SliderProgress = Color3.fromRGB(130, 80, 180),
			SliderStroke = Color3.fromRGB(150, 100, 200),

			ToggleBackground = Color3.fromRGB(45, 30, 55),
			ToggleEnabled = Color3.fromRGB(120, 60, 150),
			ToggleDisabled = Color3.fromRGB(94, 47, 117),
			ToggleEnabledStroke = Color3.fromRGB(140, 80, 170),
			ToggleDisabledStroke = Color3.fromRGB(124, 71, 150),
			ToggleEnabledOuterStroke = Color3.fromRGB(90, 40, 120),
			ToggleDisabledOuterStroke = Color3.fromRGB(80, 50, 110),

			DropdownSelected = Color3.fromRGB(50, 35, 70),
			DropdownUnselected = Color3.fromRGB(35, 25, 50),

			InputBackground = Color3.fromRGB(45, 30, 60),
			InputStroke = Color3.fromRGB(80, 50, 110),
			PlaceholderColor = Color3.fromRGB(178, 150, 200)
		},

		Green = {
			TextColor = Color3.fromRGB(30, 60, 30),

			Background = Color3.fromRGB(235, 245, 235),
			Topbar = Color3.fromRGB(210, 230, 210),
			Shadow = Color3.fromRGB(200, 220, 200),

			NotificationBackground = Color3.fromRGB(240, 250, 240),
			NotificationActionsBackground = Color3.fromRGB(220, 235, 220),

			TabBackground = Color3.fromRGB(215, 235, 215),
			TabStroke = Color3.fromRGB(190, 210, 190),
			TabBackgroundSelected = Color3.fromRGB(245, 255, 245),
			TabTextColor = Color3.fromRGB(50, 80, 50),
			SelectedTabTextColor = Color3.fromRGB(20, 60, 20),

			ElementBackground = Color3.fromRGB(225, 240, 225),
			ElementBackgroundHover = Color3.fromRGB(210, 225, 210),
			SecondaryElementBackground = Color3.fromRGB(235, 245, 235), 
			ElementStroke = Color3.fromRGB(180, 200, 180),
			SecondaryElementStroke = Color3.fromRGB(180, 200, 180),

			SliderBackground = Color3.fromRGB(90, 160, 90),
			SliderProgress = Color3.fromRGB(70, 130, 70),
			SliderStroke = Color3.fromRGB(100, 180, 100),

			ToggleBackground = Color3.fromRGB(215, 235, 215),
			ToggleEnabled = Color3.fromRGB(60, 130, 60),
			ToggleDisabled = Color3.fromRGB(150, 175, 150),
			ToggleEnabledStroke = Color3.fromRGB(80, 150, 80),
			ToggleDisabledStroke = Color3.fromRGB(130, 150, 130),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 160, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(160, 180, 160),

			DropdownSelected = Color3.fromRGB(225, 240, 225),
			DropdownUnselected = Color3.fromRGB(210, 225, 210),

			InputBackground = Color3.fromRGB(235, 245, 235),
			InputStroke = Color3.fromRGB(180, 200, 180),
			PlaceholderColor = Color3.fromRGB(120, 140, 120)
		},

		Bloom = {
			TextColor = Color3.fromRGB(60, 40, 50),

			Background = Color3.fromRGB(255, 240, 245),
			Topbar = Color3.fromRGB(250, 220, 225),
			Shadow = Color3.fromRGB(230, 190, 195),

			NotificationBackground = Color3.fromRGB(255, 235, 240),
			NotificationActionsBackground = Color3.fromRGB(245, 215, 225),

			TabBackground = Color3.fromRGB(240, 210, 220),
			TabStroke = Color3.fromRGB(230, 200, 210),
			TabBackgroundSelected = Color3.fromRGB(255, 225, 235),
			TabTextColor = Color3.fromRGB(80, 40, 60),
			SelectedTabTextColor = Color3.fromRGB(50, 30, 50),

			ElementBackground = Color3.fromRGB(255, 235, 240),
			ElementBackgroundHover = Color3.fromRGB(245, 220, 230),
			SecondaryElementBackground = Color3.fromRGB(255, 235, 240), 
			ElementStroke = Color3.fromRGB(230, 200, 210),
			SecondaryElementStroke = Color3.fromRGB(230, 200, 210),

			SliderBackground = Color3.fromRGB(240, 130, 160),
			SliderProgress = Color3.fromRGB(250, 160, 180),
			SliderStroke = Color3.fromRGB(255, 180, 200),

			ToggleBackground = Color3.fromRGB(240, 210, 220),
			ToggleEnabled = Color3.fromRGB(255, 140, 170),
			ToggleDisabled = Color3.fromRGB(200, 180, 185),
			ToggleEnabledStroke = Color3.fromRGB(250, 160, 190),
			ToggleDisabledStroke = Color3.fromRGB(210, 180, 190),
			ToggleEnabledOuterStroke = Color3.fromRGB(220, 160, 180),
			ToggleDisabledOuterStroke = Color3.fromRGB(190, 170, 180),

			DropdownSelected = Color3.fromRGB(250, 220, 225),
			DropdownUnselected = Color3.fromRGB(240, 210, 220),

			InputBackground = Color3.fromRGB(255, 235, 240),
			InputStroke = Color3.fromRGB(220, 190, 200),
			PlaceholderColor = Color3.fromRGB(170, 130, 140)
		},

		DarkBlue = {
			TextColor = Color3.fromRGB(230, 230, 230),

			Background = Color3.fromRGB(20, 25, 30),
			Topbar = Color3.fromRGB(30, 35, 40),
			Shadow = Color3.fromRGB(15, 20, 25),

			NotificationBackground = Color3.fromRGB(25, 30, 35),
			NotificationActionsBackground = Color3.fromRGB(45, 50, 55),

			TabBackground = Color3.fromRGB(35, 40, 45),
			TabStroke = Color3.fromRGB(45, 50, 60),
			TabBackgroundSelected = Color3.fromRGB(40, 70, 100),
			TabTextColor = Color3.fromRGB(200, 200, 200),
			SelectedTabTextColor = Color3.fromRGB(255, 255, 255),

			ElementBackground = Color3.fromRGB(30, 35, 40),
			ElementBackgroundHover = Color3.fromRGB(40, 45, 50),
			SecondaryElementBackground = Color3.fromRGB(35, 40, 45), 
			ElementStroke = Color3.fromRGB(45, 50, 60),
			SecondaryElementStroke = Color3.fromRGB(40, 45, 55),

			SliderBackground = Color3.fromRGB(0, 90, 180),
			SliderProgress = Color3.fromRGB(0, 120, 210),
			SliderStroke = Color3.fromRGB(0, 150, 240),

			ToggleBackground = Color3.fromRGB(35, 40, 45),
			ToggleEnabled = Color3.fromRGB(0, 120, 210),
			ToggleDisabled = Color3.fromRGB(70, 70, 80),
			ToggleEnabledStroke = Color3.fromRGB(0, 150, 240),
			ToggleDisabledStroke = Color3.fromRGB(75, 75, 85),
			ToggleEnabledOuterStroke = Color3.fromRGB(20, 100, 180), 
			ToggleDisabledOuterStroke = Color3.fromRGB(55, 55, 65),

			DropdownSelected = Color3.fromRGB(30, 70, 90),
			DropdownUnselected = Color3.fromRGB(25, 30, 35),

			InputBackground = Color3.fromRGB(25, 30, 35),
			InputStroke = Color3.fromRGB(45, 50, 60), 
			PlaceholderColor = Color3.fromRGB(150, 150, 160)
		},

		Serenity = {
			TextColor = Color3.fromRGB(50, 55, 60),
			Background = Color3.fromRGB(240, 245, 250),
			Topbar = Color3.fromRGB(215, 225, 235),
			Shadow = Color3.fromRGB(200, 210, 220),

			NotificationBackground = Color3.fromRGB(210, 220, 230),
			NotificationActionsBackground = Color3.fromRGB(225, 230, 240),

			TabBackground = Color3.fromRGB(200, 210, 220),
			TabStroke = Color3.fromRGB(180, 190, 200),
			TabBackgroundSelected = Color3.fromRGB(175, 185, 200),
			TabTextColor = Color3.fromRGB(50, 55, 60),
			SelectedTabTextColor = Color3.fromRGB(30, 35, 40),

			ElementBackground = Color3.fromRGB(210, 220, 230),
			ElementBackgroundHover = Color3.fromRGB(220, 230, 240),
			SecondaryElementBackground = Color3.fromRGB(200, 210, 220),
			ElementStroke = Color3.fromRGB(190, 200, 210),
			SecondaryElementStroke = Color3.fromRGB(180, 190, 200),

			SliderBackground = Color3.fromRGB(200, 220, 235),  -- Lighter shade
			SliderProgress = Color3.fromRGB(70, 130, 180),
			SliderStroke = Color3.fromRGB(150, 180, 220),

			ToggleBackground = Color3.fromRGB(210, 220, 230),
			ToggleEnabled = Color3.fromRGB(70, 160, 210),
			ToggleDisabled = Color3.fromRGB(180, 180, 180),
			ToggleEnabledStroke = Color3.fromRGB(60, 150, 200),
			ToggleDisabledStroke = Color3.fromRGB(140, 140, 140),
			ToggleEnabledOuterStroke = Color3.fromRGB(100, 120, 140),
			ToggleDisabledOuterStroke = Color3.fromRGB(120, 120, 130),

			DropdownSelected = Color3.fromRGB(220, 230, 240),
			DropdownUnselected = Color3.fromRGB(200, 210, 220),

			InputBackground = Color3.fromRGB(220, 230, 240),
			InputStroke = Color3.fromRGB(180, 190, 200),
			PlaceholderColor = Color3.fromRGB(150, 150, 150)
		},
	}
}


-- Services
local UserInputService = getService("UserInputService")
local TweenService = getService("TweenService")
local Players = getService("Players")
local CoreGui = getService("CoreGui")

-- Interface Management

local Rayfield = useStudio and script.Parent:FindFirstChild('Rayfield') or game:GetObjects("rbxassetid://10804731440")[1]
local buildAttempts = 0
local correctBuild = false
local warned
local globalLoaded

repeat
	if Rayfield:FindFirstChild('Build') and Rayfield.Build.Value == InterfaceBuild then
		correctBuild = true
		break
	end

	correctBuild = false

	if not warned then
		warn('Rayfield | Build Mismatch')
		print('Rayfield may encounter issues as you are running an incompatible interface version ('.. ((Rayfield:FindFirstChild('Build') and Rayfield.Build.Value) or 'No Build') ..').\n\nThis version of Rayfield is intended for interface build '..InterfaceBuild..'.')
		warned = true
	end

	toDestroy, Rayfield = Rayfield, useStudio and script.Parent:FindFirstChild('Rayfield') or game:GetObjects("rbxassetid://10804731440")[1]
	if toDestroy and not useStudio then toDestroy:Destroy() end

	buildAttempts = buildAttempts + 1
until buildAttempts >= 2

Rayfield.Enabled = false

if gethui then
	Rayfield.Parent = gethui()
elseif syn and syn.protect_gui then 
	syn.protect_gui(Rayfield)
	Rayfield.Parent = CoreGui
elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
	Rayfield.Parent = CoreGui:FindFirstChild("RobloxGui")
elseif not useStudio then
	Rayfield.Parent = CoreGui
end

if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == Rayfield.Name and Interface ~= Rayfield then
			Interface.Enabled = false
			Interface.Name = "Rayfield-Old"
		end
	end
elseif not useStudio then
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == Rayfield.Name and Interface ~= Rayfield then
			Interface.Enabled = false
			Interface.Name = "Rayfield-Old"
		end
	end
end


local minSize = Vector2.new(1024, 768)
local useMobileSizing

if Rayfield.AbsoluteSize.X < minSize.X and Rayfield.AbsoluteSize.Y < minSize.Y then
	useMobileSizing = true
end

if UserInputService.TouchEnabled then
	useMobilePrompt = true
end


-- Object Variables

local Main = Rayfield.Main
local MPrompt = Rayfield:FindFirstChild('Prompt')
local Topbar = Main.Topbar
local Elements = Main.Elements
local LoadingFrame = Main.LoadingFrame
local TabList = Main.TabList
local dragBar = Rayfield:FindFirstChild('Drag')
local dragInteract = dragBar and dragBar.Interact or nil
local dragBarCosmetic = dragBar and dragBar.Drag or nil

local dragOffset = 255
local dragOffsetMobile = 150

Rayfield.DisplayOrder = 100
LoadingFrame.Version.Text = Release

-- Thanks to Latte Softworks for the Lucide integration for Roblox
local Icons = useStudio and require(script.Parent.icons) or loadWithTimeout('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/icons.lua')
-- Variables

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false
local searchOpen = false
local Notifications = Rayfield.Notifications

local SelectedTheme = RayfieldLibrary.Theme.Default

local function ChangeTheme(Theme)
	if typeof(Theme) == 'string' then
		SelectedTheme = RayfieldLibrary.Theme[Theme]
	elseif typeof(Theme) == 'table' then
		SelectedTheme = Theme
	end

	Rayfield.Main.BackgroundColor3 = SelectedTheme.Background
	Rayfield.Main.Topbar.BackgroundColor3 = SelectedTheme.Topbar
	Rayfield.Main.Topbar.CornerRepair.BackgroundColor3 = SelectedTheme.Topbar
	Rayfield.Main.Shadow.Image.ImageColor3 = SelectedTheme.Shadow

	Rayfield.Main.Topbar.ChangeSize.ImageColor3 = SelectedTheme.TextColor
	Rayfield.Main.Topbar.Hide.ImageColor3 = SelectedTheme.TextColor
	Rayfield.Main.Topbar.Search.ImageColor3 = SelectedTheme.TextColor
	if Topbar:FindFirstChild('Settings') then
		Rayfield.Main.Topbar.Settings.ImageColor3 = SelectedTheme.TextColor
		Rayfield.Main.Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	end

	Main.Search.BackgroundColor3 = SelectedTheme.TextColor
	Main.Search.Shadow.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Search.ImageColor3 = SelectedTheme.TextColor
	Main.Search.Input.PlaceholderColor3 = SelectedTheme.TextColor
	Main.Search.UIStroke.Color = SelectedTheme.SecondaryElementStroke

	if Main:FindFirstChild('Notice') then
		Main.Notice.BackgroundColor3 = SelectedTheme.Background
	end

	for _, text in ipairs(Rayfield:GetDescendants()) do
		if text.Parent.Parent ~= Notifications then
			if text:IsA('TextLabel') or text:IsA('TextBox') then text.TextColor3 = SelectedTheme.TextColor end
		end
	end

	for _, TabPage in ipairs(Elements:GetChildren()) do
		for _, Element in ipairs(TabPage:GetChildren()) do
			if Element.ClassName == "Frame" and Element.Name ~= "Placeholder" and Element.Name ~= "SectionSpacing" and Element.Name ~= "Divider" and Element.Name ~= "SectionTitle" and Element.Name ~= "SearchTitle-fsefsefesfsefesfesfThanks" then
				Element.BackgroundColor3 = SelectedTheme.ElementBackground
				Element.UIStroke.Color = SelectedTheme.ElementStroke
			end
		end
	end
end

local function getIcon(name : string): {id: number, imageRectSize: Vector2, imageRectOffset: Vector2}
	if not Icons then
		warn("Lucide Icons: Cannot use icons as icons library is not loaded")
		return
	end
	name = string.match(string.lower(name), "^%s*(.*)%s*$") :: string
	local sizedicons = Icons['48px']
	local r = sizedicons[name]
	if not r then
		error(`Lucide Icons: Failed to find icon by the name of "{name}"`, 2)
	end

	local rirs = r[2]
	local riro = r[3]

	if type(r[1]) ~= "number" or type(rirs) ~= "table" or type(riro) ~= "table" then
		error("Lucide Icons: Internal error: Invalid auto-generated asset entry")
	end

	local irs = Vector2.new(rirs[1], rirs[2])
	local iro = Vector2.new(riro[1], riro[2])

	local asset = {
		id = r[1],
		imageRectSize = irs,
		imageRectOffset = iro,
	}

	return asset
end
-- Converts ID to asset URI. Returns rbxassetid://0 if ID is not a number
local function getAssetUri(id: any): string
	local assetUri = "rbxassetid://0" -- Default to empty image
	if type(id) == "number" then
		assetUri = "rbxassetid://" .. id
	elseif type(id) == "string" and not Icons then
		warn("Rayfield | Cannot use Lucide icons as icons library is not loaded")
	else
		warn("Rayfield | The icon argument must either be an icon ID (number) or a Lucide icon name (string)")
	end
	return assetUri
end

local function makeDraggable(object, dragObject, enableTaptic, tapticOffset)
	local dragging = false
	local relative = nil

	local offset = Vector2.zero
	local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
	if screenGui and screenGui.IgnoreGuiInset then
		offset += getService('GuiService'):GetGuiInset()
	end

	local function connectFunctions()
		if dragBar and enableTaptic then
			dragBar.MouseEnter:Connect(function()
				if not dragging and not Hidden then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5, Size = UDim2.new(0, 120, 0, 4)}):Play()
				end
			end)

			dragBar.MouseLeave:Connect(function()
				if not dragging and not Hidden then
					TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7, Size = UDim2.new(0, 100, 0, 4)}):Play()
				end
			end)
		end
	end

	connectFunctions()

	dragObject.InputBegan:Connect(function(input, processed)
		if processed then return end

		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = true

			relative = object.AbsolutePosition + object.AbsoluteSize * object.AnchorPoint - UserInputService:GetMouseLocation()
			if enableTaptic and not Hidden then
				TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 4), BackgroundTransparency = 0}):Play()
			end
		end
	end)

	local inputEnded = UserInputService.InputEnded:Connect(function(input)
		if not dragging then return end

		local inputType = input.UserInputType.Name
		if inputType == "MouseButton1" or inputType == "Touch" then
			dragging = false

			connectFunctions()

			if enableTaptic and not Hidden then
				TweenService:Create(dragBarCosmetic, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 100, 0, 4), BackgroundTransparency = 0.7}):Play()
			end
		end
	end)

	local renderStepped = RunService.RenderStepped:Connect(function()
		if dragging and not Hidden then
			local position = UserInputService:GetMouseLocation() + relative + offset
			if enableTaptic and tapticOffset then
				TweenService:Create(object, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y)}):Play()
				TweenService:Create(dragObject.Parent, TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))}):Play()
			else
				if dragBar and tapticOffset then
					dragBar.Position = UDim2.fromOffset(position.X, position.Y + ((useMobileSizing and tapticOffset[2]) or tapticOffset[1]))
				end
				object.Position = UDim2.fromOffset(position.X, position.Y)
			end
		end
	end)

	object.Destroying:Connect(function()
		if inputEnded then inputEnded:Disconnect() end
		if renderStepped then renderStepped:Disconnect() end
	end)
end


local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end    

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function LoadConfiguration(Configuration)
	local success, Data = pcall(function() return HttpService:JSONDecode(Configuration) end)
	local changed

	if not success then warn('Rayfield had an issue decoding the configuration file, please try delete the file and reopen Rayfield.') return end

	-- Iterate through current UI elements' flags
	for FlagName, Flag in pairs(RayfieldLibrary.Flags) do
		local FlagValue = Data[FlagName]

		if (typeof(FlagValue) == 'boolean' and FlagValue == false) or FlagValue then
			task.spawn(function()
				if Flag.Type == "ColorPicker" then
					changed = true
					Flag:Set(UnpackColor(FlagValue))
				else
					if (Flag.CurrentValue or Flag.CurrentKeybind or Flag.CurrentOption or Flag.Color) ~= FlagValue then 
						changed = true
						Flag:Set(FlagValue) 	
					end
				end
			end)
		else
			warn("Rayfield | Unable to find '"..FlagName.. "' in the save file.")
			print("The error above may not be an issue if new elements have been added or not been set values.")
			--RayfieldLibrary:Notify({Title = "Rayfield Flags", Content = "Rayfield was unable to find '"..FlagName.. "' in the save file. Check sirius.menu/discord for help.", Image = 3944688398})
		end
	end

	return changed
end

local function SaveConfiguration()
	if not CEnabled or not globalLoaded then return end

	if debugX then
		print('Saving')
	end

	local Data = {}
	for i, v in pairs(RayfieldLibrary.Flags) do
		if v.Type == "ColorPicker" then
			Data[i] = PackColor(v.Color)
		else
			if typeof(v.CurrentValue) == 'boolean' then
				if v.CurrentValue == false then
					Data[i] = false
				else
					Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
				end
			else
				Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
			end
		end
	end

	if useStudio then
		if script.Parent:FindFirstChild('configuration') then script.Parent.configuration:Destroy() end

		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Parent = script.Parent
		ScreenGui.Name = 'configuration'

		local TextBox = Instance.new("TextBox")
		TextBox.Parent = ScreenGui
		TextBox.Size = UDim2.new(0, 800, 0, 50)
		TextBox.AnchorPoint = Vector2.new(0.5, 0)
		TextBox.Position = UDim2.new(0.5, 0, 0, 30)
		TextBox.Text = HttpService:JSONEncode(Data)
		TextBox.ClearTextOnFocus = false
	end

	if debugX then
		warn(HttpService:JSONEncode(Data))
	end

	if writefile then
		writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
	end
end

function RayfieldLibrary:Notify(data) -- action e.g open messages
	task.spawn(function()

		-- Notification Object Creation
		local newNotification = Notifications.Template:Clone()
		newNotification.Name = data.Title or 'No Title Provided'
		newNotification.Parent = Notifications
		newNotification.LayoutOrder = #Notifications:GetChildren()
		newNotification.Visible = false

		-- Set Data
		newNotification.Title.Text = data.Title or "Unknown Title"
		newNotification.Description.Text = data.Content or "Unknown Content"

		if data.Image then
			if typeof(data.Image) == 'string' and Icons then
				local asset = getIcon(data.Image)

				newNotification.Icon.Image = 'rbxassetid://'..asset.id
				newNotification.Icon.ImageRectOffset = asset.imageRectOffset
				newNotification.Icon.ImageRectSize = asset.imageRectSize
			else
				newNotification.Icon.Image = getAssetUri(data.Image)
			end
		else
			newNotification.Icon.Image = "rbxassetid://" .. 0
		end

		-- Set initial transparency values

		newNotification.Title.TextColor3 = SelectedTheme.TextColor
		newNotification.Description.TextColor3 = SelectedTheme.TextColor
		newNotification.BackgroundColor3 = SelectedTheme.Background
		newNotification.UIStroke.Color = SelectedTheme.TextColor
		newNotification.Icon.ImageColor3 = SelectedTheme.TextColor

		newNotification.BackgroundTransparency = 1
		newNotification.Title.TextTransparency = 1
		newNotification.Description.TextTransparency = 1
		newNotification.UIStroke.Transparency = 1
		newNotification.Shadow.ImageTransparency = 1
		newNotification.Size = UDim2.new(1, 0, 0, 800)
		newNotification.Icon.ImageTransparency = 1
		newNotification.Icon.BackgroundTransparency = 1

		task.wait()

		newNotification.Visible = true

		if data.Actions then
			warn('Rayfield | Not seeing your actions in notifications?')
			print("Notification Actions are being sunset for now, keep up to date on when they're back in the discord. (sirius.menu/discord)")
		end

		-- Calculate textbounds and set initial values
		local bounds = {newNotification.Title.TextBounds.Y, newNotification.Description.TextBounds.Y}
		newNotification.Size = UDim2.new(1, -60, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)

		newNotification.Icon.Size = UDim2.new(0, 32, 0, 32)
		newNotification.Icon.Position = UDim2.new(0, 20, 0.5, 0)

		TweenService:Create(newNotification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + 31, 60))}):Play()

		task.wait(0.15)
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

		task.wait(0.05)

		TweenService:Create(newNotification.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()

		task.wait(0.05)
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.35}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.95}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.82}):Play()

		local waitDuration = math.min(math.max((#newNotification.Description.Text * 0.1) + 2.5, 3), 10)
		task.wait(data.Duration or waitDuration)

		newNotification.Icon.Visible = false
		TweenService:Create(newNotification, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
		TweenService:Create(newNotification.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		TweenService:Create(newNotification.Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		TweenService:Create(newNotification.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
		TweenService:Create(newNotification.Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, 0)}):Play()

		task.wait(1)

		TweenService:Create(newNotification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -90, 0, -Notifications:FindFirstChild("UIListLayout").Padding.Offset)}):Play()

		newNotification.Visible = false
		newNotification:Destroy()
	end)
end

local function openSearch()
	searchOpen = true

	Main.Search.BackgroundTransparency = 1
	Main.Search.Shadow.ImageTransparency = 1
	Main.Search.Input.TextTransparency = 1
	Main.Search.Search.ImageTransparency = 1
	Main.Search.UIStroke.Transparency = 1
	Main.Search.Size = UDim2.new(1, 0, 0, 80)
	Main.Search.Position = UDim2.new(0.5, 0, 0, 70)

	Main.Search.Input.Interactable = true

	Main.Search.Visible = true

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			tabbtn.Interact.Visible = false
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		end
	end

	Main.Search.Input:CaptureFocus()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.05, Enum.EasingStyle.Quint), {ImageTransparency = 0.95}):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0, 57), BackgroundTransparency = 0.9}):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.8}):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
	TweenService:Create(Main.Search, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -35, 0, 35)}):Play()
end

local function closeSearch()
	searchOpen = false

	TweenService:Create(Main.Search, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {BackgroundTransparency = 1, Size = UDim2.new(1, -55, 0, 30)}):Play()
	TweenService:Create(Main.Search.Search, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
	TweenService:Create(Main.Search.Shadow, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
	TweenService:Create(Main.Search.UIStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
	TweenService:Create(Main.Search.Input, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			tabbtn.Interact.Visible = true
			if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			else
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end
	end

	Main.Search.Input.Text = ''
	Main.Search.Input.Interactable = false
end

local function Hide(notify: boolean?)
	if MPrompt then
		UserInputService.MouseIconEnabled = false
		MPrompt.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		MPrompt.Position = UDim2.new(0.5, 0, 0, -50)
		MPrompt.Size = UDim2.new(0, 40, 0, 10)
		MPrompt.BackgroundTransparency = 1
		MPrompt.Title.TextTransparency = 1
		MPrompt.Visible = true
	end

	task.spawn(closeSearch)

	Debounce = true
	if notify then
		if useMobilePrompt then 
			RayfieldLibrary:Notify({Title = "Interface Hidden", Content = "The interface has been hidden, you can unhide the interface by tapping 'Show Rayfield'.", Duration = 7, Image = 4400697855})
		else
			RayfieldLibrary:Notify({Title = "Interface Hidden", Content = `The interface has been hidden, you can unhide the interface by tapping {settingsTable.General.rayfieldOpen.Value or 'K'}.`, Duration = 7, Image = 4400697855})
		end
	end

	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 0)}):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 470, 0, 45)}):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
	TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()

	if useMobilePrompt and MPrompt then
		TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 120, 0, 30), Position = UDim2.new(0.5, 0, 0, 20), BackgroundTransparency = 0.3}):Play()
		TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.3}):Play()
	end

	for _, TopbarButton in ipairs(Topbar:GetChildren()) do
		if TopbarButton.ClassName == "ImageButton" then
			TweenService:Create(TopbarButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
		end
	end

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		end
	end

	dragInteract.Visible = false

	for _, tab in ipairs(Elements:GetChildren()) do
		if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
			for _, element in ipairs(tab:GetChildren()) do
				if element.ClassName == "Frame" then
					if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
						if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						elseif element.Name == 'Divider' then
							TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
						else
							TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
							TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						end
						for _, child in ipairs(element:GetChildren()) do
							if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
								child.Visible = false
							end
						end
					end
				end
			end
		end
	end

	task.wait(0.5)
	Main.Visible = false
	Debounce = false
end

local function Maximise()
	Debounce = true
	Topbar.ChangeSize.Image = "rbxassetid://"..10137941941

	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
	TabList.Visible = true
	task.wait(0.2)

	Elements.Visible = true

	for _, tab in ipairs(Elements:GetChildren()) do
		if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
			for _, element in ipairs(tab:GetChildren()) do
				if element.ClassName == "Frame" then
					if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
						if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()
						elseif element.Name == 'Divider' then
							TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.85}):Play()
						else
							TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
						end
						for _, child in ipairs(element:GetChildren()) do
							if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
								child.Visible = true
							end
						end
					end
				end
			end
		end
	end

	task.wait(0.1)

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			else
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end

		end
	end

	task.wait(0.5)
	Debounce = false
end


local function Unhide()
	UserInputService.MouseIconEnabled = true
	Debounce = true
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Visible = true
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 45)}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Main.Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Main.Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Main.Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Main.Topbar.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

	if MPrompt then
		TweenService:Create(MPrompt, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 40, 0, 10), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 1}):Play()
		TweenService:Create(MPrompt.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		task.spawn(function()
			task.wait(0.5)
			MPrompt.Visible = false
		end)
	end

	if Minimised then
		task.spawn(Maximise)
	end

	dragBar.Position = useMobileSizing and UDim2.new(0.5, 0, 0.5, dragOffsetMobile) or UDim2.new(0.5, 0, 0.5, dragOffset)

	dragInteract.Visible = true

	for _, TopbarButton in ipairs(Topbar:GetChildren()) do
		if TopbarButton.ClassName == "ImageButton" then
			if TopbarButton.Name == 'Icon' then
				TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			else
				TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
			end

		end
	end

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			if tostring(Elements.UIPageLayout.CurrentPage) == tabbtn.Title.Text then
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			else
				TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
				TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
			end
		end
	end

	for _, tab in ipairs(Elements:GetChildren()) do
		if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
			for _, element in ipairs(tab:GetChildren()) do
				if element.ClassName == "Frame" then
					if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
						if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()
						elseif element.Name == 'Divider' then
							TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.85}):Play()
						else
							TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
						end
						for _, child in ipairs(element:GetChildren()) do
							if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
								child.Visible = true
							end
						end
					end
				end
			end
		end
	end

	TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}):Play()

	task.wait(0.5)
	Minimised = false
	Debounce = false
end

local function Minimise()
	Debounce = true
	Topbar.ChangeSize.Image = "rbxassetid://"..11036884234

	Topbar.UIStroke.Color = SelectedTheme.ElementStroke

	task.spawn(closeSearch)

	for _, tabbtn in ipairs(TabList:GetChildren()) do
		if tabbtn.ClassName == "Frame" and tabbtn.Name ~= "Placeholder" then
			TweenService:Create(tabbtn, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			TweenService:Create(tabbtn.Image, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			TweenService:Create(tabbtn.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			TweenService:Create(tabbtn.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
		end
	end

	for _, tab in ipairs(Elements:GetChildren()) do
		if tab.Name ~= "Template" and tab.ClassName == "ScrollingFrame" and tab.Name ~= "Placeholder" then
			for _, element in ipairs(tab:GetChildren()) do
				if element.ClassName == "Frame" then
					if element.Name ~= "SectionSpacing" and element.Name ~= "Placeholder" then
						if element.Name == "SectionTitle" or element.Name == 'SearchTitle-fsefsefesfsefesfesfThanks' then
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						elseif element.Name == 'Divider' then
							TweenService:Create(element.Divider, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
						else
							TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
							TweenService:Create(element.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							TweenService:Create(element.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						end
						for _, child in ipairs(element:GetChildren()) do
							if child.ClassName == "Frame" or child.ClassName == "TextLabel" or child.ClassName == "TextBox" or child.ClassName == "ImageButton" or child.ClassName == "ImageLabel" then
								child.Visible = false
							end
						end
					end
				end
			end
		end
	end

	TweenService:Create(dragBarCosmetic, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Topbar.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Topbar.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 495, 0, 45)}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 495, 0, 45)}):Play()

	task.wait(0.3)

	Elements.Visible = false
	TabList.Visible = false

	task.wait(0.2)
	Debounce = false
end

local function updateSettings()
	local encoded
	local success, err = pcall(function()
		encoded = HttpService:JSONEncode(settingsTable)
	end)

	if success then
		if useStudio then
			if script.Parent['get.val'] then
				script.Parent['get.val'].Value = encoded
			end
		end
		if writefile then
			writefile(RayfieldFolder..'/settings'..ConfigurationExtension, encoded)
		end
	end
end

local function createSettings(window)
	if not (writefile and isfile and readfile and isfolder and makefolder) and not useStudio then
		if Topbar['Settings'] then Topbar.Settings.Visible = false end
		Topbar['Search'].Position = UDim2.new(1, -75, 0.5, 0)
		warn('Can\'t create settings as no file-saving functionality is available.')
		return
	end

	local newTab = window:CreateTab('Rayfield Settings', 0, true)

	if TabList['Rayfield Settings'] then
		TabList['Rayfield Settings'].LayoutOrder = 1000
	end

	if Elements['Rayfield Settings'] then
		Elements['Rayfield Settings'].LayoutOrder = 1000
	end

	-- Create sections and elements
	for categoryName, settingCategory in pairs(settingsTable) do
		newTab:CreateSection(categoryName)

		for _, setting in pairs(settingCategory) do
			if setting.Type == 'input' then
				setting.Element = newTab:CreateInput({
					Name = setting.Name,
					CurrentValue = setting.Value,
					PlaceholderText = setting.Placeholder,
					Ext = true,
					RemoveTextAfterFocusLost = setting.ClearOnFocus,
					Callback = function(Value)
						setting.Value = Value
						updateSettings()
					end,
				})
			elseif setting.Type == 'toggle' then
				setting.Element = newTab:CreateToggle({
					Name = setting.Name,
					CurrentValue = setting.Value,
					Ext = true,
					Callback = function(Value)
						setting.Value = Value
						updateSettings()
					end,
				})
			elseif setting.Type == 'bind' then
				setting.Element = newTab:CreateKeybind({
					Name = setting.Name,
					CurrentKeybind = setting.Value,
					HoldToInteract = false,
					Ext = true,
					CallOnChange = true,
					Callback = function(Value)
						setting.Value = Value
						updateSettings()
					end,
				})
			end
		end
	end

	settingsCreated = true
	loadSettings()
	updateSettings()
end



function RayfieldLibrary:CreateWindow(Settings)
	if Rayfield:FindFirstChild('Loading') then
		if getgenv and not getgenv().rayfieldCached then
			Rayfield.Enabled = true
			Rayfield.Loading.Visible = true

			task.wait(1.4)
			Rayfield.Loading.Visible = false
		end
	end

	if getgenv then getgenv().rayfieldCached = true end

	if not correctBuild and not Settings.DisableBuildWarnings then
		task.delay(3, 
			function() 
				RayfieldLibrary:Notify({Title = 'Build Mismatch', Content = 'Rayfield may encounter issues as you are running an incompatible interface version ('.. ((Rayfield:FindFirstChild('Build') and Rayfield.Build.Value) or 'No Build') ..').\n\nThis version of Rayfield is intended for interface build '..InterfaceBuild..'.\n\nTry rejoining and then run the script twice.', Image = 4335487866, Duration = 15})		
			end)
	end

	if isfolder and not isfolder(RayfieldFolder) then
		makefolder(RayfieldFolder)
	end

	local Passthrough = false
	Topbar.Title.Text = Settings.Name

	Main.Size = UDim2.new(0, 420, 0, 100)
	Main.Visible = true
	Main.BackgroundTransparency = 1
	if Main:FindFirstChild('Notice') then Main.Notice.Visible = false end
	Main.Shadow.Image.ImageTransparency = 1

	LoadingFrame.Title.TextTransparency = 1
	LoadingFrame.Subtitle.TextTransparency = 1

	LoadingFrame.Version.TextTransparency = 1
	LoadingFrame.Title.Text = Settings.LoadingTitle or "Rayfield"
	LoadingFrame.Subtitle.Text = Settings.LoadingSubtitle or "Interface Suite"

	if Settings.LoadingTitle ~= "Rayfield Interface Suite" then
		LoadingFrame.Version.Text = "Rayfield UI"
	end

	if Settings.Icon and Settings.Icon ~= 0 and Topbar:FindFirstChild('Icon') then
		Topbar.Icon.Visible = true
		Topbar.Title.Position = UDim2.new(0, 47, 0.5, 0)

		if Settings.Icon then
			if typeof(Settings.Icon) == 'string' and Icons then
				local asset = getIcon(Settings.Icon)

				Topbar.Icon.Image = 'rbxassetid://'..asset.id
				Topbar.Icon.ImageRectOffset = asset.imageRectOffset
				Topbar.Icon.ImageRectSize = asset.imageRectSize
			else
				Topbar.Icon.Image = getAssetUri(Settings.Icon)
			end
		else
			Topbar.Icon.Image = "rbxassetid://" .. 0
		end
	end

	if dragBar then
		dragBar.Visible = false
		dragBarCosmetic.BackgroundTransparency = 1
		dragBar.Visible = true
	end

	if Settings.Theme then
		local success, result = pcall(ChangeTheme, Settings.Theme)
		if not success then
			local success, result2 = pcall(ChangeTheme, 'Default')
			if not success then
				warn('CRITICAL ERROR - NO DEFAULT THEME')
				print(result2)
			end
			warn('issue rendering theme. no theme on file')
			print(result)
		end
	end

	Topbar.Visible = false
	Elements.Visible = false
	LoadingFrame.Visible = true

	if not Settings.DisableRayfieldPrompts then
		task.spawn(function()
			while true do
				task.wait(math.random(180, 600))
				RayfieldLibrary:Notify({
					Title = "Rayfield Interface",
					Content = "Enjoying this UI library? Find it at sirius.menu/discord",
					Duration = 7,
					Image = 4370033185,
				})
			end
		end)
	end

	pcall(function()
		if not Settings.ConfigurationSaving.FileName then
			Settings.ConfigurationSaving.FileName = tostring(game.PlaceId)
		end

		if Settings.ConfigurationSaving.Enabled == nil then
			Settings.ConfigurationSaving.Enabled = false
		end

		CFileName = Settings.ConfigurationSaving.FileName
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
		CEnabled = Settings.ConfigurationSaving.Enabled

		if Settings.ConfigurationSaving.Enabled then
			if not isfolder(ConfigurationFolder) then
				makefolder(ConfigurationFolder)
			end	
		end
	end)


	makeDraggable(Main, Topbar, false, {dragOffset, dragOffsetMobile})
	if dragBar then dragBar.Position = useMobileSizing and UDim2.new(0.5, 0, 0.5, dragOffsetMobile) or UDim2.new(0.5, 0, 0.5, dragOffset) makeDraggable(Main, dragInteract, true, {dragOffset, dragOffsetMobile}) end

	for _, TabButton in ipairs(TabList:GetChildren()) do
		if TabButton.ClassName == "Frame" and TabButton.Name ~= "Placeholder" then
			TabButton.BackgroundTransparency = 1
			TabButton.Title.TextTransparency = 1
			TabButton.Image.ImageTransparency = 1
			TabButton.UIStroke.Transparency = 1
		end
	end

	if Settings.Discord and not useStudio then
		if isfolder and not isfolder(RayfieldFolder.."/Discord Invites") then
			makefolder(RayfieldFolder.."/Discord Invites")
		end

		if isfile and not isfile(RayfieldFolder.."/Discord Invites/"..Settings.Discord.Invite..ConfigurationExtension) then
			if request then
				pcall(function()
					request({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = 'POST',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = HttpService:JSONEncode({
							cmd = 'INVITE_BROWSER',
							nonce = HttpService:GenerateGUID(false),
							args = {code = Settings.Discord.Invite}
						})
					})
				end)
			end

			if Settings.Discord.RememberJoins then -- We do logic this way so if the developer changes this setting, the user still won't be prompted, only new users
				writefile(RayfieldFolder.."/Discord Invites/"..Settings.Discord.Invite..ConfigurationExtension,"Rayfield RememberJoins is true for this invite, this invite will not ask you to join again")
			end
		end
	end

	if (Settings.KeySystem) then
		if not Settings.KeySettings then
			Passthrough = true
			return
		end

		if isfolder and not isfolder(RayfieldFolder.."/Key System") then
			makefolder(RayfieldFolder.."/Key System")
		end

		if typeof(Settings.KeySettings.Key) == "string" then Settings.KeySettings.Key = {Settings.KeySettings.Key} end

		if Settings.KeySettings.GrabKeyFromSite then
			for i, Key in ipairs(Settings.KeySettings.Key) do
				local Success, Response = pcall(function()
					Settings.KeySettings.Key[i] = tostring(game:HttpGet(Key):gsub("[\n\r]", " "))
					Settings.KeySettings.Key[i] = string.gsub(Settings.KeySettings.Key[i], " ", "")
				end)
				if not Success then
					print("Rayfield | "..Key.." Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
				end
			end
		end

		if not Settings.KeySettings.FileName then
			Settings.KeySettings.FileName = "No file name specified"
		end

		if isfile and isfile(RayfieldFolder.."/Key System/"..Settings.KeySettings.FileName..ConfigurationExtension) then
			for _, MKey in ipairs(Settings.KeySettings.Key) do
				if string.find(readfile(RayfieldFolder.."/Key System/"..Settings.KeySettings.FileName..ConfigurationExtension), MKey) then
					Passthrough = true
				end
			end
		end

		if not Passthrough then
			local AttemptsRemaining = math.random(2, 5)
			Rayfield.Enabled = false
			local KeyUI = useStudio and script.Parent:FindFirstChild('Key') or game:GetObjects("rbxassetid://11380036235")[1]

			KeyUI.Enabled = true

			if gethui then
				KeyUI.Parent = gethui()
			elseif syn and syn.protect_gui then 
				syn.protect_gui(KeyUI)
				KeyUI.Parent = CoreGui
			elseif not useStudio and CoreGui:FindFirstChild("RobloxGui") then
				KeyUI.Parent = CoreGui:FindFirstChild("RobloxGui")
			elseif not useStudio then
				KeyUI.Parent = CoreGui
			end

			if gethui then
				for _, Interface in ipairs(gethui():GetChildren()) do
					if Interface.Name == KeyUI.Name and Interface ~= KeyUI then
						Interface.Enabled = false
						Interface.Name = "KeyUI-Old"
					end
				end
			elseif not useStudio then
				for _, Interface in ipairs(CoreGui:GetChildren()) do
					if Interface.Name == KeyUI.Name and Interface ~= KeyUI then
						Interface.Enabled = false
						Interface.Name = "KeyUI-Old"
					end
				end
			end

			local KeyMain = KeyUI.Main
			KeyMain.Title.Text = Settings.KeySettings.Title or Settings.Name
			KeyMain.Subtitle.Text = Settings.KeySettings.Subtitle or "Key System"
			KeyMain.NoteMessage.Text = Settings.KeySettings.Note or "No instructions"

			KeyMain.Size = UDim2.new(0, 467, 0, 175)
			KeyMain.BackgroundTransparency = 1
			KeyMain.Shadow.Image.ImageTransparency = 1
			KeyMain.Title.TextTransparency = 1
			KeyMain.Subtitle.TextTransparency = 1
			KeyMain.KeyNote.TextTransparency = 1
			KeyMain.Input.BackgroundTransparency = 1
			KeyMain.Input.UIStroke.Transparency = 1
			KeyMain.Input.InputBox.TextTransparency = 1
			KeyMain.NoteTitle.TextTransparency = 1
			KeyMain.NoteMessage.TextTransparency = 1
			KeyMain.Hide.ImageTransparency = 1

			TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 187)}):Play()
			TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
			task.wait(0.05)
			TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			task.wait(0.05)
			TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			task.wait(0.05)
			TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			task.wait(0.15)
			TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {ImageTransparency = 0.3}):Play()


			KeyUI.Main.Input.InputBox.FocusLost:Connect(function()
				if #KeyUI.Main.Input.InputBox.Text == 0 then return end
				local KeyFound = false
				local FoundKey = ''
				for _, MKey in ipairs(Settings.KeySettings.Key) do
					--if string.find(KeyMain.Input.InputBox.Text, MKey) then
					--	KeyFound = true
					--	FoundKey = MKey
					--end


					-- stricter key check
					if KeyMain.Input.InputBox.Text == MKey then
						KeyFound = true
						FoundKey = MKey
					end
				end
				if KeyFound then 
					TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 467, 0, 175)}):Play()
					TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					task.wait(0.51)
					Passthrough = true
					KeyMain.Visible = false
					if Settings.KeySettings.SaveKey then
						if writefile then
							writefile(RayfieldFolder.."/Key System/"..Settings.KeySettings.FileName..ConfigurationExtension, FoundKey)
						end
						RayfieldLibrary:Notify({Title = "Key System", Content = "The key for this script has been saved successfully.", Image = 3605522284})
					end
				else
					if AttemptsRemaining == 0 then
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
						TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 467, 0, 175)}):Play()
						TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
						TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
						TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
						TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
						task.wait(0.45)
						Players.LocalPlayer:Kick("No Attempts Remaining")
						game:Shutdown()
					end
					KeyMain.Input.InputBox.Text = ""
					AttemptsRemaining = AttemptsRemaining - 1
					TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 467, 0, 175)}):Play()
					TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Position = UDim2.new(0.495,0,0.5,0)}):Play()
					task.wait(0.1)
					TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Position = UDim2.new(0.505,0,0.5,0)}):Play()
					task.wait(0.1)
					TweenService:Create(KeyMain, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5,0,0.5,0)}):Play()
					TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 500, 0, 187)}):Play()
				end
			end)

			KeyMain.Hide.MouseButton1Click:Connect(function()
				TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				TweenService:Create(KeyMain, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 467, 0, 175)}):Play()
				TweenService:Create(KeyMain.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				TweenService:Create(KeyMain.Title, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.Subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.KeyNote, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.Input, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				TweenService:Create(KeyMain.Input.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				TweenService:Create(KeyMain.Input.InputBox, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.NoteTitle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.NoteMessage, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
				TweenService:Create(KeyMain.Hide, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
				task.wait(0.51)
				RayfieldLibrary:Destroy()
				KeyUI:Destroy()
			end)
		else
			Passthrough = true
		end
	end
	if Settings.KeySystem then
		repeat task.wait() until Passthrough
	end

	Notifications.Template.Visible = false
	Notifications.Visible = true
	Rayfield.Enabled = true

	task.wait(0.5)
	TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()
	task.wait(0.1)
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	task.wait(0.05)
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	task.wait(0.05)
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()


	Elements.Template.LayoutOrder = 100000
	Elements.Template.Visible = false

	Elements.UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
	TabList.Template.Visible = false

	-- Tab
	local FirstTab = false
	local Window = {}
	function Window:CreateTab(Name, Image, Ext)
		local SDone = false
		local TabButton = TabList.Template:Clone()
		TabButton.Name = Name
		TabButton.Title.Text = Name
		TabButton.Parent = TabList
		TabButton.Title.TextWrapped = false
		TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 30, 0, 30)

		if Image and Image ~= 0 then
			if typeof(Image) == 'string' and Icons then
				local asset = getIcon(Image)

				TabButton.Image.Image = 'rbxassetid://'..asset.id
				TabButton.Image.ImageRectOffset = asset.imageRectOffset
				TabButton.Image.ImageRectSize = asset.imageRectSize
			else
				TabButton.Image.Image = getAssetUri(Image)
			end

			TabButton.Title.AnchorPoint = Vector2.new(0, 0.5)
			TabButton.Title.Position = UDim2.new(0, 37, 0.5, 0)
			TabButton.Image.Visible = true
			TabButton.Title.TextXAlignment = Enum.TextXAlignment.Left
			TabButton.Size = UDim2.new(0, TabButton.Title.TextBounds.X + 52, 0, 30)
		end



		TabButton.BackgroundTransparency = 1
		TabButton.Title.TextTransparency = 1
		TabButton.Image.ImageTransparency = 1
		TabButton.UIStroke.Transparency = 1

		TabButton.Visible = not Ext or false

		-- Create Elements Page
		local TabPage = Elements.Template:Clone()
		TabPage.Name = Name
		TabPage.Visible = true

		TabPage.LayoutOrder = #Elements:GetChildren() or Ext and 10000

		for _, TemplateElement in ipairs(TabPage:GetChildren()) do
			if TemplateElement.ClassName == "Frame" and TemplateElement.Name ~= "Placeholder" then
				TemplateElement:Destroy()
			end
		end

		TabPage.Parent = Elements
		if not FirstTab and not Ext then
			Elements.UIPageLayout.Animated = false
			Elements.UIPageLayout:JumpTo(TabPage)
			Elements.UIPageLayout.Animated = true
		end

		TabButton.UIStroke.Color = SelectedTheme.TabStroke

		if Elements.UIPageLayout.CurrentPage == TabPage then
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
		else
			TabButton.BackgroundColor3 = SelectedTheme.TabBackground
			TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
		end


		-- Animate
		task.wait(0.1)
		if FirstTab or Ext then
			TabButton.BackgroundColor3 = SelectedTheme.TabBackground
			TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
			TweenService:Create(TabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
		elseif not Ext then
			FirstTab = Name
			TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
			TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
			TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		end


		TabButton.Interact.MouseButton1Click:Connect(function()
			if Minimised then return end
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(TabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
			TweenService:Create(TabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.TabBackgroundSelected}):Play()
			TweenService:Create(TabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextColor3 = SelectedTheme.SelectedTabTextColor}):Play()
			TweenService:Create(TabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageColor3 = SelectedTheme.SelectedTabTextColor}):Play()

			for _, OtherTabButton in ipairs(TabList:GetChildren()) do
				if OtherTabButton.Name ~= "Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton and OtherTabButton.Name ~= "Placeholder" then
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.TabBackground}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end

			if Elements.UIPageLayout.CurrentPage ~= TabPage then
				Elements.UIPageLayout:JumpTo(TabPage)
			end
		end)

		local Tab = {}

		-- Button
		function Tab:CreateButton(ButtonSettings)
			local ButtonValue = {}

			local Button = Elements.Template.Button:Clone()
			Button.Name = ButtonSettings.Name
			Button.Title.Text = ButtonSettings.Name
			Button.Visible = true
			Button.Parent = TabPage

			Button.BackgroundTransparency = 1
			Button.UIStroke.Transparency = 1
			Button.Title.TextTransparency = 1

			TweenService:Create(Button, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Button.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Button.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	


			Button.Interact.MouseButton1Click:Connect(function()
				local Success, Response = pcall(ButtonSettings.Callback)
				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Button.Title.Text = "Callback Error"
					print("Rayfield | "..ButtonSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Button.Title.Text = ButtonSettings.Name
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0.9}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				else
					if not ButtonSettings.Ext then
						SaveConfiguration(ButtonSettings.Name..'\n')
					end
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					task.wait(0.2)
					TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0.9}):Play()
					TweenService:Create(Button.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end
			end)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0.7}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Button.ElementIndicator, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0.9}):Play()
			end)

			function ButtonValue:Set(NewButton)
				Button.Title.Text = NewButton
				Button.Name = NewButton
			end

			return ButtonValue
		end

		-- ColorPicker
		function Tab:CreateColorPicker(ColorPickerSettings) -- by Throit
			ColorPickerSettings.Type = "ColorPicker"
			local ColorPicker = Elements.Template.ColorPicker:Clone()
			local Background = ColorPicker.CPBackground
			local Display = Background.Display
			local Main = Background.MainCP
			local Slider = ColorPicker.ColorSlider
			ColorPicker.ClipsDescendants = true
			ColorPicker.Name = ColorPickerSettings.Name
			ColorPicker.Title.Text = ColorPickerSettings.Name
			ColorPicker.Visible = true
			ColorPicker.Parent = TabPage
			ColorPicker.Size = UDim2.new(1, -10, 0, 45)
			Background.Size = UDim2.new(0, 39, 0, 22)
			Display.BackgroundTransparency = 0
			Main.MainPoint.ImageTransparency = 1
			ColorPicker.Interact.Size = UDim2.new(1, 0, 1, 0)
			ColorPicker.Interact.Position = UDim2.new(0.5, 0, 0.5, 0)
			ColorPicker.RGB.Position = UDim2.new(0, 17, 0, 70)
			ColorPicker.HexInput.Position = UDim2.new(0, 17, 0, 90)
			Main.ImageTransparency = 1
			Background.BackgroundTransparency = 1

			for _, rgbinput in ipairs(ColorPicker.RGB:GetChildren()) do
				if rgbinput:IsA("Frame") then
					rgbinput.BackgroundColor3 = SelectedTheme.InputBackground
					rgbinput.UIStroke.Color = SelectedTheme.InputStroke
				end
			end

			ColorPicker.HexInput.BackgroundColor3 = SelectedTheme.InputBackground
			ColorPicker.HexInput.UIStroke.Color = SelectedTheme.InputStroke

			local opened = false 
			local mouse = Players.LocalPlayer:GetMouse()
			Main.Image = "http://www.roblox.com/asset/?id=11415645739"
			local mainDragging = false 
			local sliderDragging = false 
			ColorPicker.Interact.MouseButton1Down:Connect(function()
				task.spawn(function()
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					task.wait(0.2)
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(ColorPicker.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end)

				if not opened then
					opened = true 
					TweenService:Create(Background, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 18, 0, 15)}):Play()
					task.wait(0.1)
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 120)}):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 173, 0, 86)}):Play()
					TweenService:Create(Display, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.289, 0, 0.5, 0)}):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 40)}):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 73)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0.574, 0, 1, 0)}):Play()
					TweenService:Create(Main.MainPoint, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
					TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = SelectedTheme ~= RayfieldLibrary.Theme.Default and 0.25 or 0.1}):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
				else
					opened = false
					TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 45)}):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(0, 39, 0, 22)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 1, 0)}):Play()
					TweenService:Create(ColorPicker.Interact, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
					TweenService:Create(ColorPicker.RGB, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 70)}):Play()
					TweenService:Create(ColorPicker.HexInput, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 17, 0, 90)}):Play()
					TweenService:Create(Display, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
					TweenService:Create(Main.MainPoint, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
					TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
				end

			end)

			UserInputService.InputEnded:Connect(function(input, gameProcessed) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
					mainDragging = false
					sliderDragging = false
				end end)
			Main.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Main.MainPoint.MouseButton1Down:Connect(function()
				if opened then
					mainDragging = true 
				end
			end)
			Slider.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			Slider.SliderPoint.MouseButton1Down:Connect(function()
				sliderDragging = true 
			end)
			local h,s,v = ColorPickerSettings.Color:ToHSV()
			local color = Color3.fromHSV(h,s,v) 
			local hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
			ColorPicker.HexInput.InputBox.Text = hex
			local function setDisplay()
				--Main
				Main.MainPoint.Position = UDim2.new(s,-Main.MainPoint.AbsoluteSize.X/2,1-v,-Main.MainPoint.AbsoluteSize.Y/2)
				Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
				Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
				Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
				--Slider 
				local x = h * Slider.AbsoluteSize.X
				Slider.SliderPoint.Position = UDim2.new(0,x-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
				Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
				local color = Color3.fromHSV(h,s,v) 
				local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
				ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
				ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
				hex = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
				ColorPicker.HexInput.InputBox.Text = hex
			end
			setDisplay()
			ColorPicker.HexInput.InputBox.FocusLost:Connect(function()
				if not pcall(function()
						local r, g, b = string.match(ColorPicker.HexInput.InputBox.Text, "^#?(%w%w)(%w%w)(%w%w)$")
						local rgbColor = Color3.fromRGB(tonumber(r, 16),tonumber(g, 16), tonumber(b, 16))
						h,s,v = rgbColor:ToHSV()
						hex = ColorPicker.HexInput.InputBox.Text
						setDisplay()
						ColorPickerSettings.Color = rgbColor
					end) 
				then 
					ColorPicker.HexInput.InputBox.Text = hex 
				end
				pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				if not ColorPickerSettings.Ext then
					SaveConfiguration(ColorPickerSettings.Flag..'\n'..tostring(ColorPickerSettings.Color))
				end
			end)
			--RGB
			local function rgbBoxes(box,toChange)
				local value = tonumber(box.Text) 
				local color = Color3.fromHSV(h,s,v) 
				local oldR,oldG,oldB = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
				local save 
				if toChange == "R" then save = oldR;oldR = value elseif toChange == "G" then save = oldG;oldG = value else save = oldB;oldB = value end
				if value then 
					value = math.clamp(value,0,255)
					h,s,v = Color3.fromRGB(oldR,oldG,oldB):ToHSV()

					setDisplay()
				else 
					box.Text = tostring(save)
				end
				local r,g,b = math.floor((h*255)+0.5),math.floor((s*255)+0.5),math.floor((v*255)+0.5)
				ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
				if not ColorPickerSettings.Ext then
					SaveConfiguration()
				end
			end
			ColorPicker.RGB.RInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.RInput.InputBox,"R")
				pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
			end)
			ColorPicker.RGB.GInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.GInput.InputBox,"G")
				pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
			end)
			ColorPicker.RGB.BInput.InputBox.FocusLost:connect(function()
				rgbBoxes(ColorPicker.RGB.BInput.InputBox,"B")
				pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
			end)

			RunService.RenderStepped:connect(function()
				if mainDragging then 
					local localX = math.clamp(mouse.X-Main.AbsolutePosition.X,0,Main.AbsoluteSize.X)
					local localY = math.clamp(mouse.Y-Main.AbsolutePosition.Y,0,Main.AbsoluteSize.Y)
					Main.MainPoint.Position = UDim2.new(0,localX-Main.MainPoint.AbsoluteSize.X/2,0,localY-Main.MainPoint.AbsoluteSize.Y/2)
					s = localX / Main.AbsoluteSize.X
					v = 1 - (localY / Main.AbsoluteSize.Y)
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
					if not ColorPickerSettings.Ext then
						SaveConfiguration()
					end
				end
				if sliderDragging then 
					local localX = math.clamp(mouse.X-Slider.AbsolutePosition.X,0,Slider.AbsoluteSize.X)
					h = localX / Slider.AbsoluteSize.X
					Display.BackgroundColor3 = Color3.fromHSV(h,s,v)
					Slider.SliderPoint.Position = UDim2.new(0,localX-Slider.SliderPoint.AbsoluteSize.X/2,0.5,0)
					Slider.SliderPoint.ImageColor3 = Color3.fromHSV(h,1,1)
					Background.BackgroundColor3 = Color3.fromHSV(h,1,1)
					Main.MainPoint.ImageColor3 = Color3.fromHSV(h,s,v)
					local color = Color3.fromHSV(h,s,v) 
					local r,g,b = math.floor((color.R*255)+0.5),math.floor((color.G*255)+0.5),math.floor((color.B*255)+0.5)
					ColorPicker.RGB.RInput.InputBox.Text = tostring(r)
					ColorPicker.RGB.GInput.InputBox.Text = tostring(g)
					ColorPicker.RGB.BInput.InputBox.Text = tostring(b)
					ColorPicker.HexInput.InputBox.Text = string.format("#%02X%02X%02X",color.R*0xFF,color.G*0xFF,color.B*0xFF)
					pcall(function()ColorPickerSettings.Callback(Color3.fromHSV(h,s,v))end)
					ColorPickerSettings.Color = Color3.fromRGB(r,g,b)
					if not ColorPickerSettings.Ext then
						SaveConfiguration()
					end
				end
			end)

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and ColorPickerSettings.Flag then
					RayfieldLibrary.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
				end
			end

			function ColorPickerSettings:Set(RGBColor)
				ColorPickerSettings.Color = RGBColor
				h,s,v = ColorPickerSettings.Color:ToHSV()
				color = Color3.fromHSV(h,s,v)
				setDisplay()
			end

			ColorPicker.MouseEnter:Connect(function()
				TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			ColorPicker.MouseLeave:Connect(function()
				TweenService:Create(ColorPicker, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				for _, rgbinput in ipairs(ColorPicker.RGB:GetChildren()) do
					if rgbinput:IsA("Frame") then
						rgbinput.BackgroundColor3 = SelectedTheme.InputBackground
						rgbinput.UIStroke.Color = SelectedTheme.InputStroke
					end
				end

				ColorPicker.HexInput.BackgroundColor3 = SelectedTheme.InputBackground
				ColorPicker.HexInput.UIStroke.Color = SelectedTheme.InputStroke
			end)

			return ColorPickerSettings
		end

		-- Section
		function Tab:CreateSection(SectionName)

			local SectionValue = {}

			if SDone then
				local SectionSpace = Elements.Template.SectionSpacing:Clone()
				SectionSpace.Visible = true
				SectionSpace.Parent = TabPage
			end

			local Section = Elements.Template.SectionTitle:Clone()
			Section.Title.Text = SectionName
			Section.Visible = true
			Section.Parent = TabPage

			Section.Title.TextTransparency = 1
			TweenService:Create(Section.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.4}):Play()

			function SectionValue:Set(NewSection)
				Section.Title.Text = NewSection
			end

			SDone = true

			return SectionValue
		end

		-- Divider
		function Tab:CreateDivider()
			local DividerValue = {}

			local Divider = Elements.Template.Divider:Clone()
			Divider.Visible = true
			Divider.Parent = TabPage

			Divider.Divider.BackgroundTransparency = 1
			TweenService:Create(Divider.Divider, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.85}):Play()

			function DividerValue:Set(Value)
				Divider.Visible = Value
			end

			return DividerValue
		end

		-- Label
		function Tab:CreateLabel(LabelText : string, Icon: number, Color : Color3, IgnoreTheme : boolean)
			local LabelValue = {}

			local Label = Elements.Template.Label:Clone()
			Label.Title.Text = LabelText
			Label.Visible = true
			Label.Parent = TabPage

			Label.BackgroundColor3 = Color or SelectedTheme.SecondaryElementBackground
			Label.UIStroke.Color = Color or SelectedTheme.SecondaryElementStroke

			if Icon then
				if typeof(Icon) == 'string' and Icons then
					local asset = getIcon(Icon)

					Label.Icon.Image = 'rbxassetid://'..asset.id
					Label.Icon.ImageRectOffset = asset.imageRectOffset
					Label.Icon.ImageRectSize = asset.imageRectSize
				else
					Label.Icon.Image = getAssetUri(Icon)
				end
			else
				Label.Icon.Image = "rbxassetid://" .. 0
			end

			if Icon and Label:FindFirstChild('Icon') then
				Label.Title.Position = UDim2.new(0, 45, 0.5, 0)
				Label.Title.Size = UDim2.new(1, -100, 0, 14)

				if Icon then
					if typeof(Icon) == 'string' and Icons then
						local asset = getIcon(Icon)

						Label.Icon.Image = 'rbxassetid://'..asset.id
						Label.Icon.ImageRectOffset = asset.imageRectOffset
						Label.Icon.ImageRectSize = asset.imageRectSize
					else
						Label.Icon.Image = getAssetUri(Icon)
					end
				else
					Label.Icon.Image = "rbxassetid://" .. 0
				end

				Label.Icon.Visible = true
			end

			Label.Icon.ImageTransparency = 1
			Label.BackgroundTransparency = 1
			Label.UIStroke.Transparency = 1
			Label.Title.TextTransparency = 1

			TweenService:Create(Label, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = Color and 0.8 or 0}):Play()
			TweenService:Create(Label.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = Color and 0.7 or 0}):Play()
			TweenService:Create(Label.Icon, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
			TweenService:Create(Label.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = Color and 0.2 or 0}):Play()	

			function LabelValue:Set(NewLabel, Icon, Color)
				Label.Title.Text = NewLabel

				if Color then
					Label.BackgroundColor3 = Color or SelectedTheme.SecondaryElementBackground
					Label.UIStroke.Color = Color or SelectedTheme.SecondaryElementStroke
				end

				if Icon and Label:FindFirstChild('Icon') then
					Label.Title.Position = UDim2.new(0, 45, 0.5, 0)
					Label.Title.Size = UDim2.new(1, -100, 0, 14)

					if Icon then
						if typeof(Icon) == 'string' and Icons then
							local asset = getIcon(Icon)

							Label.Icon.Image = 'rbxassetid://'..asset.id
							Label.Icon.ImageRectOffset = asset.imageRectOffset
							Label.Icon.ImageRectSize = asset.imageRectSize
						else
							Label.Icon.Image = getAssetUri(Icon)
						end
					else
						Label.Icon.Image = "rbxassetid://" .. 0
					end

					Label.Icon.Visible = true
				end
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Label.BackgroundColor3 = IgnoreTheme and (Color or Label.BackgroundColor3) or SelectedTheme.SecondaryElementBackground
				Label.UIStroke.Color = IgnoreTheme and (Color or Label.BackgroundColor3) or SelectedTheme.SecondaryElementStroke
			end)

			return LabelValue
		end

		-- Paragraph
		function Tab:CreateParagraph(ParagraphSettings)
			local ParagraphValue = {}

			local Paragraph = Elements.Template.Paragraph:Clone()
			Paragraph.Title.Text = ParagraphSettings.Title
			Paragraph.Content.Text = ParagraphSettings.Content
			Paragraph.Visible = true
			Paragraph.Parent = TabPage

			Paragraph.BackgroundTransparency = 1
			Paragraph.UIStroke.Transparency = 1
			Paragraph.Title.TextTransparency = 1
			Paragraph.Content.TextTransparency = 1

			Paragraph.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
			Paragraph.UIStroke.Color = SelectedTheme.SecondaryElementStroke

			TweenService:Create(Paragraph, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Paragraph.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Paragraph.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	
			TweenService:Create(Paragraph.Content, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			function ParagraphValue:Set(NewParagraphSettings)
				Paragraph.Title.Text = NewParagraphSettings.Title
				Paragraph.Content.Text = NewParagraphSettings.Content
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Paragraph.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
				Paragraph.UIStroke.Color = SelectedTheme.SecondaryElementStroke
			end)

			return ParagraphValue
		end

		-- Input
		function Tab:CreateInput(InputSettings)
			local Input = Elements.Template.Input:Clone()
			Input.Name = InputSettings.Name
			Input.Title.Text = InputSettings.Name
			Input.Visible = true
			Input.Parent = TabPage

			Input.BackgroundTransparency = 1
			Input.UIStroke.Transparency = 1
			Input.Title.TextTransparency = 1

			Input.InputFrame.InputBox.Text = InputSettings.CurrentValue or ''

			Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
			Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke

			TweenService:Create(Input, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Input.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Input.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			Input.InputFrame.InputBox.PlaceholderText = InputSettings.PlaceholderText
			Input.InputFrame.Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 24, 0, 30)

			Input.InputFrame.InputBox.FocusLost:Connect(function()
				local Success, Response = pcall(function()
					InputSettings.Callback(Input.InputFrame.InputBox.Text)
					InputSettings.CurrentValue = Input.InputFrame.InputBox.Text
				end)

				if not Success then
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Input.Title.Text = "Callback Error"
					print("Rayfield | "..InputSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Input.Title.Text = InputSettings.Name
					TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Input.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end

				if InputSettings.RemoveTextAfterFocusLost then
					Input.InputFrame.InputBox.Text = ""
				end

				if not InputSettings.Ext then
					SaveConfiguration()
				end
			end)

			Input.MouseEnter:Connect(function()
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Input.MouseLeave:Connect(function()
				TweenService:Create(Input, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Input.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Input.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Input.InputFrame.InputBox.TextBounds.X + 24, 0, 30)}):Play()
			end)

			function InputSettings:Set(text)
				Input.InputFrame.InputBox.Text = text
				InputSettings.CurrentValue = text

				local Success, Response = pcall(function()
					InputSettings.Callback(text)
				end)

				if not InputSettings.Ext then
					SaveConfiguration()
				end
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and InputSettings.Flag then
					RayfieldLibrary.Flags[InputSettings.Flag] = InputSettings
				end
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Input.InputFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Input.InputFrame.UIStroke.Color = SelectedTheme.InputStroke
			end)

			return InputSettings
		end

		-- Dropdown
		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown = Elements.Template.Dropdown:Clone()
			if string.find(DropdownSettings.Name,"closed") then
				Dropdown.Name = "Dropdown"
			else
				Dropdown.Name = DropdownSettings.Name
			end
			Dropdown.Title.Text = DropdownSettings.Name
			Dropdown.Visible = true
			Dropdown.Parent = TabPage

			Dropdown.List.Visible = false
			if DropdownSettings.CurrentOption then
				if type(DropdownSettings.CurrentOption) == "string" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
				end
				if not DropdownSettings.MultipleOptions and type(DropdownSettings.CurrentOption) == "table" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
				end
			else
				DropdownSettings.CurrentOption = {}
			end

			if DropdownSettings.MultipleOptions then
				if DropdownSettings.CurrentOption and type(DropdownSettings.CurrentOption) == "table" then
					if #DropdownSettings.CurrentOption == 1 then
						Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						Dropdown.Selected.Text = "None"
					else
						Dropdown.Selected.Text = "Various"
					end
				else
					DropdownSettings.CurrentOption = {}
					Dropdown.Selected.Text = "None"
				end
			else
				Dropdown.Selected.Text = DropdownSettings.CurrentOption[1] or "None"
			end

			Dropdown.Toggle.ImageColor3 = SelectedTheme.TextColor
			TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()

			Dropdown.BackgroundTransparency = 1
			Dropdown.UIStroke.Transparency = 1
			Dropdown.Title.TextTransparency = 1

			Dropdown.Size = UDim2.new(1, -10, 0, 45)

			TweenService:Create(Dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Dropdown.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			for _, ununusedoption in ipairs(Dropdown.List:GetChildren()) do
				if ununusedoption.ClassName == "Frame" and ununusedoption.Name ~= "Placeholder" then
					ununusedoption:Destroy()
				end
			end

			Dropdown.Toggle.Rotation = 180

			Dropdown.Interact.MouseButton1Click:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
				task.wait(0.1)
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				if Debounce then return end
				if Dropdown.List.Visible then
					Debounce = true
					TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 45)}):Play()
					for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
						if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
							TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
							TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
						end
					end
					TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ScrollBarImageTransparency = 1}):Play()
					TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Rotation = 180}):Play()	
					task.wait(0.35)
					Dropdown.List.Visible = false
					Debounce = false
				else
					TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 180)}):Play()
					Dropdown.List.Visible = true
					TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ScrollBarImageTransparency = 0.7}):Play()
					TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Rotation = 0}):Play()	
					for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
						if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
							if DropdownOpt.Name ~= Dropdown.Selected.Text then
								TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
							end
							TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
							TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
						end
					end
				end
			end)

			Dropdown.MouseEnter:Connect(function()
				if not Dropdown.List.Visible then
					TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
				end
			end)

			Dropdown.MouseLeave:Connect(function()
				TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			local function SetDropdownOptions()
				for _, Option in ipairs(DropdownSettings.Options) do
					local DropdownOption = Elements.Template.Dropdown.List.Template:Clone()
					DropdownOption.Name = Option
					DropdownOption.Title.Text = Option
					DropdownOption.Parent = Dropdown.List
					DropdownOption.Visible = true

					DropdownOption.BackgroundTransparency = 1
					DropdownOption.UIStroke.Transparency = 1
					DropdownOption.Title.TextTransparency = 1

					--local Dropdown = Tab:CreateDropdown({
					--	Name = "Dropdown Example",
					--	Options = {"Option 1","Option 2"},
					--	CurrentOption = {"Option 1"},
					--  MultipleOptions = true,
					--	Flag = "Dropdown1",
					--	Callback = function(TableOfOptions)

					--	end,
					--})


					DropdownOption.Interact.ZIndex = 50
					DropdownOption.Interact.MouseButton1Click:Connect(function()
						if not DropdownSettings.MultipleOptions and table.find(DropdownSettings.CurrentOption, Option) then 
							return
						end

						if table.find(DropdownSettings.CurrentOption, Option) then
							table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, Option))
							if DropdownSettings.MultipleOptions then
								if #DropdownSettings.CurrentOption == 1 then
									Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
								elseif #DropdownSettings.CurrentOption == 0 then
									Dropdown.Selected.Text = "None"
								else
									Dropdown.Selected.Text = "Various"
								end
							else
								Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
							end
						else
							if not DropdownSettings.MultipleOptions then
								table.clear(DropdownSettings.CurrentOption)
							end
							table.insert(DropdownSettings.CurrentOption, Option)
							if DropdownSettings.MultipleOptions then
								if #DropdownSettings.CurrentOption == 1 then
									Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
								elseif #DropdownSettings.CurrentOption == 0 then
									Dropdown.Selected.Text = "None"
								else
									Dropdown.Selected.Text = "Various"
								end
							else
								Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
							end
							TweenService:Create(DropdownOption.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							TweenService:Create(DropdownOption, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.DropdownSelected}):Play()
							Debounce = true
						end


						local Success, Response = pcall(function()
							DropdownSettings.Callback(DropdownSettings.CurrentOption)
						end)

						if not Success then
							TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Dropdown.Title.Text = "Callback Error"
							print("Rayfield | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
							warn('Check docs.sirius.menu for help with Rayfield specific development.')
							task.wait(0.5)
							Dropdown.Title.Text = DropdownSettings.Name
							TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
							TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
						end

						for _, droption in ipairs(Dropdown.List:GetChildren()) do
							if droption.ClassName == "Frame" and droption.Name ~= "Placeholder" and not table.find(DropdownSettings.CurrentOption, droption.Name) then
								TweenService:Create(droption, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.DropdownUnselected}):Play()
							end
						end
						if not DropdownSettings.MultipleOptions then
							task.wait(0.1)
							TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, -10, 0, 45)}):Play()
							for _, DropdownOpt in ipairs(Dropdown.List:GetChildren()) do
								if DropdownOpt.ClassName == "Frame" and DropdownOpt.Name ~= "Placeholder" then
									TweenService:Create(DropdownOpt, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
									TweenService:Create(DropdownOpt.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
									TweenService:Create(DropdownOpt.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
								end
							end
							TweenService:Create(Dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ScrollBarImageTransparency = 1}):Play()
							TweenService:Create(Dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Rotation = 180}):Play()	
							task.wait(0.35)
							Dropdown.List.Visible = false
						end
						Debounce = false
						if not DropdownSettings.Ext then
							SaveConfiguration()
						end
					end)

					Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
						DropdownOption.UIStroke.Color = SelectedTheme.ElementStroke
					end)
				end
			end
			SetDropdownOptions()

			for _, droption in ipairs(Dropdown.List:GetChildren()) do
				if droption.ClassName == "Frame" and droption.Name ~= "Placeholder" then
					if not table.find(DropdownSettings.CurrentOption, droption.Name) then
						droption.BackgroundColor3 = SelectedTheme.DropdownUnselected
					else
						droption.BackgroundColor3 = SelectedTheme.DropdownSelected
					end

					Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
						if not table.find(DropdownSettings.CurrentOption, droption.Name) then
							droption.BackgroundColor3 = SelectedTheme.DropdownUnselected
						else
							droption.BackgroundColor3 = SelectedTheme.DropdownSelected
						end
					end)
				end
			end

			function DropdownSettings:Set(NewOption)
				DropdownSettings.CurrentOption = NewOption

				if typeof(DropdownSettings.CurrentOption) == "string" then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
				end

				if not DropdownSettings.MultipleOptions then
					DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
				end

				if DropdownSettings.MultipleOptions then
					if #DropdownSettings.CurrentOption == 1 then
						Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						Dropdown.Selected.Text = "None"
					else
						Dropdown.Selected.Text = "Various"
					end
				else
					Dropdown.Selected.Text = DropdownSettings.CurrentOption[1]
				end


				local Success, Response = pcall(function()
					DropdownSettings.Callback(NewOption)
				end)
				if not Success then
					TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Dropdown.Title.Text = "Callback Error"
					print("Rayfield | "..DropdownSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Dropdown.Title.Text = DropdownSettings.Name
					TweenService:Create(Dropdown, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Dropdown.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end

				for _, droption in ipairs(Dropdown.List:GetChildren()) do
					if droption.ClassName == "Frame" and droption.Name ~= "Placeholder" then
						if not table.find(DropdownSettings.CurrentOption, droption.Name) then
							droption.BackgroundColor3 = SelectedTheme.DropdownUnselected
						else
							droption.BackgroundColor3 = SelectedTheme.DropdownSelected
						end
					end
				end
				--SaveConfiguration()
			end

			function DropdownSettings:Refresh(optionsTable: table) -- updates a dropdown with new options from optionsTable
				DropdownSettings.Options = optionsTable
				for _, option in Dropdown.List:GetChildren() do
					if option.ClassName == "Frame" and option.Name ~= "Placeholder" then
						option:Destroy()
					end
				end
				SetDropdownOptions()
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
					RayfieldLibrary.Flags[DropdownSettings.Flag] = DropdownSettings
				end
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Dropdown.Toggle.ImageColor3 = SelectedTheme.TextColor
				TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			return DropdownSettings
		end

		-- Keybind
		function Tab:CreateKeybind(KeybindSettings)
			local CheckingForKey = false
			local Keybind = Elements.Template.Keybind:Clone()
			Keybind.Name = KeybindSettings.Name
			Keybind.Title.Text = KeybindSettings.Name
			Keybind.Visible = true
			Keybind.Parent = TabPage

			Keybind.BackgroundTransparency = 1
			Keybind.UIStroke.Transparency = 1
			Keybind.Title.TextTransparency = 1

			Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
			Keybind.KeybindFrame.UIStroke.Color = SelectedTheme.InputStroke

			TweenService:Create(Keybind, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Keybind.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
			Keybind.KeybindFrame.Size = UDim2.new(0, Keybind.KeybindFrame.KeybindBox.TextBounds.X + 24, 0, 30)

			Keybind.KeybindFrame.KeybindBox.Focused:Connect(function()
				CheckingForKey = true
				Keybind.KeybindFrame.KeybindBox.Text = ""
			end)
			Keybind.KeybindFrame.KeybindBox.FocusLost:Connect(function()
				CheckingForKey = false
				if Keybind.KeybindFrame.KeybindBox.Text == nil or "" then
					Keybind.KeybindFrame.KeybindBox.Text = KeybindSettings.CurrentKeybind
					if not KeybindSettings.Ext then
						SaveConfiguration()
					end
				end
			end)

			Keybind.MouseEnter:Connect(function()
				TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Keybind.MouseLeave:Connect(function()
				TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			UserInputService.InputBegan:Connect(function(input, processed)
				if CheckingForKey then
					if input.KeyCode ~= Enum.KeyCode.Unknown then
						local SplitMessage = string.split(tostring(input.KeyCode), ".")
						local NewKeyNoEnum = SplitMessage[3]
						Keybind.KeybindFrame.KeybindBox.Text = tostring(NewKeyNoEnum)
						KeybindSettings.CurrentKeybind = tostring(NewKeyNoEnum)
						Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
						if not KeybindSettings.Ext then
							SaveConfiguration()
						end

						if KeybindSettings.CallOnChange then
							KeybindSettings.Callback(tostring(NewKeyNoEnum))
						end
					end
				elseif not KeybindSettings.CallOnChange and KeybindSettings.CurrentKeybind ~= nil and (input.KeyCode == Enum.KeyCode[KeybindSettings.CurrentKeybind] and not processed) then -- Test
					local Held = true
					local Connection
					Connection = input.Changed:Connect(function(prop)
						if prop == "UserInputState" then
							Connection:Disconnect()
							Held = false
						end
					end)

					if not KeybindSettings.HoldToInteract then
						local Success, Response = pcall(KeybindSettings.Callback)
						if not Success then
							TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
							TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
							Keybind.Title.Text = "Callback Error"
							print("Rayfield | "..KeybindSettings.Name.." Callback Error " ..tostring(Response))
							warn('Check docs.sirius.menu for help with Rayfield specific development.')
							task.wait(0.5)
							Keybind.Title.Text = KeybindSettings.Name
							TweenService:Create(Keybind, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
							TweenService:Create(Keybind.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
						end
					else
						task.wait(0.25)
						if Held then
							local Loop; Loop = RunService.Stepped:Connect(function()
								if not Held then
									KeybindSettings.Callback(false) -- maybe pcall this
									Loop:Disconnect()
								else
									KeybindSettings.Callback(true) -- maybe pcall this
								end
							end)
						end
					end
				end
			end)

			Keybind.KeybindFrame.KeybindBox:GetPropertyChangedSignal("Text"):Connect(function()
				TweenService:Create(Keybind.KeybindFrame, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Keybind.KeybindFrame.KeybindBox.TextBounds.X + 24, 0, 30)}):Play()
			end)

			function KeybindSettings:Set(NewKeybind)
				Keybind.KeybindFrame.KeybindBox.Text = tostring(NewKeybind)
				KeybindSettings.CurrentKeybind = tostring(NewKeybind)
				Keybind.KeybindFrame.KeybindBox:ReleaseFocus()
				if not KeybindSettings.Ext then
					SaveConfiguration()
				end

				if KeybindSettings.CallOnChange then
					KeybindSettings.Callback(tostring(NewKeybind))
				end
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
					RayfieldLibrary.Flags[KeybindSettings.Flag] = KeybindSettings
				end
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Keybind.KeybindFrame.BackgroundColor3 = SelectedTheme.InputBackground
				Keybind.KeybindFrame.UIStroke.Color = SelectedTheme.InputStroke
			end)

			return KeybindSettings
		end

		-- Toggle
		function Tab:CreateToggle(ToggleSettings)
			local ToggleValue = {}

			local Toggle = Elements.Template.Toggle:Clone()
			Toggle.Name = ToggleSettings.Name
			Toggle.Title.Text = ToggleSettings.Name
			Toggle.Visible = true
			Toggle.Parent = TabPage

			Toggle.BackgroundTransparency = 1
			Toggle.UIStroke.Transparency = 1
			Toggle.Title.TextTransparency = 1
			Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground

			if SelectedTheme ~= RayfieldLibrary.Theme.Default then
				Toggle.Switch.Shadow.Visible = false
			end

			TweenService:Create(Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Toggle.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			if ToggleSettings.CurrentValue == true then
				Toggle.Switch.Indicator.Position = UDim2.new(1, -20, 0.5, 0)
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleEnabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleEnabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleEnabledOuterStroke
			else
				Toggle.Switch.Indicator.Position = UDim2.new(1, -40, 0.5, 0)
				Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
				Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
				Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
			end

			Toggle.MouseEnter:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Toggle.MouseLeave:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Toggle.Interact.MouseButton1Click:Connect(function()
				if ToggleSettings.CurrentValue == true then
					ToggleSettings.CurrentValue = false
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -40, 0.5, 0)}):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleDisabled}):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledOuterStroke}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()	
				else
					ToggleSettings.CurrentValue = true
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)}):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleEnabled}):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledOuterStroke}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()		
				end

				local Success, Response = pcall(function()
					if debugX then warn('Running toggle \''..ToggleSettings.Name..'\' (Interact)') end

					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)

				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("Rayfield | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end

				if not ToggleSettings.Ext then
					SaveConfiguration()
				end
			end)

			function ToggleSettings:Set(NewToggleValue)
				if NewToggleValue == true then
					ToggleSettings.CurrentValue = true
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,12,0,12)}):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleEnabled}):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleEnabledOuterStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,17,0,17)}):Play()	
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()	
				else
					ToggleSettings.CurrentValue = false
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -40, 0.5, 0)}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,12,0,12)}):Play()
					TweenService:Create(Toggle.Switch.Indicator.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = SelectedTheme.ToggleDisabled}):Play()
					TweenService:Create(Toggle.Switch.UIStroke, TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Color = SelectedTheme.ToggleDisabledOuterStroke}):Play()
					TweenService:Create(Toggle.Switch.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,17,0,17)}):Play()
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()	
				end

				local Success, Response = pcall(function()
					if debugX then warn('Running toggle \''..ToggleSettings.Name..'\' (:Set)') end

					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)

				if not Success then
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Toggle.Title.Text = "Callback Error"
					print("Rayfield | "..ToggleSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Toggle.Title.Text = ToggleSettings.Name
					TweenService:Create(Toggle, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Toggle.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end

				if not ToggleSettings.Ext then
					SaveConfiguration()
				end
			end

			if not ToggleSettings.Ext then
				if Settings.ConfigurationSaving then
					if Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
						RayfieldLibrary.Flags[ToggleSettings.Flag] = ToggleSettings
					end
				end
			end


			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				Toggle.Switch.BackgroundColor3 = SelectedTheme.ToggleBackground

				if SelectedTheme ~= RayfieldLibrary.Theme.Default then
					Toggle.Switch.Shadow.Visible = false
				end

				task.wait()

				if not ToggleSettings.CurrentValue then
					Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleDisabledStroke
					Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleDisabled
					Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleDisabledOuterStroke
				else
					Toggle.Switch.Indicator.UIStroke.Color = SelectedTheme.ToggleEnabledStroke
					Toggle.Switch.Indicator.BackgroundColor3 = SelectedTheme.ToggleEnabled
					Toggle.Switch.UIStroke.Color = SelectedTheme.ToggleEnabledOuterStroke
				end
			end)

			return ToggleSettings
		end

		-- Slider
		function Tab:CreateSlider(SliderSettings)
			local SLDragging = false
			local Slider = Elements.Template.Slider:Clone()
			Slider.Name = SliderSettings.Name
			Slider.Title.Text = SliderSettings.Name
			Slider.Visible = true
			Slider.Parent = TabPage

			Slider.BackgroundTransparency = 1
			Slider.UIStroke.Transparency = 1
			Slider.Title.TextTransparency = 1

			if SelectedTheme ~= RayfieldLibrary.Theme.Default then
				Slider.Main.Shadow.Visible = false
			end

			Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
			Slider.Main.UIStroke.Color = SelectedTheme.SliderStroke
			Slider.Main.Progress.UIStroke.Color = SelectedTheme.SliderStroke
			Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress

			TweenService:Create(Slider, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
			TweenService:Create(Slider.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
			TweenService:Create(Slider.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()	

			Slider.Main.Progress.Size =	UDim2.new(0, Slider.Main.AbsoluteSize.X * ((SliderSettings.CurrentValue + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (SliderSettings.CurrentValue / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)

			if not SliderSettings.Suffix then
				Slider.Main.Information.Text = tostring(SliderSettings.CurrentValue)
			else
				Slider.Main.Information.Text = tostring(SliderSettings.CurrentValue) .. " " .. SliderSettings.Suffix
			end

			Slider.MouseEnter:Connect(function()
				TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Slider.MouseLeave:Connect(function()
				TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			Slider.Main.Interact.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					TweenService:Create(Slider.Main.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					TweenService:Create(Slider.Main.Progress.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					SLDragging = true 
				end 
			end)

			Slider.Main.Interact.InputEnded:Connect(function(Input) 
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then 
					TweenService:Create(Slider.Main.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.4}):Play()
					TweenService:Create(Slider.Main.Progress.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0.3}):Play()
					SLDragging = false 
				end 
			end)

			Slider.Main.Interact.MouseButton1Down:Connect(function(X)
				local Current = Slider.Main.Progress.AbsolutePosition.X + Slider.Main.Progress.AbsoluteSize.X
				local Start = Current
				local Location = X
				local Loop; Loop = RunService.Stepped:Connect(function()
					if SLDragging then
						Location = UserInputService:GetMouseLocation().X
						Current = Current + 0.025 * (Location - Start)

						if Location < Slider.Main.AbsolutePosition.X then
							Location = Slider.Main.AbsolutePosition.X
						elseif Location > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
							Location = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
						end

						if Current < Slider.Main.AbsolutePosition.X + 5 then
							Current = Slider.Main.AbsolutePosition.X + 5
						elseif Current > Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X then
							Current = Slider.Main.AbsolutePosition.X + Slider.Main.AbsoluteSize.X
						end

						if Current <= Location and (Location - Start) < 0 then
							Start = Location
						elseif Current >= Location and (Location - Start) > 0 then
							Start = Location
						end
						TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Current - Slider.Main.AbsolutePosition.X, 1, 0)}):Play()
						local NewValue = SliderSettings.Range[1] + (Location - Slider.Main.AbsolutePosition.X) / Slider.Main.AbsoluteSize.X * (SliderSettings.Range[2] - SliderSettings.Range[1])

						NewValue = math.floor(NewValue / SliderSettings.Increment + 0.5) * (SliderSettings.Increment * 10000000) / 10000000
						NewValue = math.clamp(NewValue, SliderSettings.Range[1], SliderSettings.Range[2])

						if not SliderSettings.Suffix then
							Slider.Main.Information.Text = tostring(NewValue)
						else
							Slider.Main.Information.Text = tostring(NewValue) .. " " .. SliderSettings.Suffix
						end

						if SliderSettings.CurrentValue ~= NewValue then
							local Success, Response = pcall(function()
								SliderSettings.Callback(NewValue)
							end)
							if not Success then
								TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
								TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
								Slider.Title.Text = "Callback Error"
								print("Rayfield | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
								warn('Check docs.sirius.menu for help with Rayfield specific development.')
								task.wait(0.5)
								Slider.Title.Text = SliderSettings.Name
								TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
								TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
							end

							SliderSettings.CurrentValue = NewValue
							if not SliderSettings.Ext then
								SaveConfiguration()
							end
						end
					else
						TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Location - Slider.Main.AbsolutePosition.X > 5 and Location - Slider.Main.AbsolutePosition.X or 5, 1, 0)}):Play()
						Loop:Disconnect()
					end
				end)
			end)

			function SliderSettings:Set(NewVal)
				local NewVal = math.clamp(NewVal, SliderSettings.Range[1], SliderSettings.Range[2])

				TweenService:Create(Slider.Main.Progress, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, Slider.Main.AbsoluteSize.X * ((NewVal + SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])) > 5 and Slider.Main.AbsoluteSize.X * (NewVal / (SliderSettings.Range[2] - SliderSettings.Range[1])) or 5, 1, 0)}):Play()
				Slider.Main.Information.Text = tostring(NewVal) .. " " .. (SliderSettings.Suffix or "")

				local Success, Response = pcall(function()
					SliderSettings.Callback(NewVal)
				end)

				if not Success then
					TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = Color3.fromRGB(85, 0, 0)}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
					Slider.Title.Text = "Callback Error"
					print("Rayfield | "..SliderSettings.Name.." Callback Error " ..tostring(Response))
					warn('Check docs.sirius.menu for help with Rayfield specific development.')
					task.wait(0.5)
					Slider.Title.Text = SliderSettings.Name
					TweenService:Create(Slider, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					TweenService:Create(Slider.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Transparency = 0}):Play()
				end

				SliderSettings.CurrentValue = NewVal
				if not SliderSettings.Ext then
					SaveConfiguration()
				end
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
					RayfieldLibrary.Flags[SliderSettings.Flag] = SliderSettings
				end
			end

			Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
				if SelectedTheme ~= RayfieldLibrary.Theme.Default then
					Slider.Main.Shadow.Visible = false
				end

				Slider.Main.BackgroundColor3 = SelectedTheme.SliderBackground
				Slider.Main.UIStroke.Color = SelectedTheme.SliderStroke
				Slider.Main.Progress.UIStroke.Color = SelectedTheme.SliderStroke
				Slider.Main.Progress.BackgroundColor3 = SelectedTheme.SliderProgress
			end)

			return SliderSettings
		end

		Rayfield.Main:GetPropertyChangedSignal('BackgroundColor3'):Connect(function()
			TabButton.UIStroke.Color = SelectedTheme.TabStroke

			if Elements.UIPageLayout.CurrentPage == TabPage then
				TabButton.BackgroundColor3 = SelectedTheme.TabBackgroundSelected
				TabButton.Image.ImageColor3 = SelectedTheme.SelectedTabTextColor
				TabButton.Title.TextColor3 = SelectedTheme.SelectedTabTextColor
			else
				TabButton.BackgroundColor3 = SelectedTheme.TabBackground
				TabButton.Image.ImageColor3 = SelectedTheme.TabTextColor
				TabButton.Title.TextColor3 = SelectedTheme.TabTextColor
			end
		end)

		return Tab
	end

	Elements.Visible = true


	task.wait(1.1)
	TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 390, 0, 90)}):Play()
	task.wait(0.3)
	TweenService:Create(LoadingFrame.Title, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Subtitle, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
	TweenService:Create(LoadingFrame.Version, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
	task.wait(0.1)
	TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = useMobileSizing and UDim2.new(0, 500, 0, 275) or UDim2.new(0, 500, 0, 475)}):Play()
	TweenService:Create(Main.Shadow.Image, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 0.6}):Play()

	Topbar.BackgroundTransparency = 1
	Topbar.Divider.Size = UDim2.new(0, 0, 0, 1)
	Topbar.Divider.BackgroundColor3 = SelectedTheme.ElementStroke
	Topbar.CornerRepair.BackgroundTransparency = 1
	Topbar.Title.TextTransparency = 1
	Topbar.Search.ImageTransparency = 1
	if Topbar:FindFirstChild('Settings') then
		Topbar.Settings.ImageTransparency = 1
	end
	Topbar.ChangeSize.ImageTransparency = 1
	Topbar.Hide.ImageTransparency = 1


	task.wait(0.5)
	Topbar.Visible = true
	TweenService:Create(Topbar, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Topbar.CornerRepair, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
	task.wait(0.1)
	TweenService:Create(Topbar.Divider, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 1)}):Play()
	TweenService:Create(Topbar.Title, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
	task.wait(0.05)
	TweenService:Create(Topbar.Search, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	task.wait(0.05)
	if Topbar:FindFirstChild('Settings') then
		TweenService:Create(Topbar.Settings, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		task.wait(0.05)
	end
	TweenService:Create(Topbar.ChangeSize, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	task.wait(0.05)
	TweenService:Create(Topbar.Hide, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
	task.wait(0.3)

	if dragBar then
		TweenService:Create(dragBarCosmetic, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
	end

	function Window.ModifyTheme(NewTheme)
		local success = pcall(ChangeTheme, NewTheme)
		if not success then
			RayfieldLibrary:Notify({Title = 'Unable to Change Theme', Content = 'We are unable find a theme on file.', Image = 4400704299})
		else
			RayfieldLibrary:Notify({Title = 'Theme Changed', Content = 'Successfully changed theme to '..(typeof(NewTheme) == 'string' and NewTheme or 'Custom Theme')..'.', Image = 4483362748})
		end
	end

	local success, result = pcall(function()
		createSettings(Window)
	end)
	
	if not success then warn('Rayfield had an issue creating settings.') end
	
	return Window
end

local function setVisibility(visibility: boolean, notify: boolean?)
	if Debounce then return end
	if visibility then
		Hidden = false
		Unhide()
	else
		Hidden = true
		Hide(notify)
	end
end

function RayfieldLibrary:SetVisibility(visibility: boolean)
	setVisibility(visibility, false)
end

function RayfieldLibrary:IsVisible(): boolean
	return not Hidden
end

local hideHotkeyConnection -- Has to be initialized here since the connection is made later in the script
function RayfieldLibrary:Destroy()
	hideHotkeyConnection:Disconnect()
	Rayfield:Destroy()
end

Topbar.ChangeSize.MouseButton1Click:Connect(function()
	if Debounce then return end
	if Minimised then
		Minimised = false
		Maximise()
	else
		Minimised = true
		Minimise()
	end
end)

Main.Search.Input:GetPropertyChangedSignal('Text'):Connect(function()
	if #Main.Search.Input.Text > 0 then
		if not Elements.UIPageLayout.CurrentPage:FindFirstChild('SearchTitle-fsefsefesfsefesfesfThanks') then 
			local searchTitle = Elements.Template.SectionTitle:Clone()
			searchTitle.Parent = Elements.UIPageLayout.CurrentPage
			searchTitle.Name = 'SearchTitle-fsefsefesfsefesfesfThanks'
			searchTitle.LayoutOrder = -100
			searchTitle.Title.Text = "Results from '"..Elements.UIPageLayout.CurrentPage.Name.."'"
			searchTitle.Visible = true
		end
	else
		local searchTitle = Elements.UIPageLayout.CurrentPage:FindFirstChild('SearchTitle-fsefsefesfsefesfesfThanks')

		if searchTitle then
			searchTitle:Destroy()
		end
	end

	for _, element in ipairs(Elements.UIPageLayout.CurrentPage:GetChildren()) do
		if element.ClassName ~= 'UIListLayout' and element.Name ~= 'Placeholder' and element.Name ~= 'SearchTitle-fsefsefesfsefesfesfThanks' then
			if element.Name == 'SectionTitle' then
				if #Main.Search.Input.Text == 0 then
					element.Visible = true
				else
					element.Visible = false
				end
			else
				if string.lower(element.Name):find(string.lower(Main.Search.Input.Text), 1, true) then
					element.Visible = true
				else
					element.Visible = false
				end
			end
		end
	end
end)

Main.Search.Input.FocusLost:Connect(function(enterPressed)
	if #Main.Search.Input.Text == 0 and searchOpen then
		task.wait(0.12)
		closeSearch()
	end
end)

Topbar.Search.MouseButton1Click:Connect(function()
	task.spawn(function()
		if searchOpen then
			closeSearch()
		else
			openSearch()
		end
	end)
end)

if Topbar:FindFirstChild('Settings') then
	Topbar.Settings.MouseButton1Click:Connect(function()
		task.spawn(function()
			for _, OtherTabButton in ipairs(TabList:GetChildren()) do
				if OtherTabButton.Name ~= "Template" and OtherTabButton.ClassName == "Frame" and OtherTabButton ~= TabButton and OtherTabButton.Name ~= "Placeholder" then
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundColor3 = SelectedTheme.TabBackground}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageColor3 = SelectedTheme.TabTextColor}):Play()
					TweenService:Create(OtherTabButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.7}):Play()
					TweenService:Create(OtherTabButton.Title, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.Image, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.2}):Play()
					TweenService:Create(OtherTabButton.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Transparency = 0.5}):Play()
				end
			end

			Elements.UIPageLayout:JumpTo(Elements['Rayfield Settings'])
		end)
	end)

end


Topbar.Hide.MouseButton1Click:Connect(function()
	setVisibility(Hidden, not useMobileSizing)
end)

hideHotkeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
	if (input.KeyCode == Enum.KeyCode[settingsTable.General.rayfieldOpen.Value or 'K'] and not processed) then
		if Debounce then return end
		if Hidden then
			Hidden = false
			Unhide()
		else
			Hidden = true
			Hide()
		end
	end
end)

if MPrompt then
	MPrompt.Interact.MouseButton1Click:Connect(function()
		if Debounce then return end
		if Hidden then
			Hidden = false
			Unhide()
		end
	end)
end

for _, TopbarButton in ipairs(Topbar:GetChildren()) do
	if TopbarButton.ClassName == "ImageButton" and TopbarButton.Name ~= 'Icon' then
		TopbarButton.MouseEnter:Connect(function()
			TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
		end)

		TopbarButton.MouseLeave:Connect(function()
			TweenService:Create(TopbarButton, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {ImageTransparency = 0.8}):Play()
		end)
	end
end


function RayfieldLibrary:LoadConfiguration()
	local config

	if debugX then
		warn('Loading Configuration')
	end

	if useStudio then
		config = [[{"Toggle1adwawd":true,"ColorPicker1awd":{"B":255,"G":255,"R":255},"Slider1dawd":100,"ColorPicfsefker1":{"B":255,"G":255,"R":255},"Slidefefsr1":80,"dawdawd":"","Input1":"hh","Keybind1":"B","Dropdown1":["Ocean"]}]]
	end

	if CEnabled then
		local notified
		local loaded

		local success, result = pcall(function()
			if useStudio and config then
				loaded = LoadConfiguration(config)
				return
			end

			if isfile then 
				if isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
					loaded = LoadConfiguration(readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension))
				end
			else
				notified = true
				RayfieldLibrary:Notify({Title = "Rayfield Configurations", Content = "We couldn't enable Configuration Saving as you are not using software with filesystem support.", Image = 4384402990})
			end
		end)

		if success and loaded and not notified then
			RayfieldLibrary:Notify({Title = "Rayfield Configurations", Content = "The configuration file for this script has been loaded from a previous session.", Image = 4384403532})
		elseif not success and not notified then
			warn('Rayfield Configurations Error | '..tostring(result))
			RayfieldLibrary:Notify({Title = "Rayfield Configurations", Content = "We've encountered an issue loading your configuration correctly.\n\nCheck the Developer Console for more information.", Image = 4384402990})
		end
	end

	globalLoaded = true
end



if useStudio then
	-- run w/ studio
	-- Feel free to place your own script here to see how it'd work in Roblox Studio before running it on your execution software.


	local Window = RayfieldLibrary:CreateWindow({
		Name = "Rayfield Example Window",
		LoadingTitle = "Rayfield Interface Suite",
		Theme = 'Default',
		Icon = 0,
		LoadingSubtitle = "by Sirius",
		ConfigurationSaving = {
			Enabled = true,
			FolderName = nil, -- Create a custom folder for your hub/game
			FileName = "Big Hub52"
		},
		Discord = {
			Enabled = false,
			Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
			RememberJoins = true -- Set this to false to make them join the discord every time they load it up
		},
		KeySystem = false, -- Set this to true to use our key system
		KeySettings = {
			Title = "Untitled",
			Subtitle = "Key System",
			Note = "No method of obtaining the key is provided",
			FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
			SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
			GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
			Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
		}
	})

	local Tab = Window:CreateTab("Tab Example", 'key-round') -- Title, Image
	local Tab2 = Window:CreateTab("Tab Example 2", 4483362458) -- Title, Image

	local Section = Tab2:CreateSection("Section")


	local ColorPicker = Tab2:CreateColorPicker({
		Name = "Color Picker",
		Color = Color3.fromRGB(255,255,255),
		Flag = "ColorPicfsefker1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place every time the color picker is moved/changed
			-- The variable (Value) is a Color3fromRGB value based on which color is selected
		end
	})

	local Slider = Tab2:CreateSlider({
		Name = "Slider Example",
		Range = {0, 100},
		Increment = 10,
		Suffix = "Bananas",
		CurrentValue = 40,
		Flag = "Slidefefsr1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place when the slider changes
			-- The variable (Value) is a number which correlates to the value the slider is currently at
		end,
	})

	local Input = Tab2:CreateInput({
		Name = "Input Example",
		CurrentValue = '',
		PlaceholderText = "Input Placeholder",
		Flag = 'dawdawd',
		RemoveTextAfterFocusLost = false,
		Callback = function(Text)
			-- The function that takes place when the input is changed
			-- The variable (Text) is a string for the value in the text box
		end,
	})


	--RayfieldLibrary:Notify({Title = "Rayfield Interface", Content = "Welcome to Rayfield. These - are the brand new notification design for Rayfield, with custom sizing and Rayfield calculated wait times.", Image = 4483362458})

	local Section = Tab:CreateSection("Section Example")

	local Button = Tab:CreateButton({
		Name = "Change Theme",
		Callback = function()
			-- The function that takes place when the button is pressed
			Window.ModifyTheme('DarkBlue')
		end,
	})

	local Toggle = Tab:CreateToggle({
		Name = "Toggle Example",
		CurrentValue = false,
		Flag = "Toggle1adwawd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place when the toggle is pressed
			-- The variable (Value) is a boolean on whether the toggle is true or false
		end,
	})

	local ColorPicker = Tab:CreateColorPicker({
		Name = "Color Picker",
		Color = Color3.fromRGB(255,255,255),
		Flag = "ColorPicker1awd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place every time the color picker is moved/changed
			-- The variable (Value) is a Color3fromRGB value based on which color is selected
		end
	})

	local Slider = Tab:CreateSlider({
		Name = "Slider Example",
		Range = {0, 100},
		Increment = 10,
		Suffix = "Bananas",
		CurrentValue = 40,
		Flag = "Slider1dawd", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Value)
			-- The function that takes place when the slider changes
			-- The variable (Value) is a number which correlates to the value the slider is currently at
		end,
	})

	local Input = Tab:CreateInput({
		Name = "Input Example",
		CurrentValue = "Helo",
		PlaceholderText = "Adaptive Input",
		RemoveTextAfterFocusLost = false,
		Flag = 'Input1',
		Callback = function(Text)
			-- The function that takes place when the input is changed
			-- The variable (Text) is a string for the value in the text box
		end,
	})

	local thoptions = {}
	for themename, theme in pairs(RayfieldLibrary.Theme) do
		table.insert(thoptions, themename)
	end

	local Dropdown = Tab:CreateDropdown({
		Name = "Theme",
		Options = thoptions,
		CurrentOption = {"Default"},
		MultipleOptions = false,
		Flag = "Dropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Options)
			--Window.ModifyTheme(Options[1])
			-- The function that takes place when the selected option is changed
			-- The variable (Options) is a table of strings for the current selected options
		end,
	})


	--Window.ModifyTheme({
	--	TextColor = Color3.fromRGB(50, 55, 60),
	--	Background = Color3.fromRGB(240, 245, 250),
	--	Topbar = Color3.fromRGB(215, 225, 235),
	--	Shadow = Color3.fromRGB(200, 210, 220),

	--	NotificationBackground = Color3.fromRGB(210, 220, 230),
	--	NotificationActionsBackground = Color3.fromRGB(225, 230, 240),

	--	TabBackground = Color3.fromRGB(200, 210, 220),
	--	TabStroke = Color3.fromRGB(180, 190, 200),
	--	TabBackgroundSelected = Color3.fromRGB(175, 185, 200),
	--	TabTextColor = Color3.fromRGB(50, 55, 60),
	--	SelectedTabTextColor = Color3.fromRGB(30, 35, 40),

	--	ElementBackground = Color3.fromRGB(210, 220, 230),
	--	ElementBackgroundHover = Color3.fromRGB(220, 230, 240),
	--	SecondaryElementBackground = Color3.fromRGB(200, 210, 220),
	--	ElementStroke = Color3.fromRGB(190, 200, 210),
	--	SecondaryElementStroke = Color3.fromRGB(180, 190, 200),

	--	SliderBackground = Color3.fromRGB(200, 220, 235),  -- Lighter shade
	--	SliderProgress = Color3.fromRGB(70, 130, 180),
	--	SliderStroke = Color3.fromRGB(150, 180, 220),

	--	ToggleBackground = Color3.fromRGB(210, 220, 230),
	--	ToggleEnabled = Color3.fromRGB(70, 160, 210),
	--	ToggleDisabled = Color3.fromRGB(180, 180, 180),
	--	ToggleEnabledStroke = Color3.fromRGB(60, 150, 200),
	--	ToggleDisabledStroke = Color3.fromRGB(140, 140, 140),
	--	ToggleEnabledOuterStroke = Color3.fromRGB(100, 120, 140),
	--	ToggleDisabledOuterStroke = Color3.fromRGB(120, 120, 130),

	--	DropdownSelected = Color3.fromRGB(220, 230, 240),
	--	DropdownUnselected = Color3.fromRGB(200, 210, 220),

	--	InputBackground = Color3.fromRGB(220, 230, 240),
	--	InputStroke = Color3.fromRGB(180, 190, 200),
	--	PlaceholderColor = Color3.fromRGB(150, 150, 150)
	--})

	local Keybind = Tab:CreateKeybind({
		Name = "Keybind Example",
		CurrentKeybind = "Q",
		HoldToInteract = false,
		Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(Keybind)
			-- The function that takes place when the keybind is pressed
			-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
		end,
	})

	local Label = Tab:CreateLabel("Label Example")

	local Label2 = Tab:CreateLabel("Warning", 4483362458, Color3.fromRGB(255, 159, 49),  true)

	local Paragraph = Tab:CreateParagraph({Title = "Paragraph Example", Content = "Paragraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph ExampleParagraph Example"})
end

if CEnabled and Main:FindFirstChild('Notice') then
	Main.Notice.BackgroundTransparency = 1
	Main.Notice.Title.TextTransparency = 1
	Main.Notice.Size = UDim2.new(0, 0, 0, 0)
	Main.Notice.Position = UDim2.new(0.5, 0, 0, -100)
	Main.Notice.Visible = true


	TweenService:Create(Main.Notice, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 280, 0, 35), Position = UDim2.new(0.5, 0, 0, -50), BackgroundTransparency = 0.5}):Play()
	TweenService:Create(Main.Notice.Title, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 0.1}):Play()
end

-- if not useStudio then
-- 	task.spawn(loadWithTimeout, "https://raw.githubusercontent.com/SiriusSoftwareLtd/Sirius/refs/heads/request/boost.lua")
-- end

task.delay(4, function()
	RayfieldLibrary.LoadConfiguration()
	if Main:FindFirstChild('Notice') and Main.Notice.Visible then
		TweenService:Create(Main.Notice, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 100, 0, 25), Position = UDim2.new(0.5, 0, 0, -100), BackgroundTransparency = 1}):Play()
		TweenService:Create(Main.Notice.Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()

		task.wait(0.5)
		Main.Notice.Visible = false
	end
end)

local Rayfield = RayfieldLibrary

game.Players.LocalPlayer.CameraMaxZoomDistance = 100000

local plrinplot = Instance.new("Folder", game:getService("Workspace"))
plrinplot.Name = "Players In Plots"

for _,prt in pairs(game.workspace:GetChildren()) do
	if prt.Name == "GrabParts" then
		prt.Name = "OfflineGrabParts"
	end
end

local tpland = {
	Spawn = CFrame.new(0,-7.35,0),
	SpawnCave = CFrame.new(-90,14.6,-314.3),
	GreenHouse = CFrame.new(-538,-7,74),
	PinkHouse = CFrame.new(-478,-7,-147),
	Barn = CFrame.new(-228,82,-318),
	BlueHouse = CFrame.new(496,83,-350),
	ChineseHouse = CFrame.new(542,123,-93),
	PurpleHouse = CFrame.new(270,-7,448),
	Factory = CFrame.new(134,347,352),
	OtherGreenHouse = CFrame.new(-359,98,357),
	BigCave = CFrame.new(-245,80,485),
	GoodPrison = CFrame.new(569.6,-7,176.3),
	RuhubsDogAhhPrison = CFrame.new(564,82.5,210),
	ExtremelyGoodPrison = CFrame.new(525,76,56),
	TrainCave = CFrame.new(536.6,87.5,-169.5),
	IslanCave = CFrame.new(75.8,323,368.5),
	ChineseRoof = CFrame.new(592,153,-100),
	UfoCave = CFrame.new(29.6,10.5,-225.8),
	Prison = CFrame.new(195,-7,-561),
	BlueHouseSlot = CFrame.new(562.2,85.38,-212.56),
	SpawnSlot = CFrame.new(51.75,-5.3,-121.64),
	HauntedSlot = CFrame.new(164.57,-5.43,530.97),
	RandomSlot = CFrame.new(-211.65,85.7,426.72),
	BeachSlot = CFrame.new(-546.97,-5.3,-41.09)
}	

local dick = Instance.new("Folder")
dick.Parent = game.workspace
dick.Name = "PlotItems"

for _,prt in pairs(game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel:GetChildren()) do 
    if prt:IsA("Part") and prt.Name == "Ocean" then 
		prt.Color = Color3.fromRGB(2,65,98)
		prt.CollisionGroup = "Items"
		prt.CanCollide = true
		prt.CanQuery = false
	end
end

if not game:GetService("Workspace").Map:FindFirstChild("PrimaryPart") then
	local mapspp = Instance.new("Part")
	mapspp.Transparency = 1
	mapspp.Anchored = true
	mapspp.CFrame = CFrame.new(Vector3.zero)
	mapspp.Name = "Primary Part"
	mapspp.CanCollide = false
	mapspp.Parent = game:GetService("Workspace").Map
	game:GetService("Workspace").Map.PrimaryPart = mapspp
end

local mapp = game:GetService("Workspace").Map:Clone()
mapp.AlwaysHereTweenedObjects:Destroy()
mapp.MapNoises:Destroy()

for _,prt in pairs(game:GetService("Workspace").Plots:GetDescendants()) do
    if prt.Name == "PlotArea" then
        prt.CanQuery = false
        prt.CanCollide = false
    elseif prt.Name == "PlotBarrier" or prt.Name == "FalseBorder" then
        prt.CanQuery = true
        prt.CanCollide = true
    end 
end

local walkspeed = 16

local walkspeedenabled = false

local kickland = {}
local gettingkicked = {}

local SL = tpland["Spawn"]
idlo = "Spawn"

game.workspace.DescendantRemoving:Connect(function(prt)
	if prt == game.Players.LocalPlayer.Character then
		for _,prt in pairs(game.workspace:GetChildren()) do
			if prt.Name == "GrabParts" then
				prt.Name = "OfflineGrabParts"
			end
		end
		task.wait()
		while not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
			task.wait()
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SL
		print("Respawning At "..idlo)
		while not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") do
			task.wait()
		end
		game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if walkspeedenabled then
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed * 16
			end
		end)
		if walkspeedenabled then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed * 16
		end
	elseif prt.Name == "Humanoid" and prt.Parent.Name ~= "YouDecoy" then
		if prt.Health == 0 then
			print(prt.Parent.Name.." Has Reset")
		else
			print(prt.Parent.Name.." Has Died")
		end
	end
end)

game.workspace.ChildAdded:Connect(function(model)
	task.wait()
	if model.Name == "BlackHoleKick" then
		local solved = false
		while not solved do
			if model ~= nil then
				for _,plr in pairs(game.Players:GetChildren()) do
					if plr.Character then
						if plr.Character:FindFirstChild("HumanoidRootPart") then
							if plr.Character.HumanoidRootPart.Anchored == true then
								solved = true
								local alrflagged = false
								for _,plrr in pairs(gettingkicked) do
									if plrr == plr.UserId then
										alrflagged = true
									end
								end
								local alreadythere = false
								for _,plrr in pairs(kickland) do
									if plrr == plr.UserId then
										alreadythere = true
									end
								end
								table.insert(kickland,plr.UserId)
								table.insert(kickland,plr.Name)
								table.insert(kickland,plr.DisplayName)
								table.insert(kickland,math.floor(model.Hole.CFrame.Position.X).."  "..math.floor(model.Hole.CFrame.Position.Y).."  "..math.floor(model.Hole.CFrame.Position.Z))
								local hpp = plr.Character.HumanoidRootPart.CFrame.Position
								local bhk = model.Hole.CFrame.Position
								local distance = Vector3.new((hpp.X-bhk.X)^2,(hpp.Y-bhk.Y)^2,(hpp.Z-bhk.Z)^2)
								local byplayer = false
								if math.sqrt(distance.X+distance.Y+distance.Z) > 2 then
									table.insert(kickland,true)
									byplayer = true
								else
									table.insert(kickland,false)
								end
								if not alrflagged then
									local H = plr.UserId
									table.insert(gettingkicked,H)
									if byplayer then
										game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">"..plr.DisplayName.." (@"..plr.Name..") has been kicked by a player at position ("..math.floor(model.Hole.CFrame.Position.X).."  "..math.floor(model.Hole.CFrame.Position.Y).."  "..math.floor(model.Hole.CFrame.Position.Z)..")</font>")
										Rayfield:Notify({
											Title = "Join Logger",
											Content = plr.DisplayName.." (@"..plr.Name..") has been kicked by a player at position ("..math.floor(model.Hole.CFrame.Position.X).."  "..math.floor(model.Hole.CFrame.Position.Y).."  "..math.floor(model.Hole.CFrame.Position.Z)..")",
											Duration = 6.5,
											Image = 4483362458,
										})
									else
										game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">"..plr.DisplayName.." (@"..plr.Name..") has been kicked at position ("..math.floor(model.Hole.CFrame.Position.X).."  "..math.floor(model.Hole.CFrame.Position.Y).."  "..math.floor(model.Hole.CFrame.Position.Z)..")</font>")
										Rayfield:Notify({
											Title = "Join Logger",
											Content = plr.DisplayName.." (@"..plr.Name..") has been kicked at position ("..math.floor(model.Hole.CFrame.Position.X).."  "..math.floor(model.Hole.CFrame.Position.Y).."  "..math.floor(model.Hole.CFrame.Position.Z..")"),
											Duration = 6.5,
											Image = 4483362458,
										})
									end
									task.wait(10)
									local line = 1
									for _,var in pairs(gettingkicked) do
										if var == H then
											table.remove(gettingkicked,line)
										end
										line = line+1
									end
								end
							end
						end
					end
				end
			else
				game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">Unable to check who was kicked</font>")
				solved = true
			end
			task.wait()
		end
	end
end)

local joinland = {}
local currantplrlist = {}

for _,plr in pairs(game.Players:GetChildren()) do
	table.insert(joinland,plr.UserId)
	table.insert(joinland,plr.Name)
	table.insert(joinland,plr.DisplayName)
	table.insert(currantplrlist,plr.Name)
end

game:GetService("Players").ChildAdded:Connect(function(plr)
	table.insert(currantplrlist,plr.Name)
	task.wait()
	local beenbefore = false
	local kickedbefore = false
	for _,itm in pairs(kickland) do
		if itm == plr.UserId then
			kickedbefore = true
		end
	end
	for _,itm in pairs(joinland) do
		if itm == plr.UserId then
			beenbefore = true
		end
	end
	if plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
		if beenbefore then
			diduel = "Your friend "..plr.DisplayName.." (@"..plr.Name..") has rejoined",
			game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(150,150,150)\">"..plr.DisplayName.." (@"..plr.Name..") has rejoined</font>")
		else
			table.insert(joinland,plr.UserId)
			table.insert(joinland,plr.Name)
			table.insert(joinland,plr.DisplayName)
			diduel = plr.DisplayName.." (@"..plr.Name..") has joined the game",
			game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(150,150,150)\">Your friend "..plr.DisplayName.." (@"..plr.Name..") has joined the game</font>")
		end	
	elseif kickedbefore then
		diduel = plr.DisplayName.." (@"..plr.Name..") has rejoined",
		game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">"..plr.DisplayName.." (@"..plr.Name..") has rejoined</font>")
	else
		if beenbefore then
			diduel = plr.DisplayName.." (@"..plr.Name..") has rejoined",
			game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(150,150,150)\">"..plr.DisplayName.." (@"..plr.Name..") has rejoined</font>")
		else
			table.insert(joinland,plr.UserId)
			table.insert(joinland,plr.Name)
			table.insert(joinland,plr.DisplayName)
			diduel = plr.DisplayName.." (@"..plr.Name..") has joined the game",
			game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(150,150,150)\">"..plr.DisplayName.." (@"..plr.Name..") has joined the game</font>")
		end	
	end
	Rayfield:Notify({
		Title = "Join Logger",
		Content = diduel,
		Duration = 6.5,
		Image = 4483362458,
	})
end)

game:GetService("Players").ChildRemoved:Connect(function(plr)
	local line = 1
	for _,var in pairs(currantplrlist) do
		if var == plr then
			table.remove(currantplrlist,line)
		end
		line = line+1
	end
	local alrflagged = false
	for _,plrr in pairs(gettingkicked) do
		if plrr == plr.UserId then
			alrflagged = true
		end
	end
	if not alrflagged then
		game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(150,150,150)\">"..plr.DisplayName.." (@"..plr.Name..") has left the game</font>")
		Rayfield:Notify({
			Title = "Join Logger",
			Content = plr.DisplayName.." (@"..plr.Name..") has left the game",
			Duration = 6.5,
			Image = 4483362458,
		})
	end
end)

local antibanana = false

for _,plr in pairs(game.Players:GetChildren()) do
    for _,model in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
    end
    game.workspace:FindFirstChild(plr.Name.."SpawnedInToys").ChildAdded:Connect(function(model)
    end)
end

for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
    for _,model in pairs(plot:GetChildren()) do
    end
    plot.ChildAdded:Connect(function(model)
    end)
end

function UnDesync(plr)
	for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
		if plot.Name ~= "PlayersInPlots" then
			for _,itm in pairs(plot:GetChildren()) do
				if itm.Name == "CreatureBlobman" then
					if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("RightDetector") and plr.Character then
						if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.RightDetector:FindFirstChild("RightWeld") and plr.Character:FindFirstChild("HumanoidRootPart") then
							itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.RightDetector["RightWeld"],plr.Character.HumanoidRootPart)
						end
					end
					if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("LeftDetector") and plr.Character then
						if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.LeftDetector:FindFirstChild("LeftWeld") and plr.Character:FindFirstChild("HumanoidRootPart") then
							itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.LeftDetector["LeftWeld"],plr.Character.HumanoidRootPart)
						end
					end
				end
			end
		end
	end
	for _,plr in pairs(game.Players:GetChildren()) do
		if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
			for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
				if itm.Name == "CreatureBlobman" then
					if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("RightDetector") and plr.Character then
						if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.RightDetector:FindFirstChild("RightWeld") and plr.Character:FindFirstChild("HumanoidRootPart") then
							itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.RightDetector["RightWeld"],plr.Character.HumanoidRootPart)
						end
					end
					if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("LeftDetector") and plr.Character then
						if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.LeftDetector:FindFirstChild("LeftWeld") and plr.Character:FindFirstChild("HumanoidRootPart") then
							itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.LeftDetector["LeftWeld"],plr.Character.HumanoidRootPart)
						end
					end
				end
			end
		end
	end
end

function Boner(itm)
	if not itm:FindFirstChild("BonerPart") then
        itm.Center.Transparency = 1
        itm.SoundPart.BillboardGui.ImageLabel.Visible = false
        itm.SoundPart.Attachment.PointLight.Enabled = false
        itm.SoundPart.Attachment.ParticleEmitter.Enabled = false
        itm.SoundPart.Size = Vector3.new(10,10,10)
        itm.SoundPart.Shape = "Block"
        local a = Instance.new("ManualWeld")
        local b = Instance.new("Part")
        b.Parent = itm
        b.CanQuery = false
    	b.CanCollide = false
        b.CanTouch = false
        b.Size = Vector3.new(10,10,10)
        b.Name = "BonerPart"
        b.Anchored = false
        b.Massless = true

        a.Parent = b
    	a.Name = "BonerGlue"
        a.Part0 = b
        a.Part1 = itm.Center

        local aa = Instance.new("Decal")
        aa.Texture = "rbxassetid://120974828567943"
        aa.Name = "DaveBoner"
        aa.Parent = b
            
        local ab = Instance.new("Decal")
        ab.Texture = "rbxassetid://120974828567943"
        ab.Name = "DaveBoner"
        ab.Face = "Back"
        ab.Parent = b

        local ac = Instance.new("Decal")
        ac.Texture = "rbxassetid://120974828567943"
        ac.Name = "DaveBoner"
        ac.Face = "Top"
        ac.Parent = b
            
        local ad = Instance.new("Decal")
        ad.Texture = "rbxassetid://120974828567943"
        ad.Name = "DaveBoner"
        ad.Face = "Bottom"
        ad.Parent = b

        local ae = Instance.new("Decal")
        ae.Texture = "rbxassetid://120974828567943"
        ae.Name = "DaveBoner"
        ae.Face = "Left"
        ae.Parent = b
            
        local af = Instance.new("Decal")
        af.Texture = "rbxassetid://120974828567943"
        af.Name = "DaveBoner"
        af.Face = "Right"
        af.Parent = b
    end
end

function UnBoner(itm)
	if itm:FindFirstChild("BonerPart") then
    	itm.Center.Transparency = 0
     	itm.SoundPart.BillboardGui.ImageLabel.Visible = true
     	itm.SoundPart.Attachment.PointLight.Enabled = true
     	itm.SoundPart.Attachment.ParticleEmitter.Enabled = true
     	itm.SoundPart.Size = Vector3.new(3,3,3)
     	itm.SoundPart.Shape = "Block"
		itm.BonerPart:Destroy()
	end
end

local Window = Rayfield:CreateWindow({
   Name = "BinisJ - Nigga Edition",
   Icon = 0,
   LoadingTitle = "BinisJ - Nigga Edition",
   LoadingSubtitle = "by Dillywag",
   Theme = "Serenity",

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,
})

local GrabStuff = Window:CreateTab("Grab Stuff", 4483362458)

local BM = GrabStuff:CreateSection("Big Muscles")

local BMA = false

local BMT = GrabStuff:CreateToggle({
    Name = "Activate Big Muscles",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		BMA = Value
		while BMA do
			if game.workspace:FindFirstChild("GrabParts") then
				if game.workspace.GrabParts:FindFirstChild("DragPart") then
					if game.workspace.GrabParts.DragPart:FindFirstChild("AlignOrientation") then
						game.workspace.GrabParts.DragPart.AlignOrientation.MaxTorque = math.huge
					end
					if game.workspace.GrabParts.DragPart:FindFirstChild("AlignPosition") then
						game.workspace.GrabParts.DragPart.AlignPosition.MaxForce = math.huge
					end
				end
			end
			task.wait()
		end
	end,
})

local XToDelete = GrabStuff:CreateSection("X To Delete Item (Instant but buggy)")

local XTD = false

local XTODELETE = GrabStuff:CreateKeybind({
	Name = "X To Delete (Instant but buggy)",
	CurrentKeybind = "X",
	HoldToInteract = false,
	Flag = "Keybind1", 
	Callback = function(Keybind)
		if XTD then
			local b = nil
			local p1 = nil
			local p2 = nil
			local p3 = nil
			local p4 = nil
			if game:GetService("Workspace"):FindFirstChild("GrabParts") then
				p1 = game:GetService("Workspace"):FindFirstChild("GrabParts")
			else return end

			if not p1:FindFirstChild("GrabPart") then return end
			p2 = p1.GrabPart
			if not p2:FindFirstChild("WeldConstraint") then return end
			p3 = p2.WeldConstraint
			if not p3:FindFirstChild("Part1") then return end
			b = p3.Part1

			if b.Parent:FindFirstChild("HumanoidRootPart") then
				b.Parent.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
				game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
				workspace.GrabParts:Destroy()
				if b.Parent:FindFirstChild("Head") then
					b.Parent.Head.AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("HumanoidRootPart") then
					b.Parent.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("Torso") then
					b.Parent.Torso.AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("Right Arm") then
					b.Parent:FindFirstChild("Right Arm").AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("Left Arm") then
					b.Parent:FindFirstChild("Left Arm").AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("Right Leg") then
					b.Parent:FindFirstChild("Right Leg").AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				if b.Parent:FindFirstChild("Left Leg") then
					b.Parent:FindFirstChild("Left Leg").AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				end
				Rayfield:Notify({
					Title = b.Parent.Name.." Delted",
					Content = "X To Delete",
					Duration = 6.5,
					Image = 4483362458,
				})
			elseif b.Parent:FindFirstChild("SoundPart") then
				b.Parent:FindFirstChild("SoundPart").AssemblyLinearVelocity = Vector3.new(0,0,0)
				game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
				task.wait()
				b.Parent:FindFirstChild("SoundPart").AssemblyLinearVelocity = Vector3.new(0,-1000000,0)
				Rayfield:Notify({
					Title = b.Parent.Name.." Delted",
					Content = "X To Delete",
					Duration = 6.5,
					Image = 4483362458,
				})
			end
		end
	end,
})

local XTDE = GrabStuff:CreateToggle({
    Name = "Activate X To Delete",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		XTD = Value
		if Value then
            Rayfield:Notify({
                Title = "X To Delete enabled",
                Content = "X To Delete",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
            Rayfield:Notify({
                Title = "X To Delete disabled",
                Content = "X To Delete",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
	end,
})


local PrisonT = GrabStuff:CreateSection("Prison")

local prisonactive = false

local locc = tpland["Prison"]
local loccc = "Prison"

local Prison = GrabStuff:CreateKeybind({
	Name = "Send To Location",
	CurrentKeybind = "Q",
	HoldToInteract = false,
	Flag = "Keybind1", 
	Callback = function(Keybind)
		if prisonactive then
			local b = nil
			local p1 = nil
			local p2 = nil
			local p3 = nil
			local p4 = nil
			local s = false
			if game:GetService("Workspace"):FindFirstChild("GrabParts") then
				p1 = game:GetService("Workspace"):FindFirstChild("GrabParts")
			else return end

			if not p1:FindFirstChild("GrabPart") then return end
			p2 = p1.GrabPart
			if not p2:FindFirstChild("WeldConstraint") then return end
			p3 = p2.WeldConstraint
			if not p3:FindFirstChild("Part1") then return end
			b = p3.Part1.Parent

			for _,plr in pairs(game:GetService("Players"):GetChildren()) do
				if plr.Character == b then
					s = true
					game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
					game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean, game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean.CFrame)
					task.wait()
					if b:FindFirstChild("Head") then
						b.Head.CFrame = locc
					end
					if b:FindFirstChild("HumanoidRootPart") then
						b.HumanoidRootPart.CFrame = locc
					end
					if b:FindFirstChild("Torso") then
						b.Torso.CFrame = locc
					end
					if b:FindFirstChild("Right Arm") then
						b:FindFirstChild("Right Arm").CFrame = locc
					end
					if b:FindFirstChild("Left Arm") then
						b:FindFirstChild("Left Arm").CFrame = locc
					end
					if b:FindFirstChild("Right Leg") then
						b:FindFirstChild("Right Leg").CFrame = locc
					end
					if b:FindFirstChild("Left Leg") then
						b:FindFirstChild("Left Leg").CFrame = locc
					end
					Rayfield:Notify({
						Title = "Prison Grab",
						Content = plr.DisplayName.." (@"..plr.Name..") was sent to "..loccc,
						Duration = 6.5,
						Image = 4483362458,
					})
				end
			end

			if not s then
				if b.Name == "YouClone" then
					game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
					game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean, game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean.CFrame)
					task.wait()
					if b:FindFirstChild("Head") then
						b.Head.CFrame = locc
					end
					if b:FindFirstChild("HumanoidRootPart") then
						b.HumanoidRootPart.CFrame = locc
					end
					if b:FindFirstChild("Torso") then
						b.Torso.CFrame = locc
					end
					if b:FindFirstChild("Right Arm") then
						b:FindFirstChild("Right Arm").CFrame = locc
					end
					if b:FindFirstChild("Left Arm") then
						b:FindFirstChild("Left Arm").CFrame = locc
					end
					if b:FindFirstChild("Right Leg") then
						b:FindFirstChild("Right Leg").CFrame = locc
					end
					if b:FindFirstChild("Left Leg") then
						b:FindFirstChild("Left Leg").CFrame = locc
					end
					Rayfield:Notify({
						Title = "Prison Grab",
						Content = "Clone was sent to "..loccc,
						Duration = 6.5,
						Image = 4483362458,
					})
				elseif b.Name == "CreatureBlobman" then
					game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
					game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean, game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean.CFrame)
					task.wait()
					b.HumanoidRootPart.CFrame = locc
					Rayfield:Notify({
						Title = "Prison Grab",
						Content = "Blobman was sent to "..loccc,
						Duration = 6.5,
						Image = 4483362458,
					})
				elseif b:FindFirstChild("SoundPart") then
					game:GetService("ReplicatedStorage").GrabEvents.DestroyGrabLine:FireServer(workspace.GrabParts.GrabPart.WeldConstraint.Part1)
					game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean, game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel.Ocean.CFrame)
					task.wait()
					b.SoundPart.CFrame = locc
					Rayfield:Notify({
						Title = "Prison Grab",
						Content = b.Name.." was sent to "..loccc,
						Duration = 6.5,
						Image = 4483362458,
					})
				end
			end
		end
	end,
})

local AtivatePrison = GrabStuff:CreateToggle({
    Name = "Activate Send To Location",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		prisonactive = Value
		if Value then
            Rayfield:Notify({
                Title = "Send to prison enabled",
                Content = "Prison Grab",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
            Rayfield:Notify({
                Title = "Send to prison disabled",
                Content = "Prison grab",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
    end,
})

local TpLocation = GrabStuff:CreateDropdown({
	Name = "Tp Location",
	Options = {"Spawn","Prison","ChineseRoof","SpawnCave","GreenHouse","PinkHouse","Barn","BlueHouse","ChineseHouse","PurpleHouse","Factory","OtherGreenHouse","BigCave","GoodPrison","RuhubsDogAhhPrison","ExtremelyGoodPrison","TrainCave","IslandCave","UfoCave","BlueHouseSlot","SpawnSlot","HauntedSlot","RandomSlot","BeachSlot"},
	CurrentOption = {"Prison"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Option)
		for _,itm in pairs(Option) do
			locc = tpland[itm]
			loccc = itm
		end
	end,
})

local GotoPrison = GrabStuff:CreateButton({
	Name = "Go To Location (Teleportation)",
	Callback = function()
		if game.Players.LocalPlayer.Character then
			if game.Players.LocalPlayer.Characte:FindFirstChild("HumanoidRootPart") then
				game.Players.LocalPlayer.Characte.HumanoidRootPart.CFrame = locc
				Rayfield:Notify({
					Title = "Teleportation",
					Content = game:GetService("Players").LocalPlayer.Name.." was sent to "..loccc,
					Duration = 6.5,
					Image = 4483362458,
				})
			end
		end
	end,
})

local GotoSpawn = GrabStuff:CreateButton({
	Name = "Go To Spawn (Teleportation)",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,-7.35,0)
		Rayfield:Notify({
			Title = "Teleportation",
			Content = game:GetService("Players").LocalPlayer.Name.." was sent to spawn",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

local Blobman = Window:CreateTab("Blobman", 4483362458)

local GMan = Blobman:CreateSection("Godman")

local antiboid = false

GManE = false
GmanH = -1000000
local prevvalue = -1000000

local GManI = Blobman:CreateInput({
	Name = "Set Godman Height",
	CurrentValue = "-1000000",
	PlaceholderText = "Set to -1000000",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(Text)
		if tonumber(Text) < 10000000 or tonumber(Text) > -10000000 then
			GmanH = tonumber(Text)
			prevvalue = tonumber(Text)
		else
			Rayfield:Notify({
				Title = "Going this high will kick you",
				Content = "Anti-Ownership Kick",
				Duration = 6.5,
				Image = 4483362458,
			})
		end
	end,
})

local GManz = Blobman:CreateButton({
	Name = "Set Godman Height To 0",
	Callback = function()
		GmanH = 0
		if game.Players.LocalPlayer.Character.Humanoid then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SL
			game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
		end
		GManI:Set(0)
	end,
})

local GManE = Blobman:CreateToggle({
    Name = "Enable Godman",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		GManE = Value
		if not Value then
			if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SL
				game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
			end
		end
		while GManE do
			if game.Players.LocalPlayer.Character then
				if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
						if GmanH < workspace.FallenPartsDestroyHeight then
							workspace.FallenPartsDestroyHeight = 0/0
							task.wait()
							Rayfield:Notify({
								Title = "Void has been disabled",
								Content = "Anti-Void",
								Duration = 6.5,
								Image = 4483362458,
							})
						end
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,GmanH,0)
						game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
						task.wait()
						if not game.Players.LocalPlayer.Character.Humanoid.SeatPart then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = SL
							game.Players.LocalPlayer.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
						end
					else
						task.wait()
					end
				end
			end
			task.wait()
		end
    end,
})

local GP = Blobman:CreateSection("Grab Player")

local selplr = nil

local list1 = {}

for _,plr in pairs(game.Players:GetChildren()) do
	if plr ~= game.Players.LocalPlayer then
		table.insert(list1,plr.Name)
	end
end

local GRP = Blobman:CreateDropdown({
	Name = "Select Player",
	Options = list1,
	CurrentOption = {"Select some nigga"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Option)
		for _,plr in pairs(Option) do
			selplr = plr
		end
	end,
})

local Refresh1 = Blobman:CreateButton({
    Name = "Refresh List",
    Callback = function()
		list1 = {}
		for _,plr in pairs(game.Players:GetChildren()) do
			if plr ~= game.Players.LocalPlayer then
				table.insert(list1,plr.Name)
			end
		end
		GRP:Refresh(list1)
    end,
})

local GP = Blobman:CreateButton({
    Name = "Grab Player",
    Callback = function()
		if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
			if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
				local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
			end
		end
    end,
})

local BP = Blobman:CreateButton({
    Name = "Bring Player",
    Callback = function()
		if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
			if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
				local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
				task.wait(0.25)
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players:FindFirstChild(selplr).Character.HumanoidRootPart)
			end
		end
    end,
})

local DP = Blobman:CreateButton({
    Name = "Desync Player",
    Callback = function()
		if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
			if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
				local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players.LocalPlayer.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
				blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
			end
		end
    end,
})

local UDP = Blobman:CreateButton({
    Name = "UnDesync Player",
    Callback = function()
		if game.Players:FindFirstChild(selplr) then
			if game.Players:FindFirstChild(selplr).Character then
				if game.Players:FindFirstChild(selplr).Character:FindFirstChild("HumanoidRootPart") then
					if game.Players:FindFirstChild(selplr).Character.HumanoidRootPart.Massless then
						UnDesync(game.Players:FindFirstChild(selplr))
					end
				end
			end
		end
    end,
})

local KP = Blobman:CreateButton({
    Name = "Kick Player",
    Callback = function()
        while game.Players:FindFirstChild(selplr) do
        	local held = false
            if game.Players.LocalPlayer.Character then
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        		    if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
        				if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
        					local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
        					if game.Players:FindFirstChild(selplr).Character then
        						if not held then
        							blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
        							task.wait(0.1)
        							if game.Players:FindFirstChild(selplr).Character then
        								blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players:FindFirstChild(selplr).Character.HumanoidRootPart)
        								task.wait(0.1)
        								if game.Players:FindFirstChild(selplr).Character then
        									local hispos = game.Players:FindFirstChild(selplr).Character.HumanoidRootPart.CFrame.Position
        									local mypos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        									local distance = Vector3.new((hispos.X-mypos.X)^2,(hispos.Y-mypos.Y)^2,(hispos.Z-mypos.Z)^2)
        									if math.sqrt(distance.X+distance.Y+distance.Z) < 30 then
        										game:GetService("ReplicatedStorage").GrabEvents.SetNetworkOwner:FireServer(game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart.CFrame)
        										while game.Players:FindFirstChild(selplr).IsHeld.Value do
        											if game.Players:FindFirstChild(selplr).Character and game.Players.LocalPlayer.Character then
        												if game.Players:FindFirstChild(selplr).Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        													for _,prt in pairs(game.Players:FindFirstChild(selplr).Character:GetChildren()) do
        														if prt.ClassName == "Part" then
        															prt.AssemblyLinearVelocity = Vector3.new(0,1000,0)
        														end
        													end
        													task.wait()
        													local hispos2 = game.Players:FindFirstChild(selplr).Character.HumanoidRootPart.CFrame.Position
        													local mypos2 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        													local distance2 = Vector3.new((hispos2.X-mypos2.X)^2,(hispos2.Y-mypos2.Y)^2,(hispos2.Z-mypos2.Z)^2)
															if math.sqrt(distance2.X+distance2.Y+distance2.Z) > 1000 then
        														game.ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(game.Players:FindFirstChild(selplr).Character.HumanoidRootPart)
        														task.wait()
        														blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(blob.RightDetector,game.Players:FindFirstChild(selplr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
        														blob.BlobmanSeatAndOwnerScript.CreatureGrab:FireServer(blob.RightDetector,game.Players.LocalPlayer.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
        														blob.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
        														held = true
        														while held do
        															if game.Players:FindFirstChild(selplr) then
        																if game.Players:FindFirstChild(selplr).Character then
        																	for _,prt in pairs(game.Players:FindFirstChild(selplr).Character:GetChildren()) do
        																		if prt.ClassName == "Part" then
        																			if not prt.Massless then
        																				held = false
        																			end
        																		end
        																	end
																			if not game.Players:FindFirstChild(selplr).Character:FindFirstChild("Head") or not game.Players:FindFirstChild(selplr).Character:FindFirstChild("Torso") or not game.Players:FindFirstChild(selplr).Character:FindFirstChild("HumanoidRootPart") then
																				held = false
																			end
        																else
        																	held = false
																		end
																	end
        															task.wait()
        														end
        													end
        												end
        											end
        											task.wait()
        										end
        									end
        								end
        							end
        						end
        					end
        				else
        					game.Players.LocalPlayer.Character.Humanoid.Sit = false
        				end
                    end
        		end
            end
            task.wait()
        end
    end,
})

local Player = Window:CreateTab("Player", 4483362458)

local Walk = Player:CreateSection("Walk And Jump")

local WalkSpeed = Player:CreateSlider({
	Name = "Walk Speed",
	Range = {0, 50},
	Increment = 0.1,
	Suffix = "Walkspeed",
	CurrentValue = 1,
	Flag = "Slider1",
	Callback = function(Value)
		walkspeed = Value
	end,
})

local WalkSpeedT = Player:CreateToggle({
    Name = "Toggle Walkspeed",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		walkspeedenabled = Value
		if Value then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
            Rayfield:Notify({
                Title = "Walkspeed enabled",
                Content = "Toggle Walkspeed",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlots" then
					for _,itm in pairs(plot:GetChildren()) do
						if itm.Name == "CreatureBlobman" then
							itm:WaitForChild("Humanoid").WalkSpeed = walkspeed * 20
						end
					end
				end
			end
			for _,plr in pairs(game.Players:GetChildren()) do
				if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
					for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
						if itm.Name == "CreatureBlobman" then
							itm:WaitForChild("Humanoid").WalkSpeed = walkspeed * 20
						end
					end
				end
			end
            Rayfield:Notify({
                Title = "Walkspeed disabled",
                Content = "Toggle Walkspeed",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
		while walkspeedenabled do
			if game.Players.LocalPlayer.Character then
				if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed * 16
				end
			end
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlots" then
					for _,itm in pairs(plot:GetChildren()) do
						if itm.Name == "CreatureBlobman" then
							if itm:FindFirstChild("HumanoidCreature") then
								itm.HumanoidCreature.WalkSpeed = walkspeed * 20
							end
						end
					end
				end
			end
			for _,plr in pairs(game.Players:GetChildren()) do
				if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
					for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
						if itm:FindFirstChild("HumanoidCreature") then
							itm.HumanoidCreature.WalkSpeed = walkspeed * 16
						end
					end
				end
			end
			task.wait()
		end
	end,
})

local Jump = Player:CreateSection("Jump")

local InfJE = false

local ThirdP = Player:CreateToggle({
    Name = "Infinite Jump ",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		InfJE = Value
	end,
})

infJump = game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfJE then
		if game.Players.LocalPlayer.Character then
			if game.Players.LocalPlayer.Character.Humanoid then
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

local Tp = Player:CreateSection("Third Person")

local tpon = false

local ThirdP = Player:CreateToggle({
    Name = "Third Person",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		tpon = Value
		if Value then
			game.Players.LocalPlayer.CameraMode = "Classic"
		else
			game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
		end
		while tpon do
			if game.Players.LocalPlayer.Character then
				for _,prt in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if prt.ClassName == "Part" and prt.Name ~= "HumanoidRootPart" then
						prt.Transparency = 0
					end
				end
			end
			task.wait()
		end
	end,
})

local AntiStuff = Window:CreateTab("Anti-Shit", 4483362458)

local RDAAG = false

local RHAG = AntiStuff:CreateToggle({
    Name = "Ruhubs dog ahh antigrab",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		RDAAG = Value
		while RDAAG do
			while game:GetService("Players").LocalPlayer.IsHeld.Value do
				game:GetService("ReplicatedStorage").CharacterEvents.Struggle:FireServer(plr)
				game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
				task.wait()
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
			task.wait()
		end
    end,
})

local antifirepart = game.workspace.Plots.Plot5.Barrier:FindFirstChild("PlotBarrier")
antifirepart.CanCollide = true
antifirepart.CanQuery = true
antifirepart.Name = "AntiFirePart"
local h = antifirepart:Clone()
h.Name = "FalseBorder"
h.Parent = antifirepart.Parent
antifirepart.Size = Vector3.new(1,1,1)
for _,prt in pairs(antifirepart:GetChildren()) do
	prt:Destroy()
end
antifirepart.CanQuery = false
antifirepart.CanCollide = false
AFE = false

local AF = AntiStuff:CreateToggle({
    Name = "Anti-Fire",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		AFE = Value
		while AFE do
			antifirepart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			antifirepart.CanCollide = not antifirepart.CanCollide
			task.wait()
		end
		antifirepart.CFrame = CFrame.new(0,0,0)
    end,
})

local AntiBanana = AntiStuff:CreateToggle({
    Name = "Anti-Banana",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		antibanana = Value
		while antibanana do
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlot" then
					for _,model in pairs(plot:GetChildren()) do
						if model.Name == "FoodBanana" then
							if model:FindFirstChild("HoldPart") then
								if model.HoldPart:FindFirstChild("HoldItemRemoteFunction") then
									model.HoldPart.HoldItemRemoteFunction:InvokeServer(model,game:GetService("Players").LocalPlayer.Character)
									if model.HoldPart:FindFirstChild("DropItemRemoteFunction") then
										model.HoldPart.DropItemRemoteFunction:InvokeServer(model,CFrame.new(0,-10^40,0),Vector3.new(0,-46.05,0))
									end
								end
							end
						end
					end
				end
			end
			for _,plr in pairs(game.Players:GetChildren()) do
				if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") and plr ~= game.Players.LocalPlayer then
					for _,model in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
						if model.Name == "FoodBanana" then
							if model:FindFirstChild("HoldPart") then
								if model.HoldPart:FindFirstChild("HoldItemRemoteFunction") then
									model.HoldPart.HoldItemRemoteFunction:InvokeServer(model,game:GetService("Players").LocalPlayer.Character)
									if model.HoldPart:FindFirstChild("DropItemRemoteFunction") then
										model.HoldPart.DropItemRemoteFunction:InvokeServer(model,CFrame.new(0,-10^40,0),Vector3.new(0,-46.05,0))
									end
								end
							end
						end
					end
				end
			end
			task.wait()
		end
    end,
})

local AK = false

local Penis = AntiStuff:CreateToggle({
    Name = "Penis Anti-Kick",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		AK = Value
		while AK do
		    while not game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys"):FindFirstChild("ToolPencil") do
		        if game.Players.LocalPlayer.Character then
    		        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    		            game.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("ToolPencil",CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position)+Vector3.new(0,0,15),Vector3.new(0,0,0))
    		        end
    		    end
    		    task.wait()
    		end
    		if game.Players.LocalPlayer.Character then
    		    if game.Players.LocalPlayer.Character:FindFirstChild("Torso") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys"):FindFirstChild("ToolPencil") then
    		        if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil:FindFirstChild("StickyPart") then
    		            if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart:FindFirstChild("StickyWeld") then
    		                if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart.StickyWeld.Part1 ~= game.Players.LocalPlayer.Character.Torso then
    		                    local a = game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.SoundPart.CFrame.Position
    		                    local b = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
    		                    local distance = Vector3.new((a.X-b.X)^2,(a.Y-b.Y)^2,(a.Z-b.Z)^2)
    		                    if math.sqrt(distance.X+distance.Y+distance.Z) > 20 then
    		                        game.ReplicatedStorage.MenuToys.DestroyToy:FireServer(game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil)
    		                    else
    		                        game.ReplicatedStorage.PlayerEvents.StickyPartEvent:FireServer(game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart,game.Players.LocalPlayer.Character.Torso,CFrame.new(0,-1,0) * CFrame.Angles(0,math.pi,0))
	                    		    for _,prt in pairs(game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil:GetChildren()) do
	                    		        if prt.ClassName == "Part" then
	                    		            prt.CanQuery = false
	                    		        end
                        		    end
                        		    task.wait(0.2)
                        		    if game.Players.LocalPlayer.Character then
                            		    if game.Players.LocalPlayer.Character:FindFirstChild("Torso") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys"):FindFirstChild("ToolPencil") then
                            		        if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil:FindFirstChild("StickyPart") then
                            		            if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart:FindFirstChild("StickyWeld") then
                            		                if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart.StickyWeld.Part1 ~= game.Players.LocalPlayer.Character.Torso then
                            		                    if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil then
                            		                        if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.StickyPart.StickyWeld.Part1 ~= game.Players.LocalPlayer.Character.Torso then
                            		                            game.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.SoundPart,game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys").ToolPencil.SoundPart.CFrame)
                            		                        end
                            		                    end
                            		                end
                            		            end
                            		        end
                            		    end
                            		end
								end
							end
                        end
                    end
                end
	        end
    		task.wait()
        end
    end,
})

local antiok = true

local AntiBlob = AntiStuff:CreateToggle({
    Name = "Anti Ownership Kick",
    CurrentValue = true,
    Flag = "Toggle1",
    Callback = function(Value)
		antiok = Value
		while antiok do
			if game.Players.LocalPlayer.Character then
				if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local distance = Vector3.new(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.X^2,game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.Y^2,game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.Z^2)
					if math.sqrt(distance.X+distance.Y+distance.Z) > 10000000 then
						game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = SL
					end
				end
			end
			task.wait()
		end
    end,
})

task.spawn(function()
		while antiok do
		if game.Players.LocalPlayer.Character then
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local distance = Vector3.new(game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.X^2,game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.Y^2,game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.Z^2)
				if math.sqrt(distance.X+distance.Y+distance.Z) > 10000000 then
					game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = SL
				end
			end
		end
		task.wait()
	end
end)

local antiblob = false

local AntiBlob = AntiStuff:CreateToggle({
    Name = "Antiblob",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		antiblob = Value
		while antiblob do
			if game.Players.LocalPlayer.Character then
				if not game.Players.LocalPlayer.Character:FindFirstChild("TruePositionPart") then
					local tp = Instance.new("Part")
					tp.Parent = game.Players.LocalPlayer.Character
					tp.Name = "TruePositionPart"
					tp.Anchored = true
					tp.CFrame = CFrame.new(0,-100,0)
				end
				for _,prt in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if prt.ClassName == "Part" then
						if prt.Massless then
							prt.Massless = false
							for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
								if plot.Name ~= "PlayersInPlots" then
									for _,itm in pairs(plot:GetChildren()) do
										if itm.Name == "CreatureBlobman" then
											if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("RightDetector") and game.Players.LocalPlayer.Character then
												if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.RightDetector:FindFirstChild("RightWeld") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
													itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
													game:GetService("ReplicatedStorage").CharacterEvents.Struggle:FireServer(game.Players.LocalPlayer)
												end
											end
										end
									end
								end
							end
							for _,plr in pairs(game.Players:GetChildren()) do
								if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
									for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
										if itm.Name == "CreatureBlobman" then
											if itm:FindFirstChild("BlobmanSeatAndOwnerScript") and itm:FindFirstChild("RightDetector") and game.Players.LocalPlayer.Character then
												if itm.BlobmanSeatAndOwnerScript:FindFirstChild("CreatureDrop") and itm.RightDetector:FindFirstChild("RightWeld") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
													itm.BlobmanSeatAndOwnerScript.CreatureDrop:FireServer(itm.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
													game:GetService("ReplicatedStorage").CharacterEvents.Struggle:FireServer(game.Players.LocalPlayer)
												end
											end
										end
									end
								end
							end
						end
					end
					if prt.Name == "HumanoidRootPart" then
						if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("RootAttachment") then
							task.wait(0.2)
							if game.Players.LocalPlayer.Character then
								if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("TruePositionPart") then
									game.Players.LocalPlayer.Character.HumanoidRootPart.RootAttachment.Parent = game.Players.LocalPlayer.Character.TruePositionPart
									Rayfield:Notify({
										Title = "Antiblob has been enabled",
										Content = "Antiblob",
										Duration = 6.5,
										Image = 4483362458,
									})
								end
							end
						end
					end
				end
			end
			task.wait()
		end
		if not Value and game.Players.LocalPlayer.Character then
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("TruePositionPart") then
				if game.Players.LocalPlayer.Character.TruePositionPart:FindFirstChild("RootAttachment") then
					game.Players.LocalPlayer.Character.TruePositionPart.RootAttachment.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					Rayfield:Notify({
						Title = "Antiblob has been disabled",
						Content = "Antiblob",
						Duration = 6.5,
						Image = 4483362458,
					})
				end
			end
		end
    end,
})

local AntiVoid = AntiStuff:CreateToggle({
    Name = "Disable Void",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		antiboid = Value
        if Value then 
            workspace.FallenPartsDestroyHeight = 0/0
            Rayfield:Notify({
                Title = "Void has been disabled",
                Content = "Anti-Void",
                Duration = 6.5,
                Image = 4483362458,
            })
        else
            workspace.FallenPartsDestroyHeight = -100
            Rayfield:Notify({
                Title = "Void has been enabled",
                Content = "Anti-Void",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

local AntiLag = AntiStuff:CreateToggle({
    Name = "Anti-Lag",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then 
            if game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove") then
				game:GetService("Players").LocalPlayer.PlayerScripts.CharacterAndBeamMove:Destroy()
			end
			for _,plr in pairs(game:GetService("Players"):GetChildren()) do
				if plr.Character:FindFirstChild("GrabParts") then
					plr.Character.GrabParts:Destroy()
				end
			end
            Rayfield:Notify({
                Title = "Anti-Lag has been enabled",
                Content = "Anti-Lag",
                Duration = 6.5,
                Image = 4483362458,
            })
        else
            if not game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove") then
				local scriptt = game:GetService("StarterPlayer").StarterPlayerScripts.CharacterAndBeamMove:Clone()
				scriptt.Parent = game:GetService("Players").LocalPlayer.PlayerScripts
			end
            Rayfield:Notify({
                Title = "Anti-Lag has been disabled",
                Content = "Anti-Lag",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

local VTPE = false

local VTP = AntiStuff:CreateToggle({
    Name = "View True Position",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        VTPE = Value
		while VTPE do
			for _,plr in pairs(game.Players:GetChildren()) do
				if plr.Character then
					if not plr.Character:FindFirstChild("TruePositionPart") then
						local tp = Instance.new("Part")
						tp.Parent = plr.Character
						tp.Name = "TruePositionPart"
						tp.Anchored = true
						tp.CFrame = CFrame.new(0,-100,0)
					end
					if plr.Character:FindFirstChild("HumanoidRootPart") then
						if plr.Character.HumanoidRootPart:FindFirstChild("RootAttachment") and plr.Character:FindFirstChild("TruePositionPart") then
							plr.Character.HumanoidRootPart.RootAttachment.Parent = plr.Character.TruePositionPart
						end
						for _,prt in pairs(plr.Character:GetChildren()) do
							if prt.ClassName == "Part" then
								prt.AssemblyLinearVelocity = Vector3.new(0,0,0)
							end
						end
					end
				end
			end
			task.wait()
		end
		if not Value then
			for _,plr in pairs(game.Players:GetChildren()) do
				if plr.Character then
					if plr.Character:FindFirstChild("TruePositionPart") and plr.Character:FindFirstChild("HumanoidRootPart") then
						if plr.Character.TruePositionPart:FindFirstChild("RootAttachment") then
							plr.Character.TruePositionPart.RootAttachment.Parent = plr.Character.HumanoidRootPart
						end
					end
				end
			end
		end
    end,
})

local Loops = Window:CreateTab("Loop Players", 4483362458)

local bloblist = {}

local bloblist2 = {}

local BL = Loops:CreateSection("Black-List")

local list2 = {}

WLL = true

for _,plr in pairs(game.Players:GetChildren()) do
	if plr ~= game.Players.LocalPlayer then
		table.insert(list2,plr.Name)
	end
end

local GRP2 = Loops:CreateDropdown({
	Name = "Black-List",
	Options = list2,
	CurrentOption = {"Select some nigga"},
	MultipleOptions = true,
	Flag = "Dropdown1",
	Callback = function(Option)
		bloblist = Option
	end,
})

local Refresh1 = Loops:CreateButton({
    Name = "Refresh List",
    Callback = function()
		list2 = {}
		for _,plr in pairs(game.Players:GetChildren()) do
			if plr ~= game.Players.LocalPlayer then
				table.insert(list2,plr.Name)
			end
		end
		GRP2:Refresh(list2)
    end,
})

local WL = Loops:CreateSection("White-List")

local list3 = {}

for _,plr in pairs(game.Players:GetChildren()) do
	if plr ~= game.Players.LocalPlayer or not plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
		table.insert(list3,plr.Name)
	end
end

local GRP3 = Loops:CreateDropdown({
	Name = "White-List",
	Options = list3,
	CurrentOption = {"Select some nigga"},
	MultipleOptions = true,
	Flag = "Dropdown1",
	Callback = function(Option)
		bloblist2 = Option
	end,
})

local AWF = Loops:CreateToggle({
    Name = "Auto-Whitelist Friends",
    CurrentValue = true,
    Flag = "Toggle1",
    Callback = function(Value)
		WLL = Value
	end,
})

local Refresh2 = Loops:CreateButton({
    Name = "Refresh List",
    Callback = function()
		list3 = {}
		for _,plr in pairs(game.Players:GetChildren()) do
			if plr ~= game.Players.LocalPlayer then
				if plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
					if not WLL then
						table.insert(list3,plr.Name)
					end
				else
					table.insert(list3,plr.Name)
				end
			end
		end
		GRP3:Refresh(list3)
    end,
})

local onneg1 = false

local UDW = Loops:CreateToggle({
    Name = "UnDesync Whitelisted",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		onneg1 = Value
		while onneg1 do
			for _,plr in pairs(game.Players:GetChildren()) do
				local wlsted = false
				if plr.Character then
					if plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
						if plr.Character:FindFirstChild("HumanoidRootPart") then
							if plr.Character.HumanoidRootPart.Massless then
								UnDesync(plr)
							end
						end
					end
				end
			end
			task.wait()
		end
	end,
})

local CL = Loops:CreateSection("Choose List")

local Listt = "White-List"

local GRP4 = Loops:CreateDropdown({
	Name = "Choose List",
	Options = {"White-List","Black-List"},
	CurrentOption = {"White-List"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Option)
		for _,itm in pairs(Option) do
			Listt = itm
		end
	end,
})

local L = Loops:CreateSection("Loops")

local onn = false

local DSAll = Loops:CreateToggle({
    Name = "UnDesync All",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		onn = Value
		while onn do
			for _,plr in pairs(game.Players:GetChildren()) do
				if plr.Character then
					if plr.Character:FindFirstChild("HumanoidRootPart") then
						if plr.Character.HumanoidRootPart.Massless then
							UnDesync(plr)
						end
					end
				end
			end
			task.wait()
		end
    end,
})

local on = false

local DSAll = Loops:CreateToggle({
    Name = "Desync Players",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		on = Value
		while on do
			if Listt == "White-List" then
				if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
					if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
						local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
						for _,plr in pairs(game.Players:GetChildren()) do
							local whitelisted = false
							if plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) or plr == game.Players.LocalPlayer then
								if WLL then
									whitelisted = true
								end
							end
							for _,str in pairs(bloblist2) do
								if plr.Name == str then
									whitelisted = true
								end
							end
							if not whitelisted then
								if plr then
									if plr.Character then
										if plr.Character:FindFirstChild("HumanoidRootPart") then
											if plr.Character:FindFirstChild("HumanoidRootPart").Massless == false then
												blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,plr.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
												blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players.LocalPlayer.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
												blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
											end
										end
									end
								end
							end
						end
					end
				end
			elseif Listt == "Black-List" then
				if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
					if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
						local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
						for _,plr in pairs(bloblist) do
							if game.Players:FindFirstChild(plr) then
								if game.Players:FindFirstChild(plr).Character then
									if game.Players:FindFirstChild(plr).Character:FindFirstChild("HumanoidRootPart") then
										if game.Players:FindFirstChild(plr).Character:FindFirstChild("HumanoidRootPart").Massless == false then
											blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(plr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
											blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players.LocalPlayer.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
											blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
										end
									end
								end
							end
						end
					end
				end
			end
			task.wait()
		end
    end,
})

local on2 = false

local DSAll = Loops:CreateToggle({
    Name = "Loop Grab Players",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		on2 = Value
		while on2 do
			if Listt == "White-List" then
				if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
					if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
						local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
						for _,plr in pairs(game.Players:GetChildren()) do
							local whitelisted = false
							if plr then
								if plr.Character then
									if plr:IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
										if WLL then
											whitelisted = true
										end
									end
								end
							end
							for _,str in pairs(bloblist2) do
								if plr.Name == str or plr == game.Players.LocalPlayer then
									whitelisted = true
								end
							end
							if not whitelisted then
								if plr then
									if plr.Character then
										if plr.Character:FindFirstChild("HumanoidRootPart") then
											blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,plr.Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
											task.wait()
											if game.Players:FindFirstChild(plr) then
												if game.Players.LocalPlayer.Character and game.Players:FindFirstChild(plr).Character then
													if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players:FindFirstChild(plr).Character:FindFirstChild("Humanoid") and game.Players:FindFirstChild(plr).Character:FindFirstChild("HumanoidRootPart") then
														if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
															if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
																blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			elseif Listt == "Black-List" then
				if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
					if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
						local blob = game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent
						for _,plr in pairs(bloblist) do
							if game.Players:FindFirstChild(plr) then
								if game.Players:FindFirstChild(plr).Character then
									if game.Players:FindFirstChild(plr).Character:FindFirstChild("HumanoidRootPart") then
										blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureGrab"):FireServer(blob.RightDetector,game.Players:FindFirstChild(plr).Character.HumanoidRootPart,blob.RightDetector["RightWeld"])
										task.wait()
										if game.Players:FindFirstChild(plr) then
											if game.Players.LocalPlayer.Character and game.Players:FindFirstChild(plr).Character then
												if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players:FindFirstChild(plr).Character:FindFirstChild("Humanoid") and game.Players:FindFirstChild(plr).Character:FindFirstChild("HumanoidRootPart") then
													if game.Players.LocalPlayer.Character.Humanoid.SeatPart then
														if game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.Name == "CreatureBlobman" then
															blob:FindFirstChild("BlobmanSeatAndOwnerScript"):FindFirstChild("CreatureDrop"):FireServer(blob.RightDetector["RightWeld"],game.Players.LocalPlayer.Character.HumanoidRootPart)
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
			task.wait()
		end
    end,
})

local MapStuff = Window:CreateTab("Map", 4483362458)

local Map = MapStuff:CreateSection("Edit Map")

local MapReload = MapStuff:CreateButton({
	Name = "Reload Map",
	Callback = function()
		for _,thing in pairs(mapp:GetChildren()) do
			if game:GetService("Workspace").Map:FindFirstChild(thing.Name) then
				local cclone = thing:Clone()
				cclone.Parent = game:GetService("Workspace").Map
				game:GetService("Workspace").Map:FindFirstChild(thing.Name):Destroy()
			else
				local cclone = thing:Clone()
				cclone.Parent = game:GetService("Workspace").Map
			end
		end
		Rayfield:Notify({
			Title = "Map reloaded",
			Content = "Reload Map",
			Duration = 6.5,
			Image = 4483362458,
		})
	end,
})

local PrivateMap = MapStuff:CreateToggle({
	Name = "Private Map",
	CurrentValue = false,
	Flag = "Toggle1", 
	Callback = function(Value)
		if Value and not game:GetService("Workspace"):FindFirstChild("PrivateMap") then
			nigga = mapp:Clone()
			if nigga:FindFirstChild("AlwaysHereTweenedObjects")then
				nigga.AlwaysHereTweenedObjects:Destroy()
			end
			if nigga:FindFirstChild("MapNoises")then
				nigga.MapNoises:Destroy()
			end
			game:GetService("Workspace").Plots:Clone().Parent = nigga
			game:GetService("Workspace").Slots:Clone().Parent = nigga
			nigga.Parent = game:GetService("Workspace")
			nigga.Name = "PrivateMap"
			nigga:SetPrimaryPartCFrame(CFrame.new(-5000,0,0))
			for _,prt in pairs(nigga.Plots:GetDescendants()) do
				if prt.Name == "PlotBarrier" or prt.Name == "PlotArea" or prt.Name == "FalseBorder" then
					prt.CanQuery = false
					prt.CanCollide = false
				end 
			end
			for _,jigga in pairs(nigga:GetChildren()) do
				if jigga.Name == "drip" then
					jigga:Destroy()
				end
			end
            Rayfield:Notify({
                Title = "Private map created",
                Content = "Private Map",
                Duration = 6.5,
                Image = 4483362458,
            })
		elseif not Value and game:GetService("Workspace"):FindFirstChild("PrivateMap") then
			game:GetService("Workspace").PrivateMap:Destroy()
            Rayfield:Notify({
                Title = "Private map destroyed",
                Content = "Private Map",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
	end,
})

local WW = MapStuff:CreateSection("Ocean")

local WaterWalk = MapStuff:CreateToggle({
    Name = "Water Walk",
    CurrentValue = true,
    Flag = "Toggle1",
    Callback = function(Value)
        local v1 = game:GetService("Workspace").Map.AlwaysHereTweenedObjects.Ocean.Object.ObjectModel
        for _,prt in pairs(v1:GetChildren()) do 
            if prt:IsA("Part") and prt.Name == "Ocean" then 
                prt.CanCollide = Value
            end
        end
        if Value then
            Rayfield:Notify({
                Title = "Water Walk has been enabled",
                Content = "Water Walk",
                Duration = 6.5,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Water Walk has been disabled",
                Content = "Water Walk",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

local InfOcean = MapStuff:CreateToggle({
    Name = "Infinite Ocean (adding later)",
    CurrentValue = true,
    Flag = "Toggle1",
    Callback = function(Value)
        end
    end,
})

local FreezeOcean = MapStuff:CreateToggle({
    Name = "Freeze Ocean (adding later)",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
    end,
})

local Plots = MapStuff:CreateSection("Edit Plots")

local PBC = MapStuff:CreateToggle({
    Name = "Plot Barrier Collision",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        for _,prt in pairs(game:GetService("Workspace").Plots:GetDescendants()) do
            if prt.Name == "PlotBarrier" or prt.Name == "FalseBorder" then
                prt.CanQuery = not(Value)
                prt.CanCollide = not(Value)
            end
        end
        if Value then
            Rayfield:Notify({
                Title = "Plot Collision has been disabled",
                Content = "Plot Collision",
                Duration = 6.5,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Plot Collision has been enabled",
                Content = "Plot Collision",
                Duration = 6.5,
                Image = 4483362458,
            })
        end
    end,
})

local GIP = MapStuff:CreateToggle({
    Name = "Grab People In Plots",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		GIPP = Value
		while GIPP do
			for _,diddly in pairs(game:GetService("Workspace").PlotItems.PlayersInPlots:GetChildren()) do
				diddly.Parent = plrinplot
			end
			task.wait()
		end
		if Value then
            Rayfield:Notify({
                Title = "You can grab people in plots",
                Content = "Grab people in plots",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
			for _,diddly in pairs(game:GetService("Workspace"):FindFirstChild("Players In Plots"):GetChildren()) do
				diddly.Parent = game:GetService("Workspace").PlotItems.PlayersInPlots
			end
            Rayfield:Notify({
                Title = "You can't grab people in plots",
                Content = "Grab people in plots",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
    end,
})

local canC = false

for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
	if plot.Name ~= "PlayersInPlots" then
		plot.ChildAdded:Connect(function(itm)
			task.wait()
			if canC then
				for _,prt in pairs(itm:GetChildren()) do
					if prt.ClassName == "Part" then
						prt.CollisionGroup = "Items"
					end
				end
			else
				for _,prt in pairs(itm:GetChildren()) do
					if prt.ClassName == "Part" then
						prt.CollisionGroup = "PlotItems"
					end
				end
			end
		end)
	end
end

local BBC = MapStuff:CreateToggle({
    Name = "Plot Item Collision",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		canC = Value
        while canC do
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlots" then
					for _,itm in pairs(plot:GetChildren()) do
						for _,prt in pairs(itm:GetChildren()) do
							if prt.ClassName == "Part" or prt.ClassName == "TrussPart" then
								prt.CollisionGroup = "Items"
							end
						end
					end
				end
			end
			for _,itm in pairs(dick:GetChildren()) do
				for _,prt in pairs(itm:GetChildren()) do
					if prt.ClassName == "Part" or prt.ClassName == "TrussPart" then
						prt.CollisionGroup = "Items"
					end
				end
			end
			task.wait()
		end
		if not Value then
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlots" then
					for _,itm in pairs(plot:GetChildren()) do
						for _,prt in pairs(itm:GetChildren()) do
							if prt.ClassName == "Part" then
								prt.CollisionGroup = "PlotItems"
							end
						end
					end
				end
			end
			for _,itm in pairs(dick:GetChildren()) do
				for _,prt in pairs(itm:GetChildren()) do
					if prt.ClassName == "Part" or prt.ClassName == "TrussPart" then
						prt.CollisionGroup = "Items"
					end
				end
			end
		end
    end,
})

local GPI = false

local BBC2 = MapStuff:CreateToggle({
    Name = "Grab Plot Items",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		GPI = Value
		while GPI do
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				if plot.Name ~= "PlayersInPlots" then		
					for _,itm in pairs(plot:GetChildren()) do
						itm.Parent = dick
					end
				end	
			end
			task.wait()
		end	
		for _,itm in pairs(dick:GetChildren()) do
			itm.Parent = game.workspace.PlotItems.Plot1
		end
    end,
})

local BBC3 = MapStuff:CreateToggle({
    Name = "Break Plot Barrier (adding later)",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
		for _,toy in pairs(game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys"):GetChildren()) do
			if toy.Name == "DiceSmall" then
				game.ReplicatedStorage.MenuToys.DestroyToy:FireServer(toy)
			end
		end
		game.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer("DiceSmall",CFrame.new(270,-7,448),Vector3.new(0,0,0))
		task.wait(0.5)
		if game.workspace:FindFirstChild(game.Players.LocalPlayer.Name.."SpawnedInToys"):FindFirstChild("DiceSmall") then return end
		print("Nigga barrier online")
    end,
})

local Model = MapStuff:CreateSection("Model Shit")

local bonerenabled = false

local Foggy = MapStuff:CreateToggle({
	Name = "Boner Objects",
	CurrentValue = false,
	Flag = "Toggle1", 
	Callback = function(Value)
		bonerenabled = Value
		while bonerenabled do
			for _,plr in pairs(game.Players:GetChildren()) do
				if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
					for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
					    if itm.Name == "BallMagicLight" then
        					Boner(itm)
    					end
					end
				end
			end
			for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
				for _,itm in pairs(plot:GetChildren()) do
					if itm.Name == "BallMagicLight" then
        				Boner(itm)
    				end
				end
			end
			task.wait()
		end
		for _,plr in pairs(game.Players:GetChildren()) do
			if game.workspace:FindFirstChild(plr.Name.."SpawnedInToys") then
				for _,itm in pairs(game.workspace:FindFirstChild(plr.Name.."SpawnedInToys"):GetChildren()) do
				    if itm.Name == "BallMagicLight" then
        				UnBoner(itm)
    				end
				end
			end
		end
		for _,plot in pairs(game.workspace.PlotItems:GetChildren()) do
			for _,itm in pairs(plot:GetChildren()) do
				if itm.Name == "BallMagicLight" then
        			UnBoner(itm)
    			end
			end
		end
	end,
})

local Fog = MapStuff:CreateSection("Fog")

local Foggy = MapStuff:CreateToggle({
	Name = "Foggy Map",
	CurrentValue = false,
	Flag = "Toggle1", 
	Callback = function(Value)
		if Value then
			game:GetService("Workspace").Terrain.Clouds.Density = 0.8009999990463257
			game:GetService("Workspace").Terrain.Clouds.Cover = 0.8009999990463257
			game:GetService("Lighting").Brightness = 1.5
			game:GetService("Lighting").FogColor = Color3.fromRGB(255,255,255)
			game:GetService("Lighting").ClockTime = 16.5
			game:GetService("Lighting").FogEnd = 5000
			game:GetService("Lighting").FogStart = 200
			game:GetService("Lighting").Sky.SkyboxBk = "rbxassetid://10491933248"
			game:GetService("Lighting").Sky.SkyboxDn = "rbxassetid://10491933248"
			game:GetService("Lighting").Sky.SkyboxFt = "rbxassetid://10491933248"
			game:GetService("Lighting").Sky.SkyboxLf = "rbxassetid://10491933248"
			game:GetService("Lighting").Sky.SkyboxRt = "rbxassetid://10491933248"
			game:GetService("Lighting").Sky.SkyboxUp = "rbxassetid://10491933248"
            Rayfield:Notify({
                Title = "Fog enabled",
                Content = "Foggy Map",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
			game:GetService("Workspace").Terrain.Clouds.Density = 0.5709999799728394
			game:GetService("Workspace").Terrain.Clouds.Cover = 0.5709999799728394
			game:GetService("Lighting").Brightness = 2
			game:GetService("Lighting").FogColor = Color3.fromRGB(192,192,192)
			game:GetService("Lighting").ClockTime = 14
			game:GetService("Lighting").FogEnd = 100000
			game:GetService("Lighting").FogStart = 0
			game:GetService("Lighting").Sky.SkyboxBk = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxDn = "rbxassetid://8995686153"
			game:GetService("Lighting").Sky.SkyboxFt = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxLf = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxRt = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxUp = "rbxassetid://8995814929"
            Rayfield:Notify({
                Title = "Fog disabled",
                Content = "Foggy Map",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
	end,
})

local Skyboxes = MapStuff:CreateSection("Change Skybox")

local DaveBoner = MapStuff:CreateToggle({
	Name = "Dave Boner Skybox",
	CurrentValue = false,
	Flag = "Toggle1", 
	Callback = function(Value)
		if Value then
			game:GetService("Lighting").Sky.SkyboxBk = "rbxassetid://120974828567943"
			game:GetService("Lighting").Sky.SkyboxDn = "rbxassetid://120974828567943"
			game:GetService("Lighting").Sky.SkyboxFt = "rbxassetid://120974828567943"
			game:GetService("Lighting").Sky.SkyboxLf = "rbxassetid://120974828567943"
			game:GetService("Lighting").Sky.SkyboxRt = "rbxassetid://120974828567943"
			game:GetService("Lighting").Sky.SkyboxUp = "rbxassetid://120974828567943"
            Rayfield:Notify({
                Title = "Dave Boner lol",
                Content = "- Dave Boner Himself",
                Duration = 6.5,
                Image = 4483362458,
            })
		else
			game:GetService("Lighting").Sky.SkyboxBk = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxDn = "rbxassetid://8995686153"
			game:GetService("Lighting").Sky.SkyboxFt = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxLf = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxRt = "rbxassetid://8995816670"
			game:GetService("Lighting").Sky.SkyboxUp = "rbxassetid://8995814929"
            Rayfield:Notify({
                Title = "Bye bye Boner",
                Content = "- Dave Boner Himself",
                Duration = 6.5,
                Image = 4483362458,
            })
		end
	end,
})

local Tp = Window:CreateTab("Teleportation", 4483362458)

local Spwn = Tp:CreateSection("Spawn Location")

local TpLocation = Tp:CreateDropdown({
	Name = "Spawn Location",
	Options = {"Spawn","Factory","GreenHouse","PinkHouse","BlueHouse","ChineseHouse","PurpleHouse","Barn","SpawnCave","OtherGreenHouse","BigCave","GoodPrison","RuhubsDogAhhPrison","ExtremelyGoodPrison","TrainCave","IslandCave","ChineseRoof","UfoCave","Prison","BlueHouseSlot","SpawnSlot","HauntedSlot","RandomSlot","BeachSlot"},
	CurrentOption = {"Spawn"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Option)
		for _,itm in pairs(Option) do
			SL = tpland[itm]
			idlo = itm
		end
	end,
})

local Telp = Tp:CreateSection("Teleport")

local wm = true

local WhichMap = Tp:CreateDropdown({
	Name = "Spawn Location",
	Options = {"Normal Map","Private Map"},
	CurrentOption = {"Normal Map"},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(Option)
		for _,itm in pairs(Option) do
			if itm == "Normal Map" then
				wm = true
			else
				wm = false
			end
		end
	end,
})

local Config = Window:CreateTab("Config", 4483362458)

local Plr = Config:CreateSection("Players")

local afenabled = true

task.spawn(function()
	while afenabled do
		for _,plr in pairs(game.Players:GetChildren()) do
			if plr.Character and plr ~= game.Players.LocalPlayer then
				for _,prt in pairs(plr.Character:GetChildren()) do
					if prt.ClassName == "Part" then
						prt.CollisionGroup = "PlotPlayers"
						if prt:FindFirstChild("RagdollLimbPart") then
							prt.RagdollLimbPart.CollisionGroup = "PlotPlayers"
						end
					end
				end
			elseif plr.Character and plr == game.Players.LocalPlayer then
				for _,prt in pairs(plr.Character:GetChildren()) do
					if prt.ClassName == "Part" then
						prt.CollisionGroup = "Players"
						if prt:FindFirstChild("RagdollLimbPart") then
							prt.RagdollLimbPart.CollisionGroup = "Players"
						end
					end
				end
			end
		end
		task.wait()
	end
end)

local DaveBoner = Config:CreateToggle({
	Name = "Anti-Fling (I'd keep this on",
	CurrentValue = true,
	Flag = "Toggle1", 
	Callback = function(Value)
		afenabled = Value
		while afenabled do
			for _,plr in pairs(game.Players:GetChildren()) do
				if plr.Character and plr ~= game.Players.LocalPlayer then
					for _,prt in pairs(plr.Character:GetChildren()) do
						if prt.ClassName == "Part" then
							prt.CollisionGroup = "PlotPlayers"
							if prt:FindFirstChild("RagdollLimbPart") then
								prt.RagdollLimbPart.CollisionGroup = "PlotPlayers"
							end
						end
					end
				elseif plr.Character and plr == game.Players.LocalPlayer then
					for _,prt in pairs(plr.Character:GetChildren()) do
						if prt.ClassName == "Part" then
							prt.CollisionGroup = "Players"
							prt.CollisionGroup = "PlotPlayers"
							if prt:FindFirstChild("RagdollLimbPart") then
								prt.RagdollLimbPart.CollisionGroup = "PlotPlayers"
							end
						end
					end
				end
			end
			task.wait()
		end
		for _,plr in pairs(game.Players:GetChildren()) do
			if plr.Character then
				for _,prt in pairs(plr.Character:GetChildren()) do
					if prt.ClassName == "Part" then
						prt.CollisionGroup = "Players"
						if prt:FindFirstChild("RagdollLimbPart") then
							prt.RagdollLimbPart.CollisionGroup = "Players"
						end
					end
				end
			end
		end
	end,
})

local Blob = Config:CreateSection("Blobman Settings")

local Scripts = Window:CreateTab("Scripts", 4483362458)

local IY = Scripts:CreateSection("Infinite Yield")

local IYY = Scripts:CreateButton({
	Name = "Load Infinite Yield",
	Callback = function()
		Rayfield:Notify({
			Title = "Loading Infinite Yield",
			Content = "Load Infinite Yield",
			Duration = 6.5,
			Image = 4483362458,
		})
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end,
})

local Dex = Scripts:CreateSection("Dex")

local Dexx = Scripts:CreateButton({
	Name = "Load Dex",
	Callback = function()
		Rayfield:Notify({
			Title = "Loading Dex",
			Content = "Load Dex",
			Duration = 6.5,
			Image = 4483362458,
		})
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end,
})

local RJ = Scripts:CreateSection("Rejoin")

local RJJ = Scripts:CreateButton({
	Name = "Rejoin",
	Callback = function()
		Rayfield:Notify({
			Title = "Attempting to rejoin...",
			Content = "Rejoin",
			Duration = 6.5,
			Image = 4483362458,
		})
		task.wait(0.5)
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
	end,
})

local KL = Scripts:CreateSection("Print Join Land")

local KLL = Scripts:CreateButton({
	Name = "Print Join Land",
	Callback = function()
		game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(200,200,200)\">(Joinland) Check Console</font>")
		print("-------------------- Join Land --------------------")
		local line = 1
		for _,itm in pairs(joinland) do
			if line % 3 == 1 then
				local herenow = false
				for _,plr in pairs(game.Players:GetChildren()) do
					if plr.UserId == joinland[line] then
						herenow = true
					end
				end
				if not herenow then
					print("(Joinland: Left) "..joinland[line+2].." (@"..joinland[line+1]..") UserID: "..joinland[line])
				end
			end
			line = line + 1
		end
		line = 1
		for _,itm in pairs(joinland) do
			if line % 3 == 1 then
				local herenow = false
				for _,plr in pairs(game.Players:GetChildren()) do
					if plr.UserId == joinland[line] then
						herenow = true
					end
				end
				if herenow then
					print("(Joinland) "..joinland[line+2].." (@"..joinland[line+1]..") UserID: "..joinland[line])
				end
			end
			line = line + 1
		end
		print("---------------- End Of Join Land ----------------")
	end,
})

local RJL = Scripts:CreateSection("Print Kick Land")

RJLL = Scripts:CreateButton({
	Name = "Print Kick Land",
	Callback = function()
		local line = 1
		for _,itm in pairs(kickland) do
			if line % 5 == 1 then
				if kickland[line+4] == true then
					print("(Kickland) "..kickland[line+2].." (@"..kickland[line+1]..") UserID: "..kickland[line].." At Position ("..kickland[line+3]..") By A Player")
					game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">(Kickland) "..kickland[line+2].." (@"..kickland[line+1]..") UserID: "..kickland[line].." At Position ("..kickland[line+3]..") By A Player</font>")
				else
					print("(Kickland) "..kickland[line+2].." (@"..kickland[line+1]..") UserID: "..kickland[line].." At Position ("..kickland[line+3]..")")
					game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255,0,0)\">(Kickland) "..kickland[line+2].." (@"..kickland[line+1]..") UserID: "..kickland[line].." At Position ("..kickland[line+3]..")</font>")
				end
			end
			line = line + 1
		end
	end,
})

DM = Scripts:CreateSection("Destroy Menu")

DMM = Scripts:CreateButton({
	Name = "Destroy BinisJ nooooooooo",
	Callback = function()
		Rayfield:Destroy()
	end,
})

game.TextChatService.TextChannels.RBXSystem:DisplaySystemMessage("<font color=\"rgb(255, 0, 255)\">Welcome to BinisJ Nigga</font>")
})
