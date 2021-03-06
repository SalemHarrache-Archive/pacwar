generate_pac_agent_multi_view Planet [list "Map" "MiniMap"]
generate_pac_accessors Planet id
generate_pac_accessors Planet position_x
generate_pac_accessors Planet position_y
generate_pac_accessors Planet radius
generate_pac_accessors Planet density


generate_pac_presentation_accessors MapPlanet canvas_map
generate_pac_presentation_accessors MapPlanet bg_image
generate_pac_presentation_accessors MiniMapPlanet canvas_mini_map

generate_pac_presentation_accessors MapPlanet id
generate_pac_presentation_accessors MiniMapPlanet id

# Abstraction
method PlanetAbstraction init {} {
    this set_id [lindex [split "$objName" "_"] 0]
}

# Controler
method PlanetControl draw {} {
    $this(map) draw [this get_position_x] [this get_position_y] [this get_radius]
    $this(minimap) draw [this get_position_x] [this get_position_y] [this get_radius]
}


# MapPlanetControler
method MapPlanetControl draw {x y radius} {
    $this(presentation) draw $x $y $radius
}

# MapPlanetPresentation
method MapPlanetPresentation init {} {
    this set_bg_image [get_random_planet_bg]
    this set_canvas_map [$this(control) get_parent_value canvas_map]
}

method MapPlanetPresentation draw {x y radius} {
    this set_id [$this(canvas_map) create image $x  $y -anchor center -image [this get_bg_image]]
}

method MapPlanetPresentation delete {} {
    $this(canvas_map) delete [this get_id]
}

method MapPlanetPresentation destructor {} {
    this delete
}


# MiniMapPlanetControler
method MiniMapPlanetControl draw {x y radius} {
    $this(presentation) draw [expr ($x / 10)] \
                             [expr ($y / 10)] \
                             [expr ($radius / 10)]
}

# MiniMapPlanetPresentation
method MiniMapPlanetPresentation init {} {
    this set_canvas_mini_map [$this(control) get_parent_value canvas_mini_map]
}

method MiniMapPlanetPresentation draw {x y radius} {
    set x1 [expr $x - $radius]
    set y1 [expr $y - $radius]
    set x2 [expr $x + $radius]
    set y2 [expr $y + $radius]
    this set_id [$this(canvas_mini_map) create oval $x1 $y1 $x2 $y2 -outline #FFF -fill [get_random_color]]
}

method MiniMapPlanetPresentation delete {} {
    $this(canvas_mini_map) delete [this get_id]
}

method MiniMapPlanetPresentation destructor {} {
    this delete
}