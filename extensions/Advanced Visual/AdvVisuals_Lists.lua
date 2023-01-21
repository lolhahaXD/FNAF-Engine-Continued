
events.VisualActionCalled(function(e)
    local list_name = e.ActionArgs[1]
    if list_name == "" then return end

    if e.ActionName == "create_list" then
        local values = e.ActionArgs[2]
        if values ~= "" then values = string.split(e.ActionArgs[2], "|") else values = {} end
        AdvancedVisual.Lists[list_name] = values

    elseif e.ActionName == "delete_list" then
        if AdvancedVisual.Lists[list_name] == nil then return end
        AdvancedVisual.Lists[list_name] = nil

    elseif e.ActionName == "loop_over_list" then
        local varname = e.ActionArgs[2]
        if AdvancedVisual.Lists[list_name] == nil then return end

        for i, v in ipairs(AdvancedVisual.Lists[list_name]) do
            FEScript.Variables[varname] = v
            FEScript.RunCode(e.ActionSubcode)
        end
    elseif e.ActionName == "append_list" then
        if AdvancedVisual.Lists[list_name] == nil then return end
        local values = e.ActionArgs[2]
        if values ~= "" then values = string.split(e.ActionArgs[2], "|") else values = {} end

        for i, v in ipairs(values) do
            local list_len = #AdvancedVisual.Lists[list_name]
            AdvancedVisual.Lists[list_name][list_len+1] = v
        end
    end
end)



events.VisualActionCalled(function(e)
    local list_idx = e.ActionArgs[1]
    local list_name = e.ActionArgs[2]
    if list_name == "" then return end
    if AdvancedVisual.Lists[list_name] == nil then return end
    if list_idx == "" then list_idx = 1 else list_idx = tonumber(list_idx) end

    if e.ActionName == "remove_list" then
        if list_idx <= #AdvancedVisual.Lists[list_name] then
            table.remove(AdvancedVisual.Lists[list_name], list_idx)
        end
    elseif e.ActionName == "set_item_at_index" then
        AdvancedVisual.Lists[list_name][list_idx] = e.ActionArgs[3]
    end
end)


FEScript.Expressions["index"] = function(full_arg, list_name, idx)
    if AdvancedVisual.Lists[list_name] == nil then return "None" end
    return AdvancedVisual.Lists[list_name][tonumber(idx)] or "None"
end

FEScript.Expressions["listlen"] = function(full_arg, list_name)
    if AdvancedVisual.Lists[list_name] == nil then return "None" end
    return tostring(#AdvancedVisual.Lists[list_name])
end