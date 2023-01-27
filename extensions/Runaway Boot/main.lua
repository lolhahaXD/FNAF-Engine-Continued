function ExtensionLoaded()
    Project.CopyExtensionFile("AdvancedVisual.lua", "scripts/#AdvancedVisual.lua")
    Project.CopyExtensionFile("AdvVisuals_Lists.lua", "scripts/#AdvVisuals_Lists.lua")
end

function ExtensionUnloaded()
    Project.RemoveFile("scripts/#AdvancedVisual.lua")
    Project.RemoveFile("scripts/#AdvVisuals_Lists.lua")
end