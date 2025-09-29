local Kavo = {}

local tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local httpservice = game:GetService("HttpService")

local Utility = {}
local Objects = {}
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    
    -- stolen from wally or kiriot, kek
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    local info = TweenInfo.new(duration, ...)
    local tween = tweenservice:Create(obj, info, properties)
    tween:Play()
    return tween
end

local function rgb(r, g, b)
    return Color3.fromRGB(r, g, b)
end

local themes = {
    SchemeColor = rgb(74, 99, 135),
    Background = rgb(36, 37, 43),
    Header = rgb(28, 29, 34),
    TextColor = rgb(255, 255, 255),
    ElementColor = rgb(32, 32, 38)
}

local themeStyles = {
    DarkTheme = {
        SchemeColor = rgb(64, 64, 64),
        Background = rgb(0, 0, 0),
        Header = rgb(0, 0, 0),
        TextColor = rgb(255, 255, 255),
        ElementColor = rgb(20, 20, 20)
    },
    LightTheme = {
        SchemeColor = rgb(150, 150, 150),
        Background = rgb(255, 255, 255),
        Header = rgb(200, 200, 200),
        TextColor = rgb(0, 0, 0),
        ElementColor = rgb(224, 224, 224)
    },
    BloodTheme = {
        SchemeColor = rgb(227, 27, 27),
        Background = rgb(10, 10, 10),
        Header = rgb(5, 5, 5),
        TextColor = rgb(255, 255, 255),
        ElementColor = rgb(20, 20, 20)
    },
    GrapeTheme = {
        SchemeColor = rgb(166, 71, 214),
        Background = rgb(64, 50, 71),
        Header = rgb(36, 28, 41),
        TextColor = rgb(255, 255, 255),
        ElementColor = rgb(74, 58, 84)
    },
    Ocean = {
        SchemeColor = rgb(86, 76, 251),
        Background = rgb(26, 32, 58),
        Header = rgb(38, 45, 71),
        TextColor = rgb(200, 200, 200),
        ElementColor = rgb(38, 45, 71)
    },
    Midnight = {
        SchemeColor = rgb(26, 189, 158),
        Background = rgb(44, 62, 82),
        Header = rgb(57, 81, 105),
        TextColor = rgb(255, 255, 255),
        ElementColor = rgb(52, 74, 95)
    },
    Sentinel = {
        SchemeColor = rgb(230, 35, 69),
        Background = rgb(32, 32, 32),
        Header = rgb(24, 24, 24),
        TextColor = rgb(119, 209, 138),
        ElementColor = rgb(24, 24, 24)
    },
    Synapse = {
        SchemeColor = rgb(46, 48, 43),
        Background = rgb(13, 15, 12),
        Header = rgb(36, 38, 35),
        TextColor = rgb(152, 99, 53),
        ElementColor = rgb(24, 24, 24)
    },
    Serpent = {
        SchemeColor = rgb(0, 166, 58),
        Background = rgb(31, 41, 43),
        Header = rgb(22, 29, 31),
        TextColor = rgb(255, 255, 255),
        ElementColor = rgb(22, 29, 31)
    }
}

local oldTheme = ""
local SettingsT = SettingsT or {}
local Settings = {}

local Name = "KavoConfig.JSON"

pcall(function()
    if not isfile(Name) then
        writefile(Name, httpservice:JSONEncode(SettingsT))
    end
    Settings = httpservice:JSONDecode(readfile(Name))
end)

local LibName = ("%d%d%d"):format(math.random(1, 100), math.random(1, 50), math.random(1, 100))

function Kavo:ToggleUI()
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then
        gui.Enabled = not gui.Enabled
    end
end

