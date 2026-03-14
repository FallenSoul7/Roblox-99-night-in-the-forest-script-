local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-------------------------------------------------
-- STATES
-------------------------------------------------

local playerESP=false
local animalESP=false
local chestESP=false

-------------------------------------------------
-- DROP ITEM
-------------------------------------------------

local function dropToPlayer(obj)

	local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local pos=root.CFrame+Vector3.new(math.random(-3,3),6,math.random(-3,3))

	if obj:IsA("Model") and obj.PrimaryPart then
		obj:SetPrimaryPartCFrame(pos)
	else
		local p=obj:FindFirstChildWhichIsA("BasePart")
		if p then
			p.CFrame=pos
		end
	end

end

-------------------------------------------------
-- ESP
-------------------------------------------------

local function addESP(obj,color,tag)

	if obj:FindFirstChild(tag) then return end

	local h=Instance.new("Highlight")
	h.Name=tag
	h.FillColor=color
	h.OutlineColor=color
	h.FillTransparency=0.4
	h.Parent=obj

end

-------------------------------------------------
-- PLAYER ESP
-------------------------------------------------

local function updatePlayers()

	for _,p in pairs(Players:GetPlayers()) do

		if p~=player and p.Character then

			if playerESP then
				addESP(p.Character,Color3.fromRGB(0,255,0),"P_ESP")
			else
				local h=p.Character:FindFirstChild("P_ESP")
				if h then h:Destroy() end
			end

		end

	end

end

-------------------------------------------------
-- ANIMAL ESP
-------------------------------------------------

local function updateAnimals()

	for _,v in pairs(workspace:GetDescendants()) do

		local hum=v:FindFirstChildOfClass("Humanoid")

		if hum and not Players:GetPlayerFromCharacter(v) then

			if animalESP then
				addESP(v,Color3.fromRGB(255,0,0),"A_ESP")
			else
				local h=v:FindFirstChild("A_ESP")
				if h then h:Destroy() end
			end

		end

	end

end

-------------------------------------------------
-- CHEST ESP
-------------------------------------------------

local function updateChests()

	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("Model") and v.PrimaryPart then

			if chestESP then
				addESP(v,Color3.fromRGB(255,220,0),"C_ESP")
			else
				local h=v:FindFirstChild("C_ESP")
				if h then h:Destroy() end
			end

		end

	end

end

-------------------------------------------------
-- BRING SYSTEM
-------------------------------------------------

local function bringByNames(names)

	for _,v in pairs(workspace:GetDescendants()) do

		local name=v.Name:lower()

		for _,n in pairs(names) do
			if string.find(name,n) then
				dropToPlayer(v)
				break
			end
		end

	end

end

-------------------------------------------------
-- BRING ITEMS
-------------------------------------------------

local function bringLogs()
	bringByNames({"log"})
end

local function bringMetal()
	bringByNames({
		"metal",
		"bolt",
		"old radio",
		"broken fan",
		"broken microwave",
		"tyre"
	})
end

local function bringFuel()
	bringByNames({
		"fuel",
		"coal",
		"barrel"
	})
end

local function bringHeal()
	bringByNames({"bandage"})
end

local function bringAmmo()
	bringByNames({"ammo"})
end

local function bringWeapons()
	bringByNames({"rifle","gun","pistol"})
end

local function bringFood()
	bringByNames({"meat","carrot","berries","steak","apple"})
end

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui=Instance.new("ScreenGui",player.PlayerGui)

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,460,0,280)
frame.Position=UDim2.new(0.5,-230,0,120)
frame.BackgroundColor3=Color3.fromRGB(25,25,25)
frame.Parent=gui

-------------------------------------------------
-- TOP BAR
-------------------------------------------------

local top=Instance.new("Frame")
top.Size=UDim2.new(1,0,0,30)
top.BackgroundColor3=Color3.fromRGB(35,35,35)
top.Parent=frame

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,30,1,0)
close.Position=UDim2.new(1,-30,0,0)
close.Text="X"
close.Parent=top

local minimize=Instance.new("TextButton")
minimize.Size=UDim2.new(0,30,1,0)
minimize.Position=UDim2.new(1,-60,0,0)
minimize.Text="-"
minimize.Parent=top

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-------------------------------------------------
-- MINIMIZE FIX
-------------------------------------------------

local minimized=false

-------------------------------------------------
-- DRAG
-------------------------------------------------

local dragging=false
local dragStart
local startPos

top.InputBegan:Connect(function(input)

	if input.UserInputType==Enum.UserInputType.MouseButton1
	or input.UserInputType==Enum.UserInputType.Touch then

		dragging=true
		dragStart=input.Position
		startPos=frame.Position

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)

	end

end)

UIS.InputChanged:Connect(function(input)

	if dragging then

		local delta=input.Position-dragStart

		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)

	end

end)

-------------------------------------------------
-- NAV BUTTONS
-------------------------------------------------

local homeBtn=Instance.new("TextButton")
homeBtn.Size=UDim2.new(0,90,0,45)
homeBtn.Position=UDim2.new(0,10,0,60)
homeBtn.Text="Home"
homeBtn.Parent=frame

local bringBtn=Instance.new("TextButton")
bringBtn.Size=UDim2.new(0,90,0,45)
bringBtn.Position=UDim2.new(0,10,0,120)
bringBtn.Text="Bring"
bringBtn.Parent=frame

-------------------------------------------------
-- SCROLL AREA
-------------------------------------------------

local scroll=Instance.new("ScrollingFrame")
scroll.Size=UDim2.new(0,300,0,210)
scroll.Position=UDim2.new(0,120,0,50)
scroll.CanvasSize=UDim2.new(0,0,0,500)
scroll.ScrollBarThickness=6
scroll.BackgroundTransparency=1
scroll.Parent=frame

