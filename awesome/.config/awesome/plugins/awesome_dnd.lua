-- plugins/awesome_dnd.lua
-- // MARK: DRAG AND DROP
-- ################################################################################
-- ██████╗ ██████╗ ██████╗  █████╗  ██████╗     ██████╗  ██████╗ ██████╗ 
-- ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝    ██╔═══██╗██╔═══██╗██╔══██╗
-- ██║  ██║██████╔╝██║  ██║███████║██║         ██║   ██║██║   ██║██████╔╝
-- ██║  ██║██╔══██╗██║  ██║██╔══██║██║         ██║   ██║██║   ██║██╔═══╝ 
-- ██████╔╝██║  ██║██████╔╝██║  ██║╚██████╗    ╚██████╔╝╚██████╔╝██║     
-- ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝     
-- ################################################################################
-- DRAG AND DROP - client to tag drag and drop functionality


-- Drag-and-drop client → tag functionality
-- Exposes:
--   awesome_dnd.start_custom_drag(client, opts)
--   awesome_dnd.finish_custom_drag()
--   awesome_dnd.set_hover(tag, widget)
--   awesome_dnd.clear_hover()
--   awesome_dnd.update_hover_from_mouse()
--   awesome_dnd.resolve_drop_target()

local awful = require("awful")
local gears = require("gears")
local mouse = mouse
local mousegrabber = mousegrabber

local M = {
    dragged_client = nil,
    hovered_tag = nil,
    hovered_widget = nil,
    drag_active = false,
    _timer = nil,
    _follow_on_drop = nil,
    _overlay = nil,
    _drag_keygrabber = nil,
    _paused_border_anim = false
}

function M.clear_hover()
    local widget_to_clear = M.hovered_widget

    if widget_to_clear then
        local widget_valid = widget_to_clear.valid
        if widget_valid == nil or widget_valid then
            -- Restore original styling
            if widget_to_clear._dnd_prev_bg then
                widget_to_clear.bg = widget_to_clear._dnd_prev_bg
                widget_to_clear._dnd_prev_bg = nil
            end
            if widget_to_clear._dnd_prev_fg then
                widget_to_clear.fg = widget_to_clear._dnd_prev_fg
                widget_to_clear._dnd_prev_fg = nil
            end
        end
    end
    M.hovered_tag = nil
    M.hovered_widget = nil
end

function M.set_hover(tag, widget)
    -- Clear previous hover first
    M.clear_hover()

    -- Set new hover
    M.hovered_tag = tag
    M.hovered_widget = widget

    -- Apply styling the same way normal hover works
    if widget then
        local widget_valid = widget.valid
        if widget_valid == nil or widget_valid then
            -- Store original colors before changing
            widget._dnd_prev_bg = widget.bg
            widget._dnd_prev_fg = widget.fg
            -- Apply hover styling
            widget.bg = "#444444"
            widget.fg = "#ffffff"
        end
    end
end

function M.start_custom_drag(c, opts)
    if not c or not c.valid then return end

    M.dragged_client = c

    -- set visual feedback immediately
    c._dnd_prev_border_color = c.border_color
    c.border_color = "#ff0000"
    c.border_width = 3
    c._dnd_dragging = true

    -- global drag flag (also used by border animation to pause)
    M.drag_active = true
    M._follow_on_drop = opts and opts.follow_on_drop or false

    -- prevent text selection in client (best-effort)
    c.input_passthrough = true

    -- pause border animation via signal (plugin-aware)
    if awesome and awesome.emit_signal then
        awesome.emit_signal("border_animation::pause")
    end
    -- Fallback: stop inline timer if present
    if border_animation_timer and border_animation_timer.started then
        border_animation_timer:stop()
        M._paused_border_anim = true
    end

    -- use mousegrabber to capture pointer and set cursor during drag
    mousegrabber.run(function(m)
        if not c.valid then
            M.finish_custom_drag()
            return false
        end
        -- detect shift follow-on-drop via modifiers if available
        if m.modifiers then
            M._follow_on_drop =
                m.modifiers.Shift or m.modifiers["Shift_L"] or
                    m.modifiers["Shift_R"] or false
        end
        -- continuously update hovered tag
        if M.update_hover_from_mouse then
            M.update_hover_from_mouse()
        end
        -- stop on left button release
        if not (m.buttons and m.buttons[1]) then
            M.finish_custom_drag()
            return false
        end
        return true
    end, "fleur")
end

function M.finish_custom_drag()
    -- ensure any overlay/keygrabber are gone (legacy cleanup)
    if M._overlay and M._overlay.valid then
        M._overlay.visible = false
    end
    M._overlay = nil
    if M._drag_keygrabber then M._drag_keygrabber:stop() end
    M._drag_keygrabber = nil

    local c = M.dragged_client
    local target_tag = M.hovered_tag
    local follow = M._follow_on_drop
    
    -- Emit drag end signal for maximized window handling
    if c and c.valid and c._was_maximized then
        c:emit_signal("awesome::drag_end")
    end

    -- perform the drop
    if c and c.valid and target_tag and target_tag.valid then
        -- move client to target tag
        c:move_to_tag(target_tag)
        
        -- optionally follow client to new tag
        if follow then
            target_tag:view_only()
        end
    end

    -- restore client visuals
    if c and c.valid then
        if c._dnd_prev_border_color then
            c.border_color = c._dnd_prev_border_color
            c._dnd_prev_border_color = nil
        end
        c.border_width = 1
        c._dnd_dragging = nil
        c.input_passthrough = false
    end

    -- resume border animation via signal (plugin-aware)
    if awesome and awesome.emit_signal then
        awesome.emit_signal("border_animation::resume")
    end
    -- Fallback: restart inline timer if we paused it
    if M._paused_border_anim and border_animation_timer then
        border_animation_timer:start()
        M._paused_border_anim = false
    end

    -- clear visual feedback and state
    M.clear_hover()
    M.dragged_client = nil
    M.hovered_tag = nil
    M.drag_active = false
    M._follow_on_drop = nil
end

function M.update_hover_from_mouse()
    local mc = mouse.coords()
    if not mc then
        M.clear_hover()
        return
    end

    local found_tag = nil
    local found_widget = nil

    -- Check all screens for tag widgets under mouse
    for s in screen do
        if s.mywibox and s.mywibox.visible then
            local wibox_geo = s.mywibox:geometry()
            if mc.x >= wibox_geo.x and mc.x <= wibox_geo.x + wibox_geo.width and
               mc.y >= wibox_geo.y and mc.y <= wibox_geo.y + wibox_geo.height then
                
                -- Check taglist widgets
                if s.mytaglist then
                    for _, tag in ipairs(s.tags) do
                        -- Simple approximation - in real implementation you'd need
                        -- to get actual widget geometries
                        local tag_widget = s.mytaglist._private.widgets[tag.index]
                        if tag_widget then
                            found_tag = tag
                            found_widget = tag_widget
                            break
                        end
                    end
                end
            end
        end
        if found_tag then break end
    end
    
    if found_tag then
        M.set_hover(found_tag, found_widget)
    else
        M.clear_hover()
    end
end

function M.resolve_drop_target()
    if M.hovered_tag and M.hovered_tag.valid then
        return M.hovered_tag
    end
    local mc = mouse.coords()
    if not mc then return nil end
    
    -- Fallback: find tag under mouse
    for s in screen do
        for _, tag in ipairs(s.tags) do
            -- Simple geometric check - would need refinement
            if tag.selected then
                return tag
            end
        end
    end
    return nil
end

return M