function Kavo.CreateLib(kavName, themeList)
    if type(themeList) == "string" then
        themeList = themeStyles[themeList] or themes
    elseif type(themeList) ~= "table" then
        themeList = themes
    end

    for key, default in pairs(themes) do
        if themeList[key] == nil then
            themeList[key] = default
        end
    end

    kavName = kavName or "Library"
    local selectedTab
    Kavo[kavName] = true

    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainHeader = Instance.new("Frame")
    local headerCover = Instance.new("UICorner")
    local coverup = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local close = Instance.new("ImageButton")
    local MainSide = Instance.new("Frame")
    local sideCorner = Instance.new("UICorner")
    local coverup_2 = Instance.new("Frame")
    local tabFrames = Instance.new("Frame")
    local tabListing = Instance.new("UIListLayout")
    local pages = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")
    local blurFrame = Instance.new("Frame")

    Kavo:DraggingEnabled(MainHeader, Main)

    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.BorderSizePixel = 0
    blurFrame.Position = UDim2.new(-0.0222222228, 0, -0.0371747203, 0)
    blurFrame.Size = UDim2.new(0, 376, 0, 289)
    blurFrame.ZIndex = 999

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = LibName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.336503863, 0, 0.275485456, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)

    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    Objects[MainHeader] = "BackgroundColor3"
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Name = "headerCover"
    headerCover.Parent = MainHeader

    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    Objects[coverup] = "BackgroundColor3"
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.758620679, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)

    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.0171428565, 0, 0.344827592, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.Gotham
    title.RichText = true
    title.Text = kavName
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.949999988, 0, 0.137999997, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.ZIndex = 2
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.MouseButton1Click:Connect(function()
        game.TweenService:Create(close, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageTransparency = 1
        }):Play()
        task.wait()
        game.TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }):Play()
        task.wait(1)
        ScreenGui:Destroy()
    end)

    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    Objects[MainSide] = "Header"
    MainSide.Position = UDim2.new(-7.4505806e-09, 0, 0.0911949649, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)

    sideCorner.CornerRadius = UDim.new(0, 4)
    sideCorner.Name = "sideCorner"
    sideCorner.Parent = MainSide

    coverup_2.Name = "coverup"
    coverup_2.Parent = MainSide
    coverup_2.BackgroundColor3 = themeList.Header
    Objects[coverup_2] = "Header"
    coverup_2.BorderSizePixel = 0
    coverup_2.Position = UDim2.new(0.949939311, 0, 0, 0)
    coverup_2.Size = UDim2.new(0, 7, 0, 289)

    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.0438990258, 0, -0.00066378375, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder

    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.BorderSizePixel = 0
    pages.Position = UDim2.new(0.299047589, 0, 0.122641519, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    Pages.Name = "Pages"
    Pages.Parent = pages

    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.Position = UDim2.new(0.299047619, 0, 0.874213815, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    coroutine.wrap(function()
        while task.wait() do
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            MainSide.BackgroundColor3 = themeList.Header
            coverup_2.BackgroundColor3 = themeList.Header
            coverup.BackgroundColor3 = themeList.Header
        end
    end)()

    function Kavo:ChangeColor(prope, color)
        if themeList[prope] ~= nil then
            themeList[prope] = color
        end
    end
end

    
local Tabs = {}
local first = true

function Tabs:NewTab(tabName)
    tabName = tabName or "Tab"

    local tabButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local page = Instance.new("ScrollingFrame")
    local pageListing = Instance.new("UIListLayout")

    local function UpdateSize()
        local cS = pageListing.AbsoluteContentSize
        Utility:TweenObject(page, {
            CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
        }, 0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    end

    local function ApplyTextColor(btn, active)
        local isWhite = themeList.SchemeColor == Color3.fromRGB(255,255,255)
        local isBlack = themeList.SchemeColor == Color3.fromRGB(0,0,0)
        if isWhite then
            Utility:TweenObject(btn, {TextColor3 = active and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)}, 0.2)
        elseif isBlack then
            Utility:TweenObject(btn, {TextColor3 = active and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)}, 0.2)
        end
    end

    page.Name = "Page"
    page.Parent = Pages
    page.Active = true
    page.BackgroundColor3 = themeList.Background
    page.BorderSizePixel = 0
    page.Position = UDim2.new(0, 0, -0.0037, 0)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 5
    page.Visible = false
    page.ScrollBarImageColor3 = Color3.fromRGB(
        themeList.SchemeColor.r * 255 - 16,
        themeList.SchemeColor.g * 255 - 15,
        themeList.SchemeColor.b * 255 - 28
    )

    pageListing.Name = "pageListing"
    pageListing.Parent = page
    pageListing.SortOrder = Enum.SortOrder.LayoutOrder
    pageListing.Padding = UDim.new(0, 5)

    tabButton.Name = tabName.."TabButton"
    tabButton.Parent = tabFrames
    tabButton.BackgroundColor3 = themeList.SchemeColor
    Objects[tabButton] = "SchemeColor"
    tabButton.Size = UDim2.new(0, 135, 0, 28)
    tabButton.AutoButtonColor = false
    tabButton.Font = Enum.Font.Gotham
    tabButton.Text = tabName
    tabButton.TextColor3 = themeList.TextColor
    Objects[tabButton] = "TextColor3"
    tabButton.TextSize = 14
    tabButton.BackgroundTransparency = 1

    if first then
        first = false
        page.Visible = true
        tabButton.BackgroundTransparency = 0
        UpdateSize()
    end

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = tabButton
    table.insert(Tabs, tabName)

    page.ChildAdded:Connect(UpdateSize)
    page.ChildRemoved:Connect(UpdateSize)

    tabButton.MouseButton1Click:Connect(function()
        UpdateSize()

        for _, v in ipairs(Pages:GetChildren()) do
            v.Visible = false
        end
        page.Visible = true

        for _, v in ipairs(tabFrames:GetChildren()) do
            if v:IsA("TextButton") then
                ApplyTextColor(v, false)
                Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
            end
        end

        ApplyTextColor(tabButton, true)
        Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
    end)

    coroutine.wrap(function()
        while task.wait() do
            page.BackgroundColor3 = themeList.Background
            page.ScrollBarImageColor3 = Color3.fromRGB(
                themeList.SchemeColor.r * 255 - 16,
                themeList.SchemeColor.g * 255 - 15,
                themeList.SchemeColor.b * 255 - 28
            )
            tabButton.TextColor3 = themeList.TextColor
            tabButton.BackgroundColor3 = themeList.SchemeColor
        end
    end)()

    return page
end

function Sections:NewSection(secName, hidden)
    secName = secName or "Section"
    hidden = hidden or false

    local sectionFunctions = {}
    local modules = {}

    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = "sectionFrame"
    sectionFrame.Parent = page
    sectionFrame.BackgroundColor3 = themeList.Background
    sectionFrame.BorderSizePixel = 0

    local sectionlistoknvm = Instance.new("UIListLayout")
    sectionlistoknvm.Name = "sectionlistoknvm"
    sectionlistoknvm.Parent = sectionFrame
    sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
    sectionlistoknvm.Padding = UDim.new(0, 5)

    local sectionHead = Instance.new("Frame")
    sectionHead.Name = "sectionHead"
    sectionHead.Parent = sectionFrame
    sectionHead.BackgroundColor3 = themeList.SchemeColor
    sectionHead.Visible = not hidden
    sectionHead.Size = UDim2.new(0, 352, 0, 33)
    Objects[sectionHead] = "BackgroundColor3"

    local sHeadCorner = Instance.new("UICorner")
    sHeadCorner.CornerRadius = UDim.new(0, 4)
    sHeadCorner.Parent = sectionHead

    local sectionName = Instance.new("TextLabel")
    sectionName.Name = "sectionName"
    sectionName.Parent = sectionHead
    sectionName.BackgroundTransparency = 1
    sectionName.Position = UDim2.new(0.02, 0, 0, 0)
    sectionName.Size = UDim2.new(0.98, 0, 1, 0)
    sectionName.Font = Enum.Font.Gotham
    sectionName.Text = secName
    sectionName.RichText = true
    sectionName.TextColor3 = themeList.TextColor
    sectionName.TextSize = 14
    sectionName.TextXAlignment = Enum.TextXAlignment.Left
    Objects[sectionName] = "TextColor3"

    local sectionInners = Instance.new("Frame")
    sectionInners.Name = "sectionInners"
    sectionInners.Parent = sectionFrame
    sectionInners.BackgroundTransparency = 1
    sectionInners.Position = UDim2.new(0, 0, 0.19, 0)

    local sectionElListing = Instance.new("UIListLayout")
    sectionElListing.Name = "sectionElListing"
    sectionElListing.Parent = sectionInners
    sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
    sectionElListing.Padding = UDim.new(0, 3)

    local function updateSectionFrame()
        sectionInners.Size = UDim2.new(1, 0, 0, sectionElListing.AbsoluteContentSize.Y)
        sectionFrame.Size = UDim2.new(0, 352, 0, sectionlistoknvm.AbsoluteContentSize.Y)
    end

    sectionElListing:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionFrame)
    updateSectionFrame()
    UpdateSize()

    coroutine.wrap(function()
        while task.wait() do
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionName.TextColor3 = themeList.TextColor
        end
    end)()

    return sectionFunctions
end

local Elements = {}

function Elements:NewButton(bname, tipINf, callback)
    showLogo = showLogo or true
    local ButtonFunction = {}
    tipINf = tipINf or "Tip: Clicking this nothing will happen!"
    bname = bname or "Click Me!"
    callback = callback or function() end

    local buttonElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local btnInfo = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local touch = Instance.new("ImageLabel")
    local Sample = Instance.new("ImageLabel")

    table.insert(modules, bname)

    buttonElement.Name = bname
    buttonElement.Parent = sectionInners
    buttonElement.BackgroundColor3 = themeList.ElementColor
    buttonElement.ClipsDescendants = true
    buttonElement.Size = UDim2.new(0, 352, 0, 33)
    buttonElement.AutoButtonColor = false
    buttonElement.Font = Enum.Font.SourceSans
    buttonElement.Text = ""
    buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
    buttonElement.TextSize = 14
    Objects[buttonElement] = "BackgroundColor3"

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = buttonElement

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = buttonElement
    viewInfo.BackgroundTransparency = 1
    viewInfo.LayoutOrder = 9
    viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.ZIndex = 2
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    Objects[viewInfo] = "ImageColor3"
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    Sample.Name = "Sample"
    Sample.Parent = buttonElement
    Sample.BackgroundTransparency = 1
    Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
    Sample.ImageColor3 = themeList.SchemeColor
    Objects[Sample] = "ImageColor3"
    Sample.ImageTransparency = 0.6

    local moreInfo = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")

    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.Text = "  " .. tipINf
    moreInfo.RichText = true
    moreInfo.TextColor3 = themeList.TextColor
    Objects[moreInfo] = "TextColor3"
    moreInfo.TextSize = 14
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left
    Objects[moreInfo] = "BackgroundColor3"

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = moreInfo

    touch.Name = "touch"
    touch.Parent = buttonElement
    touch.BackgroundTransparency = 1
    touch.Position = UDim2.new(0.02, 0, 0.18, 0)
    touch.Size = UDim2.new(0, 21, 0, 21)
    touch.Image = "rbxassetid://3926305904"
    touch.ImageColor3 = themeList.SchemeColor
    Objects[touch] = "SchemeColor"
    touch.ImageRectOffset = Vector2.new(84, 204)
    touch.ImageRectSize = Vector2.new(36, 36)

    btnInfo.Name = "btnInfo"
    btnInfo.Parent = buttonElement
    btnInfo.BackgroundTransparency = 1
    btnInfo.Position = UDim2.new(0.097, 0, 0.273, 0)
    btnInfo.Size = UDim2.new(0, 314, 0, 14)
    btnInfo.Font = Enum.Font.GothamSemibold
    btnInfo.Text = bname
    btnInfo.RichText = true
    btnInfo.TextColor3 = themeList.TextColor
    Objects[btnInfo] = "TextColor3"
    btnInfo.TextSize = 14
    btnInfo.TextXAlignment = Enum.TextXAlignment.Left

    if themeList.SchemeColor == Color3.fromRGB(255, 255, 255) then
        Utility:TweenObject(moreInfo, { TextColor3 = Color3.fromRGB(0, 0, 0) }, 0.2)
    elseif themeList.SchemeColor == Color3.fromRGB(0, 0, 0) then
        Utility:TweenObject(moreInfo, { TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.2)
    end

    updateSectionFrame()
    UpdateSize()

    local ms = game.Players.LocalPlayer:GetMouse()
    local btn = buttonElement
    local sample = Sample

    btn.MouseButton1Click:Connect(function()
        if not focusing then
            callback()
            local c = sample:Clone()
            c.Parent = btn
            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
            c.Position = UDim2.new(0, x, 0, y)
            local len, size = 0.35, nil
            size = (btn.AbsoluteSize.X >= btn.AbsoluteSize.Y) and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
            for i = 1, 10 do
                c.ImageTransparency = c.ImageTransparency + 0.05
                wait(len / 12)
            end
            c:Destroy()
        else
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, { Position = UDim2.new(0, 0, 2, 0) }, 0.2)
                focusing = false
            end
            Utility:TweenObject(blurFrame, { BackgroundTransparency = 1 }, 0.2)
        end
    end)

    local hovering = false
    btn.MouseEnter:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
            }):Play()
            hovering = true
        end
    end)

    btn.MouseLeave:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                BackgroundColor3 = themeList.ElementColor
            }):Play()
            hovering = false
        end
    end)

    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe = true
            focusing = true
            for _, v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, { Position = UDim2.new(0, 0, 2, 0) }, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, { Position = UDim2.new(0, 0, 0, 0) }, 0.2)
            Utility:TweenObject(blurFrame, { BackgroundTransparency = 0.5 }, 0.2)
            Utility:TweenObject(btn, { BackgroundColor3 = themeList.ElementColor }, 0.2)
            wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, { Position = UDim2.new(0, 0, 2, 0) }, 0.2)
            Utility:TweenObject(blurFrame, { BackgroundTransparency = 1 }, 0.2)
            viewDe = false
        end
    end)

    coroutine.wrap(function()
        while wait() do
            if not hovering then
                buttonElement.BackgroundColor3 = themeList.ElementColor
            end
            viewInfo.ImageColor3 = themeList.SchemeColor
            Sample.ImageColor3 = themeList.SchemeColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
            moreInfo.TextColor3 = themeList.TextColor
            touch.ImageColor3 = themeList.SchemeColor
            btnInfo.TextColor3 = themeList.TextColor
        end
    end)()

    function ButtonFunction:UpdateButton(newTitle)
        btnInfo.Text = newTitle
    end

    return ButtonFunction
