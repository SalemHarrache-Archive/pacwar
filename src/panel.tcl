# Génération d'un agent Panel
generate_pac_agent Panel

generate_pac_accessors Panel kernel

generate_pac_presentation_accessors Panel frame


# Abstraction
method PanelAbstraction init {} {
    this set_kernel [$this(control) get_parent_value kernel]
    $this(kernel) Subscribe_after_Add_new_player $objName "$this(control) add_player_callback \$rep \$name"
    $this(kernel) Subscribe_after_Destroy_player $objName "$this(control) remove_player_callback \$id"
}


# Controler
method PanelControl init {} {
     $this(parent) set_panel $objName
     set this(players) [dict create]
}

method PanelControl reset {} {
    foreach child $this(children) {
        $child dispose
    }
    this init
    $this(abstraction) init
    $this(presentation) reset
}

method PanelControl add_player_callback {id name} {
    set new_player [PlayerControl ${id}_${name} $objName [$this(presentation) get_new_player_frame]]
    $new_player set_binding
    dict set this(players) [$new_player get_id] $new_player
    $this(presentation) refresh
}

method PanelControl remove_player_callback {id} {
    set player [dict get $this(players) $id]
    set this(players) [dict remove $this(players) $id]
    $player user_change_status 0
    if {[llength $this(players)] == 2} {
        $this(parent) gameover
    }
}

method PanelControl get_player {id} {
    foreach player  $this(players) {
        if {[$player get_id] == $id} {
            return $player
        }
    }
}

method PanelControl send_event_from_player {event id} {
    $this(parent) send_event_from_player $event $id
}

method PanelControl send_position_to_player {player_id position} {
    set player [dict get $this(players) $player_id]
    $player set_position $position
}

# Presentation
method PanelPresentation init {} {
    this set_frame [$this(control) get_parent_value frame_panel_players]
    set this(player_frames) {}
    this refresh
}

method PanelPresentation reset {} {
    foreach {frame} $this(player_frames) {
        destroy $frame
    }
    this init
}

method PanelPresentation get_new_player_frame {} {
    set new_frame [frame $this(frame).frame_[llength $this(player_frames)]]
    lappend this(player_frames) $new_frame
    return $new_frame
}

method PanelPresentation refresh {} {
    foreach frame $this(player_frames) {
        pack forget $frame
    }
    foreach frame $this(player_frames) {
        pack configure $frame  -expand 1
    }
}