-- AdvancedVisual table
AdvancedVisual = {
    OfficeAnimations = {},
    CameraAnimations = {},
    Lists = {}
}

events.OnEngineStart(function(e)
    FEScript.RunEvent(FEScript.AllScripts, "on_engine_start")
end)

-- Loop animatronics
events.VisualActionCalled(function(e)
    if e.ActionName == "loop_animatronics" then
        local loopvar = e.ActionArgs[1]
        if loopvar == "" then loopvar = "animatronic" end

        for k, v in pairs(game.Animatronics) do
            FEScript.Variables[loopvar] = k
            FEScript.RunCode(e.ActionSubcode)
        end
    end
end)



-- Load office animations
events.VisualActionCalled(function(e)
    if e.ActionName == "load_office_animation" then
        local animationname = e.ActionArgs[1]

        -- If the animation is already loaded, return
        if AdvancedVisual.OfficeAnimations[animationname] ~= nil then return end

        -- Load animation
        local frames = GetAnimation(animationname)

        -- frames is nil meaning it failed or didn't find the animation
        if frames == nil then return end

        -- Define the animation
        AdvancedVisual.OfficeAnimations[animationname] = {
            Frames = frames,
            Offset = MF_OfficeImages()-1,
            IsPlaying = false,
            IsPaused = false
        }

        -- Load the images
        for i, frame in ipairs(frames) do
            MF_AddOfficeImage(frame.sprite)
        end
    end
end)

-- Load cam animations
events.VisualActionCalled(function(e)
    if e.ActionName == "load_camera_animation" then
        local animationname = e.ActionArgs[1]

        -- If the animation is already loaded, return
        if AdvancedVisual.CameraAnimations[animationname] ~= nil then return end

        -- Load animation
        local frames = GetAnimation(animationname)

        -- frames is nil meaning it failed or didn't find the animation
        if frames == nil then return end

        -- Define the animation
        AdvancedVisual.CameraAnimations[animationname] = {
            Frames = frames,
            Offset = MF_CameraImages()-1,
            IsPlaying = false,
            IsPaused = false
        }

        -- Load the images
        for i, frame in ipairs(frames) do
            MF_AddCamStateImg(frame.sprite)
        end
    end
end)

-- Play function
function AdvancedVisual.PlayAnimation(frames, offset, type_, ...)
    local type_ = type_ or "office"
    local func = MF_SetOfficeImage
    local args = {...}
    local animdata = AdvancedVisual.OfficeAnimations[args[1]]
    if type_ == "camera" then
        func = MF_SetCameraImage
        animdata = AdvancedVisual.CameraAnimations[args[1]]
    end

    Threading.StartThread(function()
        for i, frame in ipairs(frames) do
            local i_calc = (i-1)+offset
            if not animdata.IsPlaying then break end
            if not animdata.IsPaused then
                func(i_calc)
                delay(frame.duration)
            else
                while true do
                    if not animdata.IsPaused then break end
                    if not animdata.IsPlaying then break end
                    func(i_calc)
                    delay(1)
                end
            end
        end

        animdata.IsPlaying = false
        animdata.IsPaused = false

        -- Execute finished event
        FEScript.RunEvent(FEScript.AllScripts, type_.."_animation_finished", args)

    end)
end

-- Play office animation
events.VisualActionCalled(function(e)
    if e.ActionName == "play_office_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.OfficeAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried play non existing office animation '"..animation.."'") end
        
        data.IsPlaying = true
        data.IsPaused = false
        AdvancedVisual.PlayAnimation(data.Frames, data.Offset, "office", animation)
    end
end)


-- Play camera animation
events.VisualActionCalled(function(e)
    if e.ActionName == "play_camera_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.CameraAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried play non existing camera animation '"..animation.."'") end

        data.IsPlaying = true
        data.IsPaused = false
        AdvancedVisual.PlayAnimation(data.Frames, data.Offset, "camera", animation)
    end
end)


events.VisualActionCalled(function(e)
    if e.ActionName == "pause_office_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.OfficeAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried pausing non existing animation '"..animation.."'") end

        data.IsPaused = true
    end
end)


events.VisualActionCalled(function(e)
    if e.ActionName == "resume_office_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.OfficeAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried pausing non existing animation '"..animation.."'") end

        data.IsPaused = false
    end
end)


events.VisualActionCalled(function(e)
    if e.ActionName == "pause_camera_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.CameraAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried pausing non existing animation '"..animation.."'") end

        data.IsPaused = true
    end
end)


events.VisualActionCalled(function(e)
    if e.ActionName == "resume_camera_animation" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.CameraAnimations[animation]

        if data == nil then MF_ErrorQuit("AdvancedVisual Error: Tried pausing non existing animation '"..animation.."'") end

        data.IsPaused = false
    end
end)


events.VisualActionCalled(function(e)
    if e.ActionName == "is_cam_paused" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.CameraAnimations[animation]

        if  e.Negated == nil and data.IsPaused then
			FEScript.RunCode(e.ActionSubcode)
		elseif e.Negated and not data.IsPaused then
			FEScript.RunCode(e.ActionSubcodee)
		end
    elseif e.ActionName == "is_office_paused" then
        local animation = e.ActionArgs[1]
        local data = AdvancedVisual.OfficeAnimations[animation]

        if  e.Negated == nil and data.IsPaused then
			FEScript.RunCode(e.ActionSubcode)
		elseif e.Negated and not data.IsPaused then
			FEScript.RunCode(e.ActionSubcodee)
		end
    end
end)