end

function Elements:NewToggle(tname, nTip, callback)
    local TogFunction = {}
    tname = tname or "Toggle"
    nTip = nTip or "Prints Current Toggle State"
    callback = callback or function() end
    local toggled = false
    table.insert(SettingsT, tname)

    local toggleElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local toggleDisabled = Instance.new("ImageLabel")
    local toggleEnabled = Instance.new("ImageLabel")
    local togName = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local Sample = Instance.new("ImageLabel")

    toggleElement.Name = "toggleElement"
    toggleElement.Parent = sectionInners
    toggleElement.BackgroundColor3 = themeList.ElementColor
    toggleElement.ClipsDescendants = true
    toggleElement.Size = UDim2.new(0, 352, 0, 33)
    toggleElement.AutoButtonColor = false
    toggleElement.Text = ""

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = toggleElement

    toggleDisabled.Name = "toggleDisabled"
    toggleDisabled.Parent = toggleElement
    toggleDisabled.BackgroundTransparency = 1
    toggleDisabled.Position = UDim2.new(0.02, 0, 0.18, 0)
    toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
    toggleDisabled.Image = "rbxassetid://3926309567"
    toggleDisabled.ImageColor3 = themeList.SchemeColor
    toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
    toggleDisabled.ImageRectSize = Vector2.new(48, 48)

    toggleEnabled.Name = "toggleEnabled"
    toggleEnabled.Parent = toggleElement
    toggleEnabled.BackgroundTransparency = 1
    toggleEnabled.Position = UDim2.new(0.02, 0, 0.18, 0)
    toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
    toggleEnabled.Image = "rbxassetid://3926309567"
    toggleEnabled.ImageColor3 = themeList.SchemeColor
    toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
    toggleEnabled.ImageRectSize = Vector2.new(48, 48)
    toggleEnabled.ImageTransparency = 1

    togName.Name = "togName"
    togName.Parent = toggleElement
    togName.BackgroundTransparency = 1
    togName.Position = UDim2.new(0.097, 0, 0.273, 0)
    togName.Size = UDim2.new(0, 288, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = tname
    togName.RichText = true
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14
    togName.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = toggleElement
    viewInfo.BackgroundTransparency = 1
    viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.ZIndex = 2
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    Sample.Name = "Sample"
    Sample.Parent = toggleElement
    Sample.BackgroundTransparency = 1
    Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
    Sample.ImageColor3 = themeList.SchemeColor
    Sample.ImageTransparency = 0.6

    local moreInfo = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.Text = "  " .. nTip
    moreInfo.RichText = true
    moreInfo.TextColor3 = themeList.TextColor
    moreInfo.TextSize = 14
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = moreInfo

    local ms = game.Players.LocalPlayer:GetMouse()
    local btn, sample, img = toggleElement, Sample, toggleEnabled

    updateSectionFrame()
    UpdateSize()

    btn.MouseButton1Click:Connect(function()
        if not focusing then
            if not toggled then
                game.TweenService:Create(img, TweenInfo.new(0.11, Enum.EasingStyle.Linear), {ImageTransparency = 0}):Play()
            else
                game.TweenService:Create(img, TweenInfo.new(0.11, Enum.EasingStyle.Linear), {ImageTransparency = 1}):Play()
            end
            local c = sample:Clone()
            c.Parent = btn
            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
            c.Position = UDim2.new(0, x, 0, y)
            local len, size = 0.35, btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and btn.AbsoluteSize.X * 1.5 or btn.AbsoluteSize.Y * 1.5
            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", len, true)
            for i = 1, 10 do
                c.ImageTransparency = c.ImageTransparency + 0.05
                task.wait(len / 12)
            end
            c:Destroy()
            toggled = not toggled
            pcall(callback, toggled)
        else
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                focusing = false
            end
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
        end
    end)

    local hovering = false
    btn.MouseEnter:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
            }):Play()
            hovering = true
        end
    end)

    btn.MouseLeave:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                BackgroundColor3 = themeList.ElementColor
            }):Play()
            hovering = false
        end
    end)

    coroutine.wrap(function()
        while task.wait() do
            if not hovering then
                toggleElement.BackgroundColor3 = themeList.ElementColor
            end
            toggleDisabled.ImageColor3 = themeList.SchemeColor
            toggleEnabled.ImageColor3 = themeList.SchemeColor
            togName.TextColor3 = themeList.TextColor
            viewInfo.ImageColor3 = themeList.SchemeColor
            Sample.ImageColor3 = themeList.SchemeColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
            moreInfo.TextColor3 = themeList.TextColor
        end
    end)()

    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe = true
            focusing = true
            for _, v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
            task.wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            task.wait()
            viewDe = false
        end
    end)

    function TogFunction:UpdateToggle(newText, isTogOn)
        if newText then togName.Text = newText end
        isTogOn = isTogOn or false
        toggled = isTogOn
        local transparency = isTogOn and 0 or 1
        game.TweenService:Create(img, TweenInfo.new(0.11, Enum.EasingStyle.Linear), {
            ImageTransparency = transparency
        }):Play()
        pcall(callback, toggled)
    end

    return TogFunction
end

