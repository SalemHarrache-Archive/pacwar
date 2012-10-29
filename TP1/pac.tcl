#!/bin/sh
# restart using tclsh \
exec wish "$0" "$@"

# load utilities
source [file join [file dirname [info script]] .. PAC.tcl]


# ValueAbstraction --

inherit ValueAbstraction Abstraction
method ValueAbstraction constructor {control value} {
   this inherited $control
   set this(value) $value
   trace add variable this(value) write "$objName change"
}

method ValueAbstraction change {args} {
   $this(control) change
}

method ValueAbstraction edit {value} {
   set this(value) $value
   $this(control) change
}

# ValuePresentation --

inherit ValuePresentation Presentation
method ValuePresentation constructor {control label unit} {
   this inherited $control

   set this(window) [toplevel .${objName}]
   wm protocol $this(window) WM_DELETE_WINDOW "$this(control) dispose"

   set this(entry) [entry $this(window).entry -justify right]
   pack $this(entry) -expand 1 -fill both

   bind $this(entry) <Return> "$objName edit"
}

method ValuePresentation change {value} {
   $this(entry) delete 0 end
   $this(entry) insert 0 $value
}

method ValuePresentation edit {} {
   set newValueControl [$this(entry) get]
   $this(control) edit $newvalue
}

method ValuePresentation destructor {} {
   destroy $this(window)
}



# ValueControl --

inherit ValueControl Control
method ValueControl constructor {parent value label unit} {
   ValueAbstraction ${objName}_abst $objName $value
   ValuePresentation ${objName}_pres $objName $label $unit
   this inherited $parent ${objName}_abst ${objName}_pres

   this change
}

method ValueControl edit {newvalue} {
   $this(abstraction) edit $newvalue
}

method ValueControl change {} {
   $this(presentation) change [$this(abstraction) attribute value]
}

method ValueControl destructor {} {
   this inherited
}

ValueControl value "" 10 Température °C