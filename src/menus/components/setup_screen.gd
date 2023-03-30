# This sets up the buttons for a menu panel
extends Node

var screen:PanelContainer
var search
var first_to_focus
var buttons = {}

func _init(init_screen:PanelContainer, func_connect_to = null):
	screen = init_screen

	search = func_connect_to if func_connect_to else screen

	setup(screen)

	if screen.connect("visibility_changed", self, "_on_visibility_changed") != OK:
		push_error("panel failed to connect")

# Internal: Set up the button pressed signal for all buttons on scrren
#
# panel = Contains the panel that has the buttons. (PanelContainer)
#
# Example
#	setup(game_over.tscn)
func setup(panel) -> void:
	for child in panel.get_children():
		if child is Button:
			buttons[child.get_name()] = child
			child.connect("pressed", self, "button_pressed", [child.call_function, child.function_values])
			if first_to_focus == null:
				first_to_focus = child

		if child.get_child_count() > 0:
			setup(child)

# Public: Sets the defualt button to grab the focus
func _on_visibility_changed() -> void:
	if screen.visible and first_to_focus:
		first_to_focus.grab_focus()

# Public: Signals for function call when a screen button is pressed
#
# func_name = Name of the function to be called.
# func_prop = The property of the function being called.(String) (Optional)
#
# Example
#	button_pressed("switch_panel", "pause")
func button_pressed(func_name:String, func_prop = null) -> void:
	if search.has_method(func_name):
		if func_prop:
			search.call(func_name, func_prop)
		else:
			search.call(func_name)

		return

	search.emit_signal("update_menu_controller", func_name, func_prop)