function Elements:NewTextBox(tname, tTip, callback)
    tname = tname or "Textbox"
    tTip = tTip or "Gets a value of Textbox"
    callback = callback or function() end

    local textboxElement = Instance.new("TextButton")
    textboxElement.Name = "textboxElement"
    textboxElement.Parent = sectionInners
    textboxElement.BackgroundColor3 = themeList.ElementColor
    textboxElement.ClipsDescendants = true
    textboxElement.Size = UDim2.new(0, 352, 0, 33)
    textboxElement.AutoButtonColor = false
    textboxElement.Font = Enum.Font.SourceSans
    textboxElement.Text = ""
    textboxElement.TextColor3 = Color3.new(0, 0, 0)
    textboxElement.TextSize = 14

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = textboxElement

    local viewInfo = Instance.new("ImageButton")
    viewInfo.Name = "viewInfo"
    viewInfo.Parent = textboxElement
    viewInfo.BackgroundTransparency = 1
    viewInfo.LayoutOrder = 9
    viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.ZIndex = 2
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    local write = Instance.new("ImageLabel")
    write.Name = "write"
    write.Parent = textboxElement
    write.BackgroundTransparency = 1
    write.Position = UDim2.new(0.02, 0, 0.18, 0)
    write.Size = UDim2.new(0, 21, 0, 21)
    write.Image = "rbxassetid://3926305904"
    write.ImageColor3 = themeList.SchemeColor
    write.ImageRectOffset = Vector2.new(324, 604)
    write.ImageRectSize = Vector2.new(36, 36)

    local TextBox = Instance.new("TextBox")
    TextBox.Parent = textboxElement
    TextBox.BackgroundColor3 = Color3.fromRGB(
        themeList.ElementColor.R * 255 - 6,
        themeList.ElementColor.G * 255 - 6,
        themeList.ElementColor.B * 255 - 7
    )
    TextBox.BorderSizePixel = 0
    TextBox.ClipsDescendants = true
    TextBox.Position = UDim2.new(0.489, 0, 0.212, 0)
    TextBox.Size = UDim2.new(0, 150, 0, 18)
    TextBox.ZIndex = 99
    TextBox.ClearTextOnFocus = false
    TextBox.Font = Enum.Font.Gotham
    TextBox.PlaceholderColor3 = Color3.fromRGB(
        themeList.SchemeColor.R * 255 - 19,
        themeList.SchemeColor.G * 255 - 26,
        themeList.SchemeColor.B * 255 - 35
    )
    TextBox.PlaceholderText = "Type here!"
    TextBox.Text = ""
    TextBox.TextColor3 = themeList.SchemeColor
    TextBox.TextSize = 12

    local UICorner_2 = Instance.new("UICorner")
    UICorner_2.CornerRadius = UDim.new(0, 4)
    UICorner_2.Parent = TextBox

    local togName = Instance.new("TextLabel")
    togName.Name = "togName"
    togName.Parent = textboxElement
    togName.BackgroundTransparency = 1
    togName.Position = UDim2.new(0.097, 0, 0.273, 0)
    togName.Size = UDim2.new(0, 138, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = tname
    togName.RichText = true
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14
    togName.TextXAlignment = Enum.TextXAlignment.Left

    local moreInfo = Instance.new("TextLabel")
    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(
        themeList.SchemeColor.R * 255 - 14,
        themeList.SchemeColor.G * 255 - 17,
        themeList.SchemeColor.B * 255 - 13
    )
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.RichText = true
    moreInfo.Text = "  " .. tTip
    moreInfo.TextColor3 = themeList.TextColor
    moreInfo.TextSize = 14
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left

    local UICorner_3 = Instance.new("UICorner")
    UICorner_3.CornerRadius = UDim.new(0, 4)
    UICorner_3.Parent = moreInfo

    updateSectionFrame()
    UpdateSize()

    local btn, hovering = textboxElement, false

    btn.MouseButton1Click:Connect(function()
        if focusing then
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            end
            focusing = false
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
        end
    end)

    btn.MouseEnter:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(
                    themeList.ElementColor.R * 255 + 8,
                    themeList.ElementColor.G * 255 + 9,
                    themeList.ElementColor.B * 255 + 10
                )
            }):Play()
            hovering = true
        end
    end)

    btn.MouseLeave:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1), {
                BackgroundColor3 = themeList.ElementColor
            }):Play()
            hovering = false
        end
    end)

    TextBox.FocusLost:Connect(function(enterPressed)
        if focusing then
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            end
            focusing = false
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
        end
        if enterPressed then
            callback(TextBox.Text)
            task.wait(0.18)
            TextBox.Text = ""
        end
    end)

    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe, focusing = true, true
            for _, v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
            task.wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            viewDe = false
        end
    end)

    coroutine.wrap(function()
        while task.wait() do
            if not hovering then
                textboxElement.BackgroundColor3 = themeList.ElementColor
            end
            TextBox.BackgroundColor3 = Color3.fromRGB(
                themeList.ElementColor.R * 255 - 6,
                themeList.ElementColor.G * 255 - 6,
                themeList.ElementColor.B * 255 - 7
            )
            viewInfo.ImageColor3 = themeList.SchemeColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(
                themeList.SchemeColor.R * 255 - 14,
                themeList.SchemeColor.G * 255 - 17,
                themeList.SchemeColor.B * 255 - 13
            )
            moreInfo.TextColor3 = themeList.TextColor
            write.ImageColor3 = themeList.SchemeColor
            togName.TextColor3 = themeList.TextColor
            TextBox.PlaceholderColor3 = Color3.fromRGB(
                themeList.SchemeColor.R * 255 - 19,
                themeList.SchemeColor.G * 255 - 26,
                themeList.SchemeColor.B * 255 - 35
            )
            TextBox.TextColor3 = themeList.SchemeColor
        end
    end)()
end

