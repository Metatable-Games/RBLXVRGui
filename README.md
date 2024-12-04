# RBLXVRGui
RBLXVRGui is a Roblox Virtual Reality Graphical User Interface Management Module designed to allow full-screen GUIs in VR. This module helps manage and render GUIs full-screen like in a 3D space for the Roblox VR environment.

## ⚠️ **RBLXVRGui is experimental and subjected to bugs.** ⚠️

## Features

- Manage and render full-screen GUIs in VR.
- Automatically updates GUI positions and sizes based on the user's view.
- Configurable properties for GUI depth, sizing mode, pixels per stud, and always-on-top behavior.
- Utilizes a Maid system for efficient resource management and cleanup.

## Installation
1. Download the RBLXVRGui.lua file and place it in your Roblox project.
2. Ensure you have the required dependencies: `Maid` (https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Shared/Events/Maid.lua) and `RBLXScreenSpaceUtil` (https://github.com/RAMPAGELLC/RBLXScreenSpaceUtil).


## Usage

### Creating a New RBLXVRGui Instance

To create a new instance of `RBLXVRGui`, you need to provide a `ScreenGui` and an optional configuration table.

```lua
local RBLXVRGui = require(path.to.RBLXVRGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local vrGui = RBLXVRGui.new(ScreenGui, {
    GuiDepth = 15,
    GuiSizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
    GuiPixelsPerStud = 100,
    GuiAlwaysOnTop = false,
})
```

### Adding/Removing Instances

You can add instances to the `ScreenGui` and they will be automatically copied to the `SurfaceGui`.

```lua
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Text = "Click Me"
button.Parent = vrGui.Gui

-- To remove an instance
button:Destroy()
```

### Connecting Events

You can connect events to the GUI elements as usual. For example, to connect a `MouseButton1Down` event to a button:

```lua
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Text = "Click Me"
button.Parent = vrGui.Gui

button.MouseButton1Down:Connect(function()
    print("Button clicked!")
end)
```

### Destroying the RBLXVRGui Instance

To properly clean up and destroy the `RBLXVRGui` instance, call the `Destroy` method.

```lua
vrGui:Destroy()
```

## Example

Here's a complete example of how to use `RBLXVRGui` in a Roblox game:

```lua
local RBLXVRGui = require(path.to.RBLXVRGui)
local Maid = require(path.to.Maid)
local RBLXScreenSpaceUtil = require(path.to.RBLXScreenSpaceUtil)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local vrGui = RBLXVRGui.new(ScreenGui, {
    GuiDepth = 15,
    GuiSizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
    GuiPixelsPerStud = 100,
    GuiAlwaysOnTop = false,
})

-- Add your GUI elements to the ScreenGui
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "Hello, VR World!"
textLabel.Parent = ScreenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Text = "Click Me"
button.Parent = ScreenGui

button.MouseButton1Down:Connect(function()
    print("Button clicked!")
end)

-- You can also access the button this way:
vrGui.Gui.TextButton.MouseButton1Down:Connect(function()
    print("Button clicked!")
end)

-- Clean up when done
game.Players.LocalPlayer.CharacterRemoving:Connect(function()
    vrGui:Destroy()
end)
```

## License
This module is provided under the MIT License. See the LICENSE file for more information.

## Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss any changes or improvements.