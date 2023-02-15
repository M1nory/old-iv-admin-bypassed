-- // URL: https://raw.githubusercontent.com/BloodyBurns/Hexx/main/Libraries/Imports.lua
-- // Loadstring: loadstring(game:HttpGet('https://raw.githubusercontent.com/BloodyBurns/Hexx/main/Libraries/Imports.lua'))();

-- // Local Player
plr = game:GetService('Players').LocalPlayer;

-- // Request
request = syn and syn.request or http and http.request or http_request or request;

-- // Services
Chat = game:GetService('Chat');
plrs = game:GetService('Players');
Core = game:GetService('CoreGui');
Lighting = game:GetService('Lighting');
RunService = game:GetService('RunService');
StarterGui = game:GetService('StarterGui');
TestService = game:GetService('TestService');
StarterPack = game:GetService('StarterPack');
HttpService = game:GetService('HttpService');
AvatarEditor = game:GetService('AvatarEditor');
SoundService = game:GetService('SoundService');
TweenService = game:GetService('TweenService');
StarterPlayer = game:GetService('StarterPlayer');
InputService = game:GetService('UserInputService');
TeleportService = game:GetService('TeleportService');
ReplicatedStorage = game:GetService('ReplicatedStorage');
MarketplaceService = game:GetService('MarketplaceService');
ContextActionService = game:GetService('ContextActionService');

-- // Game Variables
ThemeProvider = Core:FindFirstChild('ThemeProvider');
ChatEvents = ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents');
ChatRemote = ChatEvents and ChatEvents.SayMessageRequest;
MuteRemote = ChatEvents and ChatEvents.MutePlayerRequest;
UnMuteRemote = ChatEvents and ChatEvents.UnMutePlayerRequest;
OnMessageRemote = ChatEvents and ChatEvents.OnMessageDoneFiltering;

-- // RS Events
Stepped = RunService.Stepped;
Heartbeat = RunService.Heartbeat;
RenderStepped = RunService.RenderStepped;

-- // Table Library
find = table.find;
maxn = table.maxn;
pack = table.pack;
sort = table.sort;
clear = table.clear;
concat = table.concat;
insert = table.insert;
remove = table.remove;
foreach = table.foreach;

-- // String Library
rep = string.rep;
toStr = tostring;
toNum = tonumber;
len = string.len;
sub = string.sub;
gsub = string.gsub;
byte = string.byte;
char = string.char;
lower = string.lower;
upper = string.upper;
split = string.split;
match = string.match;
gmatch = string.gmatch;
format = string.format;
reverse = string.reverse;

-- // Math Library
pi = math.pi;
huge = math.huge;
rad = math.rad;
max = math.max;
pow = math.pow;
tan = math.tan;
cos = math.cos;
sin = math.sin;
abs = math.abs;
min = math.min;
log = math.log;
pow = math.pow
sqrt = math.sqrt;
clamp = math.clamp;
floor = math.floor;
mrandom = math.random;

-- // Custom Functions
pfp = function(id)
    return plrs:GetUserThumbnailAsync(id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
end

isType = function(a, b)
    return type(a) == toStr(b);
end

JSON = function(Type, Data)
    if Data and (Type == 'Encode' or Type == 'Decode') then
        return Type == 'Encode' and HttpService:JSONEncode(Data) or HttpService:JSONDecode(Data);
    end
end

isIndexOf = function(Data, Value)
    if isType(Data, 'table') then
        for _, v in next, Data do
            if v == Value then
                return _;
            end
        end
        return nil;
    end
end

isIndexType = function(Data, Value)
    if isType(Data, 'table') then
        for _, v in next, Data do
            if toStr(v) == toStr(Value) then
                return _;
            end
        end
        return nil;
    end
end

GetObjs = function(Asset)
    return game:GetObjects(format('rbxassetid://%d', toNum(Asset)))[1];
end

filter = function(Data, Excluded)
    if isType(Data, 'table') then
        local filtered = {}; do
            for _, v in next, Data do
                if isType(Excluded, 'table') and not find(Excluded, v) or not isType(Excluded, 'table') and v ~= Excluded then
                    insert(filtered, v);
                end
            end
        end
        return filtered;
    end
end

Disconnect = function(Signal, Data)
    if Signal and isType(Signal, 'userdata') then
        Signal:Disconnect();
        Signal = nil;

        if Data and isType(Data, 'table') and isIndexOf(Data, Signal) then
            local Index = isIndexOf(Data, Signal);

            Data[Index]:Disconnect();
            Data[Index] = nil;
            return
        end
    end
end

Randomize = function(Data, Excluded)
    if isType(Data, 'table') then
        local newOutput = {}; do
            for _, v in next, Data do
                if Excluded and filter(Data, Excluded) or true then
                    insert(newOutput, v);
                end
            end
        end
        return newOutput[mrandom(1, maxn(newOutput))];
    end
end

GetPlayers = function()
    return plrs:GetPlayers();
end

GetPlayer = function(str)
    if not str then
        return nil;
    end

    str = lower(toStr(str));
    Check = {
        ['others'] = filter(GetPlayers(), plr),
        ['random'] = Randomize(GetPlayers()),
        ['me'] = plr
    }

    if Check[str] then
        return Check[str];
    end

    for _, v in next, GetPlayers() do
        if match(sub(lower(v.Name), 1, len(str)), str) or match(sub(lower(v.DisplayName), 1, len(str)), str) then
            return v;
        end
    end

    return nil;
end

GetCharacter = function(Player, Limb)
    local Player = Player and GetPlayer(Player) and GetPlayer(Player).Character or nil
    if Player and Limb then
        if Player:FindFirstChild(Limb) then
            Player = Player[Limb];
            return Player;
        end

        return nil;
    end

    return Player;
end

loadAsset = function(dir, url)
    if dir and url and writefile or warn('Exploit not supported!') then
        local Request = pcall(function() game:HttpGet(toStr(url)) end);
        local assetf = getcustomasset or getsynasset;
        local data = format('%s.png', toStr(tick()));
        local path = format('%s\\%s', dir, data);

        if isfolder(dir) or makefolder(dir) and Request and assetf then
            writefile(path, game:HttpGet(toStr(url)));
            return assetf(path), (spawn(function()
                (function()
                    task.wait(0.3);
                    delfile(path);
                end)()
            end));
        end
    end
end

Save = function(Path, Data)
    if writefile then
        writefile(Path, isType(Data, 'table') and JSON('Encode', Data) or Data);
    end
end

Drag = function(Frame, Speed)
    loadstring(game:HttpGet('https://pastebin.com/jBJ8eaAS'))()(Frame, Speed);
end