function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
    slidInf = slidInf or "Slider"
    slidTip = slidTip or "Slider tip here"
    maxvalue = maxvalue or 500
    minvalue = minvalue or 16
    callback = callback or function() end

    local sliderElement = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local togName = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local sliderBtn = Instance.new("TextButton")
    local UICorner_2 = Instance.new("UICorner")
    local sliderDrag = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local write = Instance.new("ImageLabel")
    local val = Instance.new("TextLabel")

    sliderElement.Name = "sliderElement"
    sliderElement.Parent = sectionInners
    sliderElement.BackgroundColor3 = themeList.ElementColor
    sliderElement.ClipsDescendants = true
    sliderElement.Size = UDim2.new(0, 352, 0, 33)
    sliderElement.AutoButtonColor = false
    sliderElement.Text = ""

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = sliderElement

    togName.Name = "togName"
    togName.Parent = sliderElement
    togName.BackgroundTransparency = 1
    togName.Position = UDim2.new(0.096, 0, 0.273, 0)
    togName.Size = UDim2.new(0, 138, 0, 14)
    togName.Font = Enum.Font.GothamSemibold
    togName.Text = slidInf
    togName.RichText = true
    togName.TextColor3 = themeList.TextColor
    togName.TextSize = 14
    togName.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = sliderElement
    viewInfo.BackgroundTransparency = 1
    viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.ZIndex = 2
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageColor3 = themeList.SchemeColor
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)

    sliderBtn.Name = "sliderBtn"
    sliderBtn.Parent = sliderElement
    sliderBtn.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 5, themeList.ElementColor.g * 255 + 5, themeList.ElementColor.b * 255 + 5)
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Position = UDim2.new(0.489, 0, 0.394, 0)
    sliderBtn.Size = UDim2.new(0, 149, 0, 6)
    sliderBtn.AutoButtonColor = false
    sliderBtn.Text = ""

    UICorner_2.Parent = sliderBtn

    sliderDrag.Name = "sliderDrag"
    sliderDrag.Parent = sliderBtn
    sliderDrag.BackgroundColor3 = themeList.SchemeColor
    sliderDrag.BorderSizePixel = 0
    sliderDrag.Size = UDim2.new(0, 0, 1, 0)

    UICorner_3.Parent = sliderDrag

    write.Name = "write"
    write.Parent = sliderElement
    write.BackgroundTransparency = 1
    write.Position = UDim2.new(0.02, 0, 0.18, 0)
    write.Size = UDim2.new(0, 21, 0, 21)
    write.Image = "rbxassetid://3926307971"
    write.ImageColor3 = themeList.SchemeColor
    write.ImageRectOffset = Vector2.new(404, 164)
    write.ImageRectSize = Vector2.new(36, 36)

    val.Name = "val"
    val.Parent = sliderElement
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(0.352, 0, 0.273, 0)
    val.Size = UDim2.new(0, 41, 0, 14)
    val.Font = Enum.Font.GothamSemibold
    val.Text = tostring(minvalue)
    val.TextColor3 = themeList.TextColor
    val.TextSize = 14
    val.TextTransparency = 1
    val.TextXAlignment = Enum.TextXAlignment.Right

    local moreInfo = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    moreInfo.Name = "TipMore"
    moreInfo.Parent = infoContainer
    moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
    moreInfo.Position = UDim2.new(0, 0, 2, 0)
    moreInfo.Size = UDim2.new(0, 353, 0, 33)
    moreInfo.ZIndex = 9
    moreInfo.Font = Enum.Font.GothamSemibold
    moreInfo.Text = "  " .. slidTip
    moreInfo.TextColor3 = themeList.TextColor
    moreInfo.TextSize = 14
    moreInfo.RichText = true
    moreInfo.TextXAlignment = Enum.TextXAlignment.Left
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = moreInfo

    updateSectionFrame()
    UpdateSize()

    local mouse = game.Players.LocalPlayer:GetMouse()
    local uis = game:GetService("UserInputService")
    local btn = sliderElement
    local infBtn = viewInfo
    local hovering = false

    btn.MouseEnter:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
            }):Play()
            hovering = true
        end
    end)

    btn.MouseLeave:Connect(function()
        if not focusing then
            game.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                BackgroundColor3 = themeList.ElementColor
            }):Play()
            hovering = false
        end
    end)

    coroutine.wrap(function()
        while task.wait() do
            if not hovering then
                sliderElement.BackgroundColor3 = themeList.ElementColor
            end
            moreInfo.TextColor3 = themeList.TextColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
            val.TextColor3 = themeList.TextColor
            write.ImageColor3 = themeList.SchemeColor
            togName.TextColor3 = themeList.TextColor
            viewInfo.ImageColor3 = themeList.SchemeColor
            sliderBtn.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 5, themeList.ElementColor.g * 255 + 5, themeList.ElementColor.b * 255 + 5)
            sliderDrag.BackgroundColor3 = themeList.SchemeColor
        end
    end)()

    local function setValue(x)
        local size = math.clamp(x - sliderBtn.AbsolutePosition.X, 0, sliderBtn.AbsoluteSize.X)
        sliderDrag.Size = UDim2.new(0, size, 1, 0)
        local valNum = math.floor(((maxvalue - minvalue) / sliderBtn.AbsoluteSize.X) * size + minvalue)
        val.Text = tostring(valNum)
        pcall(callback, valNum)
    end

    local function inputBegan(input)
        if not focusing and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            game.TweenService:Create(val, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
            setValue(input.Position.X)
            local moveConn, releaseConn
            moveConn = uis.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    setValue(i.Position.X)
                end
            end)
            releaseConn = uis.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    game.TweenService:Create(val, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
                    moveConn:Disconnect()
                    releaseConn:Disconnect()
                end
            end)
        else
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                focusing = false
            end
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
        end
    end

    sliderBtn.InputBegan:Connect(inputBegan)

    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe, focusing = true, true
            for _, v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then
                    Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
            task.wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            viewDe = false
        end
    end)
end

