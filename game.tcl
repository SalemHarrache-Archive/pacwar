generate_pac_agent "Game"

# Sert a afficher la map
generate_pac_presentation_accessors Game canvas_map
# Sert a afficher la mini map
generate_pac_presentation_accessors Game canvas_mini_map
# Sert a afficher le panel
generate_pac_presentation_accessors Game frame_panel
# Sert juste à regrouper le panel et la mini map
generate_pac_presentation_accessors Game frame_wrapper
# Sert a afficher la mini map
generate_pac_presentation_accessors Game display_mode





method GamePresentation init {} {
    wm aspect $this(tk_parent) 3 2 3 2
    # wm minsize $this(tk_parent) 1200 1200
    # wm maxsize $this(tk_parent) 1200 1200
    wm title $this(tk_parent) "PacWar !"
    this set_display_mode vertical

    this set_canvas_map [canvas $this(tk_parent).canvas_map]
    this set_frame_wrapper [frame $this(tk_parent).frame_wrapper -relief raised -borderwidth 1]
    # On regroupe les le panel et la minimap dans une frame
    this set_canvas_mini_map [canvas $this(frame_wrapper).canvas_mini_map]
    this set_frame_panel [frame $this(frame_wrapper).frame_panel]

    pack $this(canvas_map) -expand 1 -side right -fill both
    pack $this(frame_wrapper) -side left -fill both
    pack $this(frame_panel) -expand 1 -fill both
    pack $this(canvas_mini_map) -fill both

    bind $this(tk_parent) <Control-Key-p> "$objName switch_view_mode; $objName refresh"
    wm minsize $this(tk_parent) 0 0
    wm maxsize $this(tk_parent) 0 0
}

method GamePresentation switch_view_mode {} {
    if {[this get_display_mode] == "vertical"} {
        this set_display_mode "horizontal"
    } else {
        this set_display_mode "vertical"
    }
}

method GamePresentation refresh {} {
    pack forget $this(canvas_map) $this(frame_wrapper) $this(frame_panel) $this(canvas_mini_map)
    if {$this(display_mode) == "vertical"} {
        pack configure $this(canvas_map)  -expand 1 -side right -fill both
        pack configure $this(frame_wrapper) -side left -fill both
        pack configure $this(frame_panel) -expand 1 -fill both
        pack configure $this(canvas_mini_map) -fill both
    } else {
        pack configure $this(frame_wrapper) -side right -fill both
        pack configure $this(frame_panel) -expand 1 -fill both
        pack configure $this(canvas_mini_map) -fill both
        pack configure $this(canvas_map)  -expand 1 -side right -fill both
    }


}


method GameControl add_player {player} {

}
