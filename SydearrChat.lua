local HttpService=game:GetService("HttpService")local Players=game:GetService("Players")local player=Players.LocalPlayer
local API_URL="https://sydearr-sohbetss-default-rtdb.firebaseio.com/messages.json"
local function createUICorner(p,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r or 8)c.Parent=p return c end
local function createProfileImage(userId,size)local img=Instance.new("ImageButton")img.Size=size or UDim2.new(0,36,0,36)img.BackgroundTransparency=0 img.BackgroundColor3=Color3.fromRGB(70,70,70)img.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=48&height=48&format=png"img.ScaleType=Enum.ScaleType.Fit img.ClipsDescendants=true img.AutoButtonColor=true return img end
local function formatTime(timestamp)local time=os.date("*t",timestamp)return string.format("%02d:%02d",time.hour,time.min)end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="OrionStyleChatGui"
ScreenGui.ResetOnSpawn = false -- Ölünce kapanmasını engeller
ScreenGui.Parent=player:WaitForChild("PlayerGui")
local Frame=Instance.new("Frame")Frame.Size=UDim2.new(0,450,0,370)Frame.Position=UDim2.new(0.5,-225,0.5,-215)Frame.BackgroundColor3=Color3.fromRGB(25,25,25)Frame.BorderSizePixel=0 Frame.Parent=ScreenGui createUICorner(Frame,12)

local function notify(content)local msg=Instance.new("TextLabel")msg.Size=UDim2.new(0,300,0,40)msg.Position=UDim2.new(0.5,-150,0,-50)msg.AnchorPoint=Vector2.new(0.5,0)msg.BackgroundColor3=Color3.fromRGB(0,150,255)msg.TextColor3=Color3.new(1,1,1)msg.Font=Enum.Font.GothamBold msg.TextSize=18 msg.TextWrapped=true msg.TextScaled=false msg.ClipsDescendants=true msg.Text=content msg.Parent=ScreenGui createUICorner(msg,8)msg:TweenPosition(UDim2.new(0.5,-150,0,10),"Out","Quad",0.4,true)task.delay(3,function()msg:TweenPosition(UDim2.new(0.5,-150,0,-50),"In","Quad",0.4,true)task.delay(0.4,function()msg:Destroy()end)end)end

local MinimizeButton=Instance.new("TextButton")MinimizeButton.Size=UDim2.new(0,28,0,28)MinimizeButton.Position=UDim2.new(1,-70,0,7)MinimizeButton.BackgroundColor3=Color3.fromRGB(70,70,70)MinimizeButton.Text="-"MinimizeButton.Font=Enum.Font.GothamBold MinimizeButton.TextSize=20 MinimizeButton.TextColor3=Color3.new(1,1,1)MinimizeButton.AutoButtonColor=false MinimizeButton.Parent=Frame createUICorner(MinimizeButton,6)
local CloseButton=Instance.new("TextButton")CloseButton.Size=UDim2.new(0,28,0,28)CloseButton.Position=UDim2.new(1,-35,0,7)CloseButton.BackgroundColor3=Color3.fromRGB(255,70,70)CloseButton.Text="X"CloseButton.Font=Enum.Font.GothamBold CloseButton.TextSize=18 CloseButton.TextColor3=Color3.new(1,1,1)CloseButton.AutoButtonColor=false CloseButton.Parent=Frame createUICorner(CloseButton,6)
CloseButton.MouseButton1Click:Connect(function()ScreenGui:Destroy()end)

local Title=Instance.new("TextLabel")Title.Size=UDim2.new(1,0,0,40)Title.BackgroundTransparency=1 Title.Text="Sydearr Chat"Title.Font=Enum.Font.GothamBold Title.TextSize=24 Title.TextColor3=Color3.fromRGB(180,180,180)Title.Parent=Frame
local ChatBox=Instance.new("ScrollingFrame")ChatBox.Size=UDim2.new(1,-20,1,-100)ChatBox.Position=UDim2.new(0,10,0,50)ChatBox.BackgroundColor3=Color3.fromRGB(35,35,35)ChatBox.BorderSizePixel=0 ChatBox.CanvasSize=UDim2.new(0,0,0,0)ChatBox.ScrollBarThickness=8 ChatBox.AutomaticCanvasSize=Enum.AutomaticSize.Y ChatBox.Parent=Frame createUICorner(ChatBox,10)
local UIList=Instance.new("UIListLayout")UIList.Parent=ChatBox UIList.SortOrder=Enum.SortOrder.LayoutOrder UIList.Padding=UDim.new(0,8)
local UIPadding=Instance.new("UIPadding")UIPadding.PaddingTop=UDim.new(0,10)UIPadding.PaddingBottom=UDim.new(0,10)UIPadding.PaddingLeft=UDim.new(0,10)UIPadding.PaddingRight=UDim.new(0,10)UIPadding.Parent=ChatBox