function Elements:NewDropdown(dropname, dropinf, list, callback)
    dropname = dropname or "Dropdown"
    list = list or {}
    dropinf = dropinf or "Dropdown info"
    callback = callback or function() end   

    local DropFunction, opened = {}, false
    local DropYSize, ms = 33, game.Players.LocalPlayer:GetMouse()

    local dropFrame = Instance.new("Frame")
    local dropOpen = Instance.new("TextButton")
    local listImg = Instance.new("ImageLabel")
    local itemTextbox = Instance.new("TextLabel")
    local viewInfo = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local UIListLayout = Instance.new("UIListLayout")
    local Sample = Instance.new("ImageLabel")

    dropFrame.Name = "dropFrame"
    dropFrame.Parent = sectionInners
    dropFrame.BackgroundColor3 = themeList.Background
    dropFrame.Size = UDim2.new(0, 352, 0, 33)
    dropFrame.ClipsDescendants = true

    dropOpen.Name = "dropOpen"
    dropOpen.Parent = dropFrame
    dropOpen.BackgroundColor3 = themeList.ElementColor
    dropOpen.Size = UDim2.new(0, 352, 0, 33)
    dropOpen.AutoButtonColor = false
    dropOpen.Text = ""
    dropOpen.ClipsDescendants = true

    listImg.Name = "listImg"
    listImg.Parent = dropOpen
    listImg.BackgroundTransparency = 1
    listImg.Position = UDim2.new(0.02, 0, 0.18, 0)
    listImg.Size = UDim2.new(0, 21, 0, 21)
    listImg.Image = "rbxassetid://3926305904"
    listImg.ImageRectOffset = Vector2.new(644, 364)
    listImg.ImageRectSize = Vector2.new(36, 36)
    listImg.ImageColor3 = themeList.SchemeColor

    itemTextbox.Name = "itemTextbox"
    itemTextbox.Parent = dropOpen
    itemTextbox.BackgroundTransparency = 1
    itemTextbox.Position = UDim2.new(0.097, 0, 0.273, 0)
    itemTextbox.Size = UDim2.new(0, 138, 0, 14)
    itemTextbox.Font = Enum.Font.GothamSemibold
    itemTextbox.Text = dropname
    itemTextbox.TextColor3 = themeList.TextColor
    itemTextbox.TextSize = 14
    itemTextbox.TextXAlignment = Enum.TextXAlignment.Left

    viewInfo.Name = "viewInfo"
    viewInfo.Parent = dropOpen
    viewInfo.BackgroundTransparency = 1
    viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
    viewInfo.Size = UDim2.new(0, 23, 0, 23)
    viewInfo.ZIndex = 2
    viewInfo.Image = "rbxassetid://3926305904"
    viewInfo.ImageRectOffset = Vector2.new(764, 764)
    viewInfo.ImageRectSize = Vector2.new(36, 36)
    viewInfo.ImageColor3 = themeList.SchemeColor

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = dropOpen

    Sample.Name = "Sample"
    Sample.Parent = dropOpen
    Sample.BackgroundTransparency = 1
    Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
    Sample.ImageColor3 = themeList.SchemeColor
    Sample.ImageTransparency = 0.6

    UIListLayout.Parent = dropFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)

    local function rippleEffect(btn, sample)
        local c = sample:Clone()
        c.Parent = btn
        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
        c.Position = UDim2.new(0, x, 0, y)
        local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.5
        local len = 0.35
        c:TweenSizeAndPosition(
            UDim2.new(0, size, 0, size),
            UDim2.new(0.5, -size / 2, 0.5, -size / 2),
            "Out", "Quad", len, true
        )
        for _ = 1, 10 do
            c.ImageTransparency += 0.05
            task.wait(len / 12)
        end
        c:Destroy()
    end

    local function applyHoverEffect(button)
        local hovering = false
        button.MouseEnter:Connect(function()
            if not focusing then
                game.TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(
                        themeList.ElementColor.R * 255 + 8,
                        themeList.ElementColor.G * 255 + 9,
                        themeList.ElementColor.B * 255 + 10
                    )
                }):Play()
                hovering = true
            end
        end)
        button.MouseLeave:Connect(function()
            if not focusing then
                game.TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundColor3 = themeList.ElementColor
                }):Play()
                hovering = false
            end
        end)
        coroutine.wrap(function()
            while task.wait() do
                if not hovering then button.BackgroundColor3 = themeList.ElementColor end
            end
        end)()
    end

    local function createOption(text)
        local optionSelect = Instance.new("TextButton")
        optionSelect.Name = "optionSelect"
        optionSelect.Parent = dropFrame
        optionSelect.BackgroundColor3 = themeList.ElementColor
        optionSelect.Size = UDim2.new(0, 352, 0, 33)
        optionSelect.AutoButtonColor = false
        optionSelect.Font = Enum.Font.GothamSemibold
        optionSelect.Text = "  " .. text
        optionSelect.TextXAlignment = Enum.TextXAlignment.Left
        optionSelect.TextColor3 = themeList.TextColor
        optionSelect.TextSize = 14
        optionSelect.ClipsDescendants = true

        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = optionSelect

        local Sample1 = Sample:Clone()
        Sample1.Parent = optionSelect

        optionSelect.MouseButton1Click:Connect(function()
            if not focusing then
                opened = false
                callback(text)
                itemTextbox.Text = text
                dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                task.wait(0.1)
                updateSectionFrame()
                UpdateSize()
                rippleEffect(optionSelect, Sample1)
            else
                for _, v in next, infoContainer:GetChildren() do
                    Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                end
                focusing = false
                Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            end
        end)

        applyHoverEffect(optionSelect)
    end

    dropOpen.MouseButton1Click:Connect(function()
        if focusing then
            for _, v in next, infoContainer:GetChildren() do
                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
            end
            focusing = false
            return Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
        end
        opened = not opened
        dropFrame:TweenSize(
            opened and UDim2.new(0, 352, 0, UIListLayout.AbsoluteContentSize.Y)
            or UDim2.new(0, 352, 0, 33),
            "InOut", "Linear", 0.08
        )
        task.wait(0.1)
        updateSectionFrame()
        UpdateSize()
        rippleEffect(dropOpen, Sample)
    end)

    for _, v in next, list do
        createOption(v)
    end

    function DropFunction:Refresh(newList)
        for _, v in next, dropFrame:GetChildren() do
            if v.Name == "optionSelect" then v:Destroy() end
        end
        for _, v in next, (newList or {}) do
            createOption(v)
        end
        if opened then
            dropFrame:TweenSize(UDim2.new(0, 352, 0, UIListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.08)
        else
            dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
        end
        task.wait(0.1)
        updateSectionFrame()
        UpdateSize()
    end

    applyHoverEffect(dropOpen)
    return DropFunction
end

function Elements:NewKeybind(keytext, keyinf, first, callback)
    keytext = keytext or "KeybindText"
    keyinf = keyinf or "KeybindInfo"
    callback = callback or function() end
    local oldKey, focusing, viewDe, oHover = first.Name, false, false, false

    local keybindElement = Instance.new("TextButton")
    keybindElement.Name = "keybindElement"
    keybindElement.Parent = sectionInners
    keybindElement.BackgroundColor3 = themeList.ElementColor
    keybindElement.Size = UDim2.new(0, 352, 0, 33)
    keybindElement.ClipsDescendants, keybindElement.AutoButtonColor = true, false
    keybindElement.Font, keybindElement.Text, keybindElement.TextSize = Enum.Font.SourceSans, "", 14
    Instance.new("UICorner", keybindElement).CornerRadius = UDim.new(0, 4)

    local togName = Instance.new("TextLabel")
    togName.Name, togName.Parent, togName.BackgroundTransparency = "togName", keybindElement, 1
    togName.Position, togName.Size = UDim2.new(0.097,0,0.27,0), UDim2.new(0,222,0,14)
    togName.Font, togName.RichText, togName.TextSize, togName.TextXAlignment = Enum.Font.GothamSemibold, true, 14, Enum.TextXAlignment.Left
    togName.Text, togName.TextColor3 = keytext, themeList.TextColor

    local togName_2 = Instance.new("TextLabel")
    togName_2.Name, togName_2.Parent, togName_2.BackgroundTransparency = "togName", keybindElement, 1
    togName_2.Position, togName_2.Size = UDim2.new(0.727,0,0.27,0), UDim2.new(0,70,0,14)
    togName_2.Font, togName_2.TextSize, togName_2.TextXAlignment = Enum.Font.GothamSemibold, 14, Enum.TextXAlignment.Right
    togName_2.Text, togName_2.TextColor3 = oldKey, themeList.SchemeColor

    local touch = Instance.new("ImageLabel")
    touch.Name, touch.Parent, touch.BackgroundTransparency = "touch", keybindElement, 1
    touch.Position, touch.Size = UDim2.new(0.02,0,0.18,0), UDim2.new(0,21,0,21)
    touch.Image, touch.ImageRectOffset, touch.ImageRectSize = "rbxassetid://3926305904", Vector2.new(364,284), Vector2.new(36,36)
    touch.ImageColor3 = themeList.SchemeColor

    local viewInfo = Instance.new("ImageButton")
    viewInfo.Name, viewInfo.Parent, viewInfo.BackgroundTransparency = "viewInfo", keybindElement, 1
    viewInfo.Position, viewInfo.Size, viewInfo.ZIndex = UDim2.new(0.93,0,0.15,0), UDim2.new(0,23,0,23), 2
    viewInfo.Image, viewInfo.ImageRectOffset, viewInfo.ImageRectSize = "rbxassetid://3926305904", Vector2.new(764,764), Vector2.new(36,36)
    viewInfo.ImageColor3 = themeList.SchemeColor

    local Sample = Instance.new("ImageLabel")
    Sample.Name, Sample.Parent, Sample.BackgroundTransparency = "Sample", keybindElement, 1
    Sample.Image, Sample.ImageColor3, Sample.ImageTransparency = "http://www.roblox.com/asset/?id=4560909609", themeList.SchemeColor, 0.6

    local moreInfo = Instance.new("TextLabel")
    moreInfo.Name, moreInfo.Parent = "TipMore", infoContainer
    moreInfo.Position, moreInfo.Size = UDim2.new(0,0,2,0), UDim2.new(0,353,0,33)
    moreInfo.Font, moreInfo.RichText, moreInfo.TextSize, moreInfo.TextXAlignment = Enum.Font.GothamSemibold, true, 14, Enum.TextXAlignment.Left
    moreInfo.ZIndex, moreInfo.Text = 9, "  " .. keyinf
    moreInfo.TextColor3, moreInfo.BackgroundColor3 = themeList.TextColor, Color3.fromRGB(themeList.SchemeColor.r*255-14, themeList.SchemeColor.g*255-17, themeList.SchemeColor.b*255-13)
    Instance.new("UICorner", moreInfo).CornerRadius = UDim.new(0, 4)

    keybindElement.MouseButton1Click:Connect(function()
        if not focusing then
            togName_2.Text = ". . ."
            local a = game:GetService("UserInputService").InputBegan:Wait()
            if a.KeyCode.Name ~= "Unknown" then
                togName_2.Text, oldKey = a.KeyCode.Name, a.KeyCode.Name
            end
        end
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode.Name == oldKey then
            callback()
        end
    end)

    viewInfo.MouseButton1Click:Connect(function()
        if not viewDe then
            viewDe, focusing = true, true
            for _,v in next, infoContainer:GetChildren() do
                if v ~= moreInfo then Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2) end
            end
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
            task.wait(1.5)
            focusing = false
            Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
            viewDe = false
        end
    end)

    keybindElement.MouseEnter:Connect(function()
        if not focusing then
            game.TweenService:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor + Color3.fromRGB(8,9,10)}):Play()
            oHover = true
        end
    end)
    keybindElement.MouseLeave:Connect(function()
        if not focusing then
            game.TweenService:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
            oHover = false
        end
    end)

    coroutine.wrap(function()
        while task.wait() do
            if not oHover then keybindElement.BackgroundColor3 = themeList.ElementColor end
            togName_2.TextColor3, touch.ImageColor3, viewInfo.ImageColor3 = themeList.SchemeColor, themeList.SchemeColor, themeList.SchemeColor
            togName.TextColor3, Sample.ImageColor3, moreInfo.TextColor3 = themeList.TextColor, themeList.SchemeColor, themeList.TextColor
            moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r*255-14, themeList.SchemeColor.g*255-17, themeList.SchemeColor.b*255-13)
        end
    end)()

    updateSectionFrame()
    UpdateSize()
