
generate_pac_agent Player
generate_pac_accessors Player score
generate_pac_accessors Player id
generate_pac_accessors Player name


method PlayerAbstraction init {} {
    this set_name [lindex [split "$objName" "_"] [expr {[llength [split "$objName" "_"]] - 2}]]
    this set_id [get_new_id]
    this set_score 10
}


method PlayerPresentation init {} {
    set this(label) [label $this(tk_parent).label -justify right -text [this get_label_message]]
    pack $this(label) -expand 1 -fill both
}


method PlayerPresentation get_label_message {} {
    return "Joueur [this get_id] ([this get_name]): [this get_score]"
}


method PlayerPresentation refresh {} {
    set this(label) configure -text [this get_label_message]
}


method PlayerControl init {} {

}


method PlayerControl set_binding {config} {
    eval $config
}

method PlayerControl send_event {event} {
    $this(parent) send_event_from_player $event [this get_id]
}


method PlayerControl decr_ang {} {
    this send_event "decr_ang"
}

method PlayerControl incr_ang {} {
    this send_event "incr_ang"
}

method PlayerControl speed_up {} {
    this send_event "speed_up"
}

method PlayerControl speed_down {} {
    this send_event "speed_down"
}

method PlayerControl shut {} {
    this send_event "shut"
}