--!strict
-- Copyright (c) 2024 Metatable Games, all rights reserved.
-- Copyright (c) 2024 RAMPAGE Interactive, all rights reserved.

local RBLXVRGui = {}
RBLXVRGui.__index = RBLXVRGui

local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Camera = workspace.CurrentCamera

local Maid = require(script.Parent:WaitForChild("Maid"))
local RBLXScreenSpaceUtil = require(script.Parent:WaitForChild("RBLXScreenSpaceUtil"))

export type RBLXVRGui = {
	Gui: ScreenGui,
	Maid: typeof(Maid.new()),

	viewSizeX: number,
	viewSizeY: number,
    
	_worldGuiRoot: Part,
	_surfaceGui: SurfaceGui,

	GuiDepth: number,
	GuiSizingMode: Enum.SurfaceGuiSizingMode,
	GuiPixelsPerStud: number,
	GuiAlwaysOnTop: boolean,

	xChanged: RBXScriptConnection?,
	yChanged: RBXScriptConnection?,

	_update: (self: RBLXVRGui) -> (),
	Destroy: (self: RBLXVRGui) -> (),
}

function RBLXVRGui.new(ScreenGui: ScreenGui, Config: { [string]: any }?): RBLXVRGui
	if not Config then
		Config = {}
	end

	local self = setmetatable({}, RBLXVRGui)

	self.Gui = ScreenGui
	self.Maid = Maid.new()

	local function onViewChanged()
		if self.xChanged then
			self.xChanged:Disconnect()
		end

		if self.yChanged then
			self.yChanged:Disconnect()
		end

		self.viewSizeX, self.xChanged = RBLXScreenSpaceUtil.ViewSizeX()
		self.viewSizeY, self.yChanged = RBLXScreenSpaceUtil.ViewSizeY()

		self.Maid:GiveTask(self.xChanged:Connect(onViewChanged))
		self.Maid:GiveTask(self.yChanged:Connect(onViewChanged))
	end

	onViewChanged()

	self._worldGuiRoot = Instance.new("Part")
	self._worldGuiRoot.Name = "3DWorldGui"
	self._surfaceGui = Instance.new("SurfaceGui")

	self.GuiDepth = 10
	self.GuiSizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	self.GuiPixelsPerStud = 200
	self.GuiAlwaysOnTop = true

	self._surfaceGui.Face = Enum.NormalId.Front
	self._surfaceGui.Adornee = self._worldGuiRoot
	self._surfaceGui.Parent = self._worldGuiRoot

	self._surfaceGui.LightInfluence = 0
	self._surfaceGui.ResetOnSpawn = false
	self._surfaceGui.MaxDistance = 1000

    for _, child in ipairs(ScreenGui:GetChildren()) do
        child:Clone().Parent = self._surfaceGui
    end

	for i, v in pairs(Config) do
		self[i] = v
	end

	self.Maid:GiveTask(RunService.RenderStepped:Connect(function()
		self:_update()
	end))

	self.Maid:GiveTask(self._worldGuiRoot)

	return self
end

function RBLXVRGui:Destroy()
	if not self or self and not self.Maid then
		return
	end

	self.Maid:DoCleaning()
end

function RBLXVRGui:_update()
	if not VRService.VREnabled then
		self._worldGuiRoot.Parent = script
		return
	end

	self._surfaceGui.AlwaysOnTop = self.GuiAlwaysOnTop
	self._surfaceGui.PixelsPerStud = self.GuiPixelsPerStud
	self._surfaceGui.SizingMode = self.GuiSizingMode

	self._worldGuiRoot.CFrame = Camera.CFrame
		* VRService:GetUserCFrame(Enum.UserCFrame.Head)
		* CFrame.new(0, 0, -self.GuiDepth - 0.5)
		* Camera.HeadScale

	self._worldGuiRoot.Size = Vector3.new(
		RBLXScreenSpaceUtil.ScreenWidthToWorldWidth(self.viewSizeX, -self.GuiDepth),
		RBLXScreenSpaceUtil.ScreenHeightToWorldHeight(self.viewSizeY, -self.GuiDepth),
		1
	) * Camera.HeadScale

	self._worldGuiRoot.Parent = Camera
end

return RBLXVRGui