end
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                colText = colText or "ColorPicker"
                callback = callback or function() end
                defcolor = defcolor or Color3.fromRGB(1,1,1)
                local h, s, v = Color3.toHSV(defcolor)
                local ms = game.Players.LocalPlayer:GetMouse()
                local colorOpened = false
                local colorElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local colorHeader = Instance.new("Frame")
                local UICorner_2 = Instance.new("UICorner")
                local touch = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local colorCurrent = Instance.new("Frame")
                local UICorner_3 = Instance.new("UICorner")
                local UIListLayout = Instance.new("UIListLayout")
                local colorInners = Instance.new("Frame")
                local UICorner_4 = Instance.new("UICorner")
                local rgb = Instance.new("ImageButton")
                local UICorner_5 = Instance.new("UICorner")
                local rbgcircle = Instance.new("ImageLabel")
                local darkness = Instance.new("ImageButton")
                local UICorner_6 = Instance.new("UICorner")
                local darkcircle = Instance.new("ImageLabel")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local onrainbow = Instance.new("TextButton")
                local togName_2 = Instance.new("TextLabel")

                --Properties:
                local Sample = Instance.new("ImageLabel")
                Sample.Name = "Sample"
                Sample.Parent = colorHeader
                Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Sample.BackgroundTransparency = 1.000
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.600

                local btn = colorHeader
                local sample = Sample

                colorElement.Name = "colorElement"
                colorElement.Parent = sectionInners
                colorElement.BackgroundColor3 = themeList.ElementColor
                colorElement.BackgroundTransparency = 1.000
                colorElement.ClipsDescendants = true
                colorElement.Position = UDim2.new(0, 0, 0.566834569, 0)
                colorElement.Size = UDim2.new(0, 352, 0, 33)
                colorElement.AutoButtonColor = false
                colorElement.Font = Enum.Font.SourceSans
                colorElement.Text = ""
                colorElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                colorElement.TextSize = 14.000
                colorElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        if colorOpened then
                            colorOpened = false
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                            wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local len, size = 0.35, nil
                            if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                                size = (btn.AbsoluteSize.X * 1.5)
                            else
                                size = (btn.AbsoluteSize.Y * 1.5)
                            end
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                wait(len / 12)
                            end
                            c:Destroy()
                        else
                            colorOpened = true
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 141), "InOut", "Linear", 0.08, true)
                            wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local len, size = 0.35, nil
                            if btn.AbsoluteSize.X >= btn.AbsoluteSize.Y then
                                size = (btn.AbsoluteSize.X * 1.5)
                            else
                                size = (btn.AbsoluteSize.Y * 1.5)
                            end
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                wait(len / 12)
                            end
                            c:Destroy()
                        end
                    else
                        for i,v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = colorElement

                colorHeader.Name = "colorHeader"
                colorHeader.Parent = colorElement
                colorHeader.BackgroundColor3 = themeList.ElementColor
                colorHeader.Size = UDim2.new(0, 352, 0, 33)
                colorHeader.ClipsDescendants = true

                UICorner_2.CornerRadius = UDim.new(0, 4)
                UICorner_2.Parent = colorHeader
                
                touch.Name = "touch"
                touch.Parent = colorHeader
                touch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                touch.BackgroundTransparency = 1.000
                touch.BorderColor3 = Color3.fromRGB(27, 42, 53)
                touch.Position = UDim2.new(0.0199999996, 0, 0.180000007, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(44, 964)
                touch.ImageRectSize = Vector2.new(36, 36)

                togName.Name = "togName"
                togName.Parent = colorHeader
                togName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                togName.BackgroundTransparency = 1.000
                togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = colText
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14.000
                togName.RichText = true
                togName.TextXAlignment = Enum.TextXAlignment.Left

                local moreInfo = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..colInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.RichText = true
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = moreInfo

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = colorHeader
                viewInfo.BackgroundTransparency = 1.000
                viewInfo.LayoutOrder = 9
                viewInfo.Position = UDim2.new(0.930000007, 0, 0.151999995, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for i,v in next, infoContainer:GetChildren() do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,0,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(colorElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0,0,2,0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        wait(0)
                        viewDe = false
                    end
                end)   

                colorCurrent.Name = "colorCurrent"
                colorCurrent.Parent = colorHeader
                colorCurrent.BackgroundColor3 = defcolor
                colorCurrent.Position = UDim2.new(0.792613626, 0, 0.212121218, 0)
                colorCurrent.Size = UDim2.new(0, 42, 0, 18)

                UICorner_3.CornerRadius = UDim.new(0, 4)
                UICorner_3.Parent = colorCurrent

                UIListLayout.Parent = colorElement
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 3)

                colorInners.Name = "colorInners"
                colorInners.Parent = colorElement
                colorInners.BackgroundColor3 = themeList.ElementColor
                colorInners.Position = UDim2.new(0, 0, 0.255319148, 0)
                colorInners.Size = UDim2.new(0, 352, 0, 105)

                UICorner_4.CornerRadius = UDim.new(0, 4)
                UICorner_4.Parent = colorInners

                rgb.Name = "rgb"
                rgb.Parent = colorInners
                rgb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                rgb.BackgroundTransparency = 1.000
                rgb.Position = UDim2.new(0.0198863633, 0, 0.0476190485, 0)
                rgb.Size = UDim2.new(0, 211, 0, 93)
                rgb.Image = "http://www.roblox.com/asset/?id=6523286724"

                UICorner_5.CornerRadius = UDim.new(0, 4)
                UICorner_5.Parent = rgb

                rbgcircle.Name = "rbgcircle"
                rbgcircle.Parent = rgb
                rbgcircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                rbgcircle.BackgroundTransparency = 1.000
                rbgcircle.Size = UDim2.new(0, 14, 0, 14)
                rbgcircle.Image = "rbxassetid://3926309567"
                rbgcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                rbgcircle.ImageRectOffset = Vector2.new(628, 420)
                rbgcircle.ImageRectSize = Vector2.new(48, 48)

                darkness.Name = "darkness"
                darkness.Parent = colorInners
                darkness.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                darkness.BackgroundTransparency = 1.000
                darkness.Position = UDim2.new(0.636363626, 0, 0.0476190485, 0)
                darkness.Size = UDim2.new(0, 18, 0, 93)
                darkness.Image = "http://www.roblox.com/asset/?id=6523291212"

                UICorner_6.CornerRadius = UDim.new(0, 4)
                UICorner_6.Parent = darkness

                darkcircle.Name = "darkcircle"
                darkcircle.Parent = darkness
                darkcircle.AnchorPoint = Vector2.new(0.5, 0)
                darkcircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                darkcircle.BackgroundTransparency = 1.000
                darkcircle.Size = UDim2.new(0, 14, 0, 14)
                darkcircle.Image = "rbxassetid://3926309567"
                darkcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                darkcircle.ImageRectOffset = Vector2.new(628, 420)
                darkcircle.ImageRectSize = Vector2.new(48, 48)

                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = colorInners
                toggleDisabled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleDisabled.BackgroundTransparency = 1.000
                toggleDisabled.Position = UDim2.new(0.704659104, 0, 0.0657142699, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)

                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = colorInners
                toggleEnabled.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleEnabled.BackgroundTransparency = 1.000
                toggleEnabled.Position = UDim2.new(0.704999983, 0, 0.0659999996, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1.000

                onrainbow.Name = "onrainbow"
                onrainbow.Parent = toggleEnabled
                onrainbow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                onrainbow.BackgroundTransparency = 1.000
                onrainbow.Position = UDim2.new(2.90643607e-06, 0, 0, 0)
                onrainbow.Size = UDim2.new(1, 0, 1, 0)
                onrainbow.Font = Enum.Font.SourceSans
                onrainbow.Text = ""
                onrainbow.TextColor3 = Color3.fromRGB(0, 0, 0)
                onrainbow.TextSize = 14.000

                togName_2.Name = "togName"
                togName_2.Parent = colorInners
                togName_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                togName_2.BackgroundTransparency = 1.000
                togName_2.Position = UDim2.new(0.779999971, 0, 0.100000001, 0)
                togName_2.Size = UDim2.new(0, 278, 0, 14)
                togName_2.Font = Enum.Font.GothamSemibold
                togName_2.Text = "Rainbow"
                togName_2.TextColor3 = themeList.TextColor
                togName_2.TextSize = 14.000
                togName_2.TextXAlignment = Enum.TextXAlignment.Left

                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
                end 
                if themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.2)
                end 
                local hovering = false

                colorElement.MouseEnter:Connect(function()
                    if not focusing then
                        game.TweenService:Create(colorElement, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.r * 255 + 8, themeList.ElementColor.g * 255 + 9, themeList.ElementColor.b * 255 + 10)
                        }):Play()
                        hovering = true
                    end 
                end)
                colorElement.MouseLeave:Connect(function()
                    if not focusing then
                        game.TweenService:Create(colorElement, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                            BackgroundColor3 = themeList.ElementColor
                        }):Play()
                        hovering = false
                    end
                end)        

                if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
                end 
                if themeList.SchemeColor == Color3.fromRGB(0,0,0) then
                    Utility:TweenObject(moreInfo, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.2)
                end 
                coroutine.wrap(function()
                    while wait() do
                        if not hovering then
                            colorElement.BackgroundColor3 = themeList.ElementColor
                        end
                        touch.ImageColor3 = themeList.SchemeColor
                        colorHeader.BackgroundColor3 = themeList.ElementColor
                        togName.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        colorInners.BackgroundColor3 = themeList.ElementColor
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        togName_2.TextColor3 = themeList.TextColor
                        Sample.ImageColor3 = themeList.SchemeColor
                    end
                end)()
                updateSectionFrame()
                UpdateSize()
                local plr = game.Players.LocalPlayer
                local mouse = plr:GetMouse()
                local uis = game:GetService('UserInputService')
                local rs = game:GetService("RunService")
                local colorpicker = false
                local darknesss = false
                local dark = false
                local rgb = rgb    
                local dark = darkness    
                local cursor = rbgcircle
                local cursor2 = darkcircle
                local color = {1,1,1}
                local rainbow = false
                local rainbowconnection
                local counter = 0
                --
                local function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
                counter = 0
                local function mouseLocation()
                    return plr:GetMouse()
                end
                local function cp()
                    if colorpicker then
                        local ml = mouseLocation()
                        local x,y = ml.X - rgb.AbsolutePosition.X,ml.Y - rgb.AbsolutePosition.Y
                        local maxX,maxY = rgb.AbsoluteSize.X,rgb.AbsoluteSize.Y
                        if x<0 then x=0 end
                        if x>maxX then x=maxX end
                        if y<0 then y=0 end
                        if y>maxY then y=maxY end
                        x = x/maxX
                        y = y/maxY
                        local cx = cursor.AbsoluteSize.X/2
                        local cy = cursor.AbsoluteSize.Y/2
                        cursor.Position = UDim2.new(x,-cx,y,-cy)
                        color = {1-x,1-y,color[3]}
                        local realcolor = Color3.fromHSV(color[1],color[2],color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                    if darknesss then
                        local ml = mouseLocation()
                        local y = ml.Y - dark.AbsolutePosition.Y
                        local maxY = dark.AbsoluteSize.Y
                        if y<0 then y=0 end
                        if y>maxY then y=maxY end
                        y = y/maxY
                        local cy = cursor2.AbsoluteSize.Y/2
                        cursor2.Position = UDim2.new(0.5,0,y,-cy)
                        cursor2.ImageColor3 = Color3.fromHSV(0,0,y)
                        color = {color[1],color[2],1-y}
                        local realcolor = Color3.fromHSV(color[1],color[2],color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                end

                local function setcolor(tbl)
                    local cx = cursor.AbsoluteSize.X/2
                    local cy = cursor.AbsoluteSize.Y/2
                    color = {tbl[1],tbl[2],tbl[3]}
                    cursor.Position = UDim2.new(color[1],-cx,color[2]-1,-cy)
                    cursor2.Position = UDim2.new(0.5,0,color[3]-1,-cy)
                    local realcolor = Color3.fromHSV(color[1],color[2],color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                end
                local function setrgbcolor(tbl)
                    local cx = cursor.AbsoluteSize.X/2
                    local cy = cursor.AbsoluteSize.Y/2
                    color = {tbl[1],tbl[2],color[3]}
                    cursor.Position = UDim2.new(color[1],-cx,color[2]-1,-cy)
                    local realcolor = Color3.fromHSV(color[1],color[2],color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                    callback(realcolor)
                end
                local function togglerainbow()
                    if rainbow then
                        game.TweenService:Create(toggleEnabled, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageTransparency = 1
                        }):Play()
                        rainbow = false
                        rainbowconnection:Disconnect()
                    else
                        game.TweenService:Create(toggleEnabled, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageTransparency = 0
                        }):Play()
                        rainbow = true
                        rainbowconnection = rs.RenderStepped:Connect(function()
                            setrgbcolor({zigzag(counter),1,1})
                            counter = counter + 0.01
                        end)
                    end
                end

                onrainbow.MouseButton1Click:Connect(togglerainbow)
                --
                mouse.Move:connect(cp)
                rgb.MouseButton1Down:connect(function()colorpicker=true end)
                dark.MouseButton1Down:connect(function()darknesss=true end)
                uis.InputEnded:Connect(function(input)
                    if input.UserInputType.Name == 'MouseButton1' then
                        if darknesss then darknesss = false end
                        if colorpicker then colorpicker = false end
                    end
                end)
                setcolor({h,s,v})
            end
            
            function Elements:NewLabel(title)
            	local labelFunctions = {}
            	local label = Instance.new("TextLabel")
            	local UICorner = Instance.new("UICorner")
            	label.Name = "label"
            	label.Parent = sectionInners
            	label.BackgroundColor3 = themeList.SchemeColor
            	label.BorderSizePixel = 0
				label.ClipsDescendants = true
            	label.Text = title
           		label.Size = UDim2.new(0, 352, 0, 33)
	            label.Font = Enum.Font.Gotham
	            label.Text = "  "..title
	            label.RichText = true
	            label.TextColor3 = themeList.TextColor
	            Objects[label] = "TextColor3"
	            label.TextSize = 14.000
	            label.TextXAlignment = Enum.TextXAlignment.Left
	            
	           	UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = label
            	
	            if themeList.SchemeColor == Color3.fromRGB(255,255,255) then
	                Utility:TweenObject(label, {TextColor3 = Color3.fromRGB(0,0,0)}, 0.2)
	            end 
	            if themeList.SchemeColor == Color3.fromRGB(0,0,0) then
	                Utility:TweenObject(label, {TextColor3 = Color3.fromRGB(255,255,255)}, 0.2)
	            end 

		        coroutine.wrap(function()
		            while wait() do
		                label.BackgroundColor3 = themeList.SchemeColor
		                label.TextColor3 = themeList.TextColor
		            end
		        end)()
                updateSectionFrame()
                UpdateSize()
                function labelFunctions:UpdateLabel(newText)
                	if label.Text ~= "  "..newText then
                		label.Text = "  "..newText
                	end
                end	
                return labelFunctions
            end	
            return Elements
        end
        return Sections
    end  
    return Tabs
end
return Kavo