-------------------------------------------------
-- MINIMIZE SYSTEM
-------------------------------------------------

minimize.MouseButton1Click:Connect(function()

	minimized=not minimized

	if minimized then

		frame.Size=UDim2.new(0,460,0,30)
		homeBtn.Visible=false
		bringBtn.Visible=false
		scroll.Visible=false

	else

		frame.Size=UDim2.new(0,460,0,280)
		homeBtn.Visible=true
		bringBtn.Visible=true
		scroll.Visible=true

	end

end)

-------------------------------------------------
-- HOME BUTTONS
-------------------------------------------------

local playerBtn=Instance.new("TextButton")
playerBtn.Size=UDim2.new(0,200,0,40)
playerBtn.Position=UDim2.new(0,0,0,0)
playerBtn.Text="Player OFF"
playerBtn.Parent=scroll

local animalBtn=Instance.new("TextButton")
animalBtn.Size=UDim2.new(0,200,0,40)
animalBtn.Position=UDim2.new(0,0,0,50)
animalBtn.Text="Animal OFF"
animalBtn.Parent=scroll

local chestBtn=Instance.new("TextButton")
chestBtn.Size=UDim2.new(0,200,0,40)
chestBtn.Position=UDim2.new(0,0,0,100)
chestBtn.Text="Chest OFF"
chestBtn.Parent=scroll

-------------------------------------------------
-- BRING BUTTONS
-------------------------------------------------

local logBtn=Instance.new("TextButton")
logBtn.Size=UDim2.new(0,200,0,35)
logBtn.Position=UDim2.new(0,0,0,0)
logBtn.Text="Bring Log"
logBtn.Visible=false
logBtn.Parent=scroll

local metalBtn=Instance.new("TextButton")
metalBtn.Size=UDim2.new(0,200,0,35)
metalBtn.Position=UDim2.new(0,0,0,40)
metalBtn.Text="Bring Metal"
metalBtn.Visible=false
metalBtn.Parent=scroll

local fuelBtn=Instance.new("TextButton")
fuelBtn.Size=UDim2.new(0,200,0,35)
fuelBtn.Position=UDim2.new(0,0,0,80)
fuelBtn.Text="Bring Fuel"
fuelBtn.Visible=false
fuelBtn.Parent=scroll

local healBtn=Instance.new("TextButton")
healBtn.Size=UDim2.new(0,200,0,35)
healBtn.Position=UDim2.new(0,0,0,120)
healBtn.Text="Heal"
healBtn.Visible=false
healBtn.Parent=scroll

local ammoBtn=Instance.new("TextButton")
ammoBtn.Size=UDim2.new(0,200,0,35)
ammoBtn.Position=UDim2.new(0,0,0,160)
ammoBtn.Text="Ammo"
ammoBtn.Visible=false
ammoBtn.Parent=scroll

local rifleBtn=Instance.new("TextButton")
rifleBtn.Size=UDim2.new(0,200,0,35)
rifleBtn.Position=UDim2.new(0,0,0,200)
rifleBtn.Text="Rifle"
rifleBtn.Visible=false
rifleBtn.Parent=scroll

local foodBtn=Instance.new("TextButton")
foodBtn.Size=UDim2.new(0,200,0,35)
foodBtn.Position=UDim2.new(0,0,0,240)
foodBtn.Text="Food"
foodBtn.Visible=false
foodBtn.Parent=scroll

-------------------------------------------------
-- PAGE SWITCH
-------------------------------------------------

local function showHome()

	playerBtn.Visible=true
	animalBtn.Visible=true
	chestBtn.Visible=true

	logBtn.Visible=false
	metalBtn.Visible=false
	fuelBtn.Visible=false
	healBtn.Visible=false
	ammoBtn.Visible=false
	rifleBtn.Visible=false
	foodBtn.Visible=false

end

local function showBring()

	playerBtn.Visible=false
	animalBtn.Visible=false
	chestBtn.Visible=false

	logBtn.Visible=true
	metalBtn.Visible=true
	fuelBtn.Visible=true
	healBtn.Visible=true
	ammoBtn.Visible=true
	rifleBtn.Visible=true
	foodBtn.Visible=true

end

homeBtn.MouseButton1Click:Connect(showHome)
bringBtn.MouseButton1Click:Connect(showBring)

-------------------------------------------------
-- BUTTON ACTIONS
-------------------------------------------------

playerBtn.MouseButton1Click:Connect(function()
	playerESP=not playerESP
	playerBtn.Text="Player "..(playerESP and "ON" or "OFF")
	updatePlayers()
end)

animalBtn.MouseButton1Click:Connect(function()
	animalESP=not animalESP
	animalBtn.Text="Animal "..(animalESP and "ON" or "OFF")
	updateAnimals()
end)

chestBtn.MouseButton1Click:Connect(function()
	chestESP=not chestESP
	chestBtn.Text="Chest "..(chestESP and "ON" or "OFF")
	updateChests()
end)

logBtn.MouseButton1Click:Connect(bringLogs)
metalBtn.MouseButton1Click:Connect(bringMetal)
fuelBtn.MouseButton1Click:Connect(bringFuel)
healBtn.MouseButton1Click:Connect(bringHeal)
ammoBtn.MouseButton1Click:Connect(bringAmmo)
rifleBtn.MouseButton1Click:Connect(bringWeapons)
foodBtn.MouseButton1Click:Connect(bringFood)

-------------------------------------------------
-- AUTO UPDATE (FIXED)
-------------------------------------------------

task.spawn(function()
	while true do
		task.wait(2)

		if playerESP then updatePlayers() end
		if animalESP then updateAnimals() end
		if chestESP then updateChests() end
	end
end)
