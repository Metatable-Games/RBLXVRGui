-- Copyright (c) 2024 RAMPAGE Interactive, all rights reserved.

local Players = game:GetService("Players")
local PlayerMouse = Players.LocalPlayer:GetMouse()
local ScreenSpaceUtil = {}

local cam = workspace.CurrentCamera
local fov = cam.FieldOfView

cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    fov = cam.FieldOfView
end)

-- Returns the horizontal view size of the screen.
function ScreenSpaceUtil.GetViewSizeX()
    local x, y = PlayerMouse.ViewSizeX, PlayerMouse.ViewSizeY
    if x == 0 then
        return 1024
    end
    return x > y and x or y
end

-- Returns the vertical view size of the screen.
function ScreenSpaceUtil.GetViewSizeY()
    local x, y = PlayerMouse.ViewSizeX, PlayerMouse.ViewSizeY
    if y == 0 then
        return 768
    end
    return y > x and y or x
end

-- Computes the screen's aspect ratio.
function ScreenSpaceUtil.GetAspectRatio()
    return ScreenSpaceUtil.GetViewSizeX() / ScreenSpaceUtil.GetViewSizeY()
end

-- Converts a world position to screen space.
function ScreenSpaceUtil.WorldToScreen(position)
    local point = cam.CoordinateFrame:pointToObjectSpace(position)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor

    local x = (point.x / point.z) / -wFactor
    local y = (point.y / point.z) / hFactor

    return Vector2.new(
        ScreenSpaceUtil.GetViewSizeX() * (0.5 + 0.5 * x),
        ScreenSpaceUtil.GetViewSizeY() * (0.5 + 0.5 * y)
    )
end

-- Converts screen space to a world position at a specified depth.
function ScreenSpaceUtil.ScreenToWorld(x, y, depth)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor

    local xf = (x / ScreenSpaceUtil.GetViewSizeX()) * 2 - 1
    local yf = (y / ScreenSpaceUtil.GetViewSizeY()) * 2 - 1

    return Vector3.new(
        xf * -wFactor * depth,
        yf * hFactor * depth,
        depth
    )
end

-- Converts screen width to world width at a given depth.
function ScreenSpaceUtil.ScreenWidthToWorldWidth(screenWidth, depth)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor
    return -(screenWidth / ScreenSpaceUtil.GetViewSizeX()) * 2 * wFactor * depth
end

-- Converts screen height to world height at a given depth.
function ScreenSpaceUtil.ScreenHeightToWorldHeight(screenHeight, depth)
    local hFactor = math.tan(math.rad(fov) / 2)
    return -(screenHeight / ScreenSpaceUtil.GetViewSizeY()) * 2 * hFactor * depth
end

-- Converts world width to screen width at a given depth.
function ScreenSpaceUtil.WorldWidthToScreenWidth(worldWidth, depth)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor
    return -(worldWidth * ScreenSpaceUtil.GetViewSizeX()) / (2 * wFactor * depth)
end

-- Converts world height to screen height at a given depth.
function ScreenSpaceUtil.WorldHeightToScreenHeight(worldHeight, depth)
    local hFactor = math.tan(math.rad(fov) / 2)
    return -(worldHeight * ScreenSpaceUtil.GetViewSizeY()) / (2 * hFactor * depth)
end

-- Calculates the depth needed for a screen width and world width.
function ScreenSpaceUtil.GetDepthForWidth(screenWidth, worldWidth)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor
    return -(ScreenSpaceUtil.GetViewSizeX() * worldWidth) / (screenWidth * 2 * wFactor)
end

-- Calculates the depth needed for a screen height and world height.
function ScreenSpaceUtil.GetDepthForHeight(screenHeight, worldHeight)
    local hFactor = math.tan(math.rad(fov) / 2)
    return -(ScreenSpaceUtil.GetViewSizeY() * worldHeight) / (screenHeight * 2 * hFactor)
end

-- Calculates the world position and size based on screen dimensions and depth.
function ScreenSpaceUtil.ScreenToWorldByHeightDepth(x, y, screenHeight, depth)
    local aspectRatio = ScreenSpaceUtil.GetAspectRatio()
    local hFactor = math.tan(math.rad(fov) / 2)
    local wFactor = aspectRatio * hFactor

    local worldHeight = -(screenHeight / ScreenSpaceUtil.GetViewSizeY()) * 2 * hFactor * depth
    local xf = (x / ScreenSpaceUtil.GetViewSizeX()) * 2 - 1
    local yf = (y / ScreenSpaceUtil.GetViewSizeY()) * 2 - 1

    return Vector3.new(xf * -wFactor * depth, yf * hFactor * depth, depth), worldHeight
end

return ScreenSpaceUtil