local InputFrame=Instance.new("Frame")InputFrame.Size=UDim2.new(1,-20,0,40)InputFrame.Position=UDim2.new(0,10,1,-45)InputFrame.BackgroundTransparency=1 InputFrame.Parent=Frame
local UIListLayoutInput=Instance.new("UIListLayout")UIListLayoutInput.Parent=InputFrame UIListLayoutInput.FillDirection=Enum.FillDirection.Horizontal UIListLayoutInput.HorizontalAlignment=Enum.HorizontalAlignment.Center UIListLayoutInput.VerticalAlignment=Enum.VerticalAlignment.Center UIListLayoutInput.Padding=UDim.new(0,10)

local TextBox=Instance.new("TextBox")TextBox.Size=UDim2.new(0.78,0,1,0)TextBox.BackgroundColor3=Color3.fromRGB(50,50,50)TextBox.TextColor3=Color3.new(1,1,1)TextBox.PlaceholderText="Bir mesaj gönderin"TextBox.ClearTextOnFocus=true TextBox.Font=Enum.Font.Gotham TextBox.TextSize=20 TextBox.TextWrapped=true TextBox.Text=""TextBox.Parent=InputFrame createUICorner(TextBox,10)
local SendButton=Instance.new("TextButton")SendButton.Size=UDim2.new(0.22,0,1,0)SendButton.BackgroundColor3=Color3.fromRGB(0,150,255)SendButton.TextColor3=Color3.new(1,1,1)SendButton.Text=">"SendButton.Font=Enum.Font.GothamBold SendButton.TextSize=20 SendButton.Parent=InputFrame createUICorner(SendButton,10)

local function httpRequest(args)if syn and syn.request then return syn.request(args)elseif http_request then return http_request(args)elseif request then return request(args)else local ok,res if args.Method=="POST" then ok,res=pcall(function()return HttpService:PostAsync(args.Url,args.Body,Enum.HttpContentType.ApplicationJson)end)elseif args.Method=="DELETE" then ok,res=pcall(function()return HttpService:RequestAsync(args)end)else ok,res=pcall(function()return HttpService:GetAsync(args.Url)end)end if ok then return {Body=res} else return nil,res end end end

local function sendMessage(text)if not text or text=="" then return end text=text:sub(1,200)local data={username=player.Name,userId=player.UserId,message=text,timestamp=os.time()}local json=HttpService:JSONEncode(data)local res,err=httpRequest({Url=API_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=json})if not res then warn("Mesaj gönderilemedi:",err)end end

local function createMessageLabel(msgData)
    local container=Instance.new("Frame")container.BackgroundColor3=Color3.fromRGB(45,45,45)container.BorderSizePixel=0 container.AutomaticSize=Enum.AutomaticSize.Y container.Size=UDim2.new(1,0,0,50)createUICorner(container,10)
    local profileImg=createProfileImage(msgData.userId)profileImg.Position=UDim2.new(0,8,0,7)profileImg.Parent=container
    local nameLabel=Instance.new("TextLabel")nameLabel.Size=UDim2.new(0.5,0,0,18)nameLabel.Position=UDim2.new(0,52,0,6)nameLabel.BackgroundTransparency=1 nameLabel.TextColor3=Color3.fromRGB(0,170,255)nameLabel.Font=Enum.Font.GothamBold nameLabel.TextSize=18 nameLabel.TextXAlignment=Enum.TextXAlignment.Left nameLabel.Text=msgData.username nameLabel.Parent=container
    local timeLabel=Instance.new("TextLabel")timeLabel.Size=UDim2.new(0.3,0,0,18)timeLabel.Position=UDim2.new(0.55,0,0,6)timeLabel.BackgroundTransparency=1 timeLabel.TextColor3=Color3.fromRGB(150,150,150)timeLabel.Font=Enum.Font.Gotham timeLabel.TextSize=14 timeLabel.TextXAlignment=Enum.TextXAlignment.Right timeLabel.Text=formatTime(msgData.timestamp)timeLabel.Parent=container
    local msgLabel=Instance.new("TextLabel")msgLabel.Size=UDim2.new(1,-90,0,0)msgLabel.Position=UDim2.new(0,52,0,22)msgLabel.BackgroundTransparency=1 msgLabel.TextColor3=Color3.fromRGB(230,230,230)msgLabel.Font=Enum.Font.Gotham msgLabel.TextSize=18 msgLabel.TextWrapped=true msgLabel.TextXAlignment=Enum.TextXAlignment.Left msgLabel.AutomaticSize=Enum.AutomaticSize.Y msgLabel.Text=msgData.message msgLabel.Parent=container
    
    local copyBtn=Instance.new("ImageButton")
    copyBtn.Size=UDim2.new(0,30,0,30)
    copyBtn.Position=UDim2.new(1,-40,1,-40)
    copyBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
    copyBtn.Image = "rbxassetid://10825594179"
    copyBtn.ScaleType=Enum.ScaleType.Fit
    copyBtn.Parent=container
    createUICorner(copyBtn,6)
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(msgData.message)
        if msgData.userId~=player.UserId then
            notify("("..msgData.username..") kullanıcısının mesajını kopyaladın")
        end
    end)
    return container
end

local existingMessages,lastDisplayedTimestamps,lastMessageUserId={},{}
local MinimizedIcon
local function updateMessages()
    local res,err=httpRequest({Url=API_URL,Method="GET"})if not res then return end
    local ok,data=pcall(function()return HttpService:JSONDecode(res.Body)end)
    if not ok or type(data)~="table" then return end
    local newMessages={}
    for _,msg in pairs(data)do
        if type(msg)=="table"and msg.timestamp and msg.username and msg.message and msg.userId then
            table.insert(newMessages,msg)
        end
    end
    table.sort(newMessages,function(a,b)return a.timestamp<b.timestamp end)
    local isAtBottom=ChatBox.CanvasPosition.Y>=ChatBox.CanvasSize.Y.Offset-ChatBox.AbsoluteWindowSize.Y-5
    for _,msg in ipairs(newMessages)do
        if not existingMessages[msg.timestamp]then
            local last=lastDisplayedTimestamps[msg.userId]
            if not last or os.difftime(msg.timestamp,last)>=1 then
                local label=createMessageLabel(msg)
                label.LayoutOrder=#existingMessages+1
                label.Parent=ChatBox
                existingMessages[msg.timestamp]=true
                lastDisplayedTimestamps[msg.userId]=msg.timestamp
                lastMessageUserId=msg.userId
            end
        end
    end
    task.defer(function()
        ChatBox.CanvasSize=UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)
        if isAtBottom then ChatBox.CanvasPosition=Vector2.new(0,ChatBox.CanvasSize.Y.Offset)end
    end)
end

SendButton.MouseButton1Click:Connect(function()
    local txt=TextBox.Text:gsub("^%s*(.-)%s*$","%1")
    if txt~=""then sendMessage(txt)TextBox.Text=""end
end)

local function createMinimizedIcon(userId)
    if MinimizedIcon then MinimizedIcon:Destroy()end
    MinimizedIcon=createProfileImage(userId,UDim2.new(0,40,0,40))
    MinimizedIcon.Position=UDim2.new(0,50,1,-230)
    MinimizedIcon.Parent=ScreenGui
    MinimizedIcon.BackgroundColor3=Color3.fromRGB(70,70,70)
    createUICorner(MinimizedIcon,10)
    MinimizedIcon.MouseButton1Click:Connect(function()
        MinimizedIcon:Destroy()Frame.Visible=true
    end)
end

MinimizeButton.MouseButton1Click:Connect(function()
    if lastMessageUserId then
        Frame.Visible=false
        createMinimizedIcon(lastMessageUserId)
    end
end)

task.spawn(function()while true do task.wait(3)updateMessages()end end)
updateMessages()
