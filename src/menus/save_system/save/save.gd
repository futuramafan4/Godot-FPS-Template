extends PanelContainer

signal update_menu_controller(func_name, func_prop)
export(Resource) var player_data
onready var player = get_tree().get_root().find_node("character", true, false)
var data = {
}

onready var popup = $popup
onready var slots := $HBoxContainer/ScrollContainer/Slots
onready var setup_screen = load("res://src/menus/components/setup_screen.gd").new(self)
onready var file_handler = preload("res://src/menus/save_system/components/file_handler.gd").new()
onready var save_slot_handler = load(
	"res://src/menus/save_system/components/save_slot_handler.gd"
).new(self, slots)

func _ready() -> void:
	add_child(setup_screen)
	add_child(save_slot_handler)
	add_child(file_handler)

	if self.connect("visibility_changed", self, "_on_visibility_changed") != OK:
		push_error("panel failed to connect")

# Public: Called when the new save slot button is pressed
func _on_new_slot_pressed() -> void:
	enable_save_button()
	save_slot_handler.cur_slot = 0
	setup_screen.buttons["delete"].disabled = true

# Public: Setup the available buttons when save slot is pressed
#
# button = Contain's the button object that was pressed
#
# Example
#	_on_save_slot_pressed(button.tscn)
func _on_save_slot_pressed(button: Button) -> void:
	enable_save_button()
	save_slot_handler.cur_slot = button.get_index()
	setup_screen.buttons["delete"].disabled = false

# Internal: Enables the save buttion if it was disabled
func enable_save_button() -> void:
	if setup_screen.buttons["save"].disabled == true:
		setup_screen.buttons["save"].disabled = false

# Internal: Updates the name and position of the selected save slot
#
# file_name = Contains the save file path
#
# Example
#	update_save_slot("user://1634645541.save")
func update_save_slot() -> void:
	update_data()
	file_handler.remove_save_file_by_index(save_slot_handler.cur_slot - 1)
	file_handler.open_save_file(file_handler.temp_save_file, data)
	save_slot_handler.move_current_save_slot_to_top()

# Public: Called when save button is pressed to ether create or update a save slot
func _on_save_pressed() -> void:
	var file_name = file_handler.create_save_file_name()

	if file_name == null:
		return

	if save_slot_handler.cur_slot == 0:
		popup.set_default_text(save_slot_handler.create_slot_name_using_file_name(file_name))
		popup.popup_centered()
	else:
		update_save_slot()

# Called when the delete button is pressed to delete the selected save slot
func _on_delete_pressed() -> void:
	file_handler.remove_save_file_by_index(save_slot_handler.cur_slot - 1)
	save_slot_handler.remove_current_save_slot()

	if save_slot_handler.cur_slot == 0:
		setup_screen.buttons["delete"].disabled = true

# Public: Has a new save slot and file create using the name entered by player
#
# name = The name of the save slot
#
# Example
#	_on_popup_file_name("TEST")
func _on_popup_file_name(name:String) -> void:
	save_slot_handler.create_save_slot(name)
	update_data(name)
	file_handler.open_save_file(file_handler.temp_save_file, data)

	popup.hide()

	slots.get_child(1).pressed = true
	slots.get_child(1).grab_focus()

# Public: Calls for the screen to be refreshed when sceen becomes visable
func _on_visibility_changed() -> void:
	if self.visible:
		refresh_screen()

# Internal: Updates the delete and save buttons disable property
func update_save_delete_buttons(disabled:bool) -> void:
	setup_screen.buttons["delete"].disabled = disabled
	setup_screen.buttons["save"].disabled = disabled

# Internal: Called for the save slots to be reloaded
func refresh_screen() -> void:
	file_handler.refresh_save_files_list()
	save_slot_handler.refresh_save_slots()
	update_save_delete_buttons(true)

# Internal: Called to update the data dictonary with current game information
#
# save_slot_name = Contains the name of the save slot. (String) (Optional)
#
# Example
#	update_data("TEST")
#
#	update_data()
func update_data(save_slot_name = null) -> void:
	#data[ResourceSaver.save("res://data/scenes/Resoruces.gd", player)]
	#data["global_transform"] = player.global_transform
	data["current_scene"] = get_tree().current_scene.filename
	data["health"] = player_data.health
	data["ammo_mk"] = player_data.ammo_mk
	data["ammo_gl"] = player_data.ammo_gl
	data["ammo_kr"] = player_data.ammo_kr
	data["ammo_tst"] = player_data.ammo_tst
	data["bullets_mk"] = player_data.bullets_mk
	data["bullets_gl"] = player_data.bullets_gl
	data["bullets_kr"] = player_data.bullets_kr
	data["bullets_tst"] = player_data.bullets_tst
	data["global_transform"] = player.global_transform
	#saves information from the current game to file

	if save_slot_name:
		data["save_slot"] = save_slot_name
	else:
		# Subtract one from current slot to match the save file list array witch starts at zero
		var loaded_data = file_handler.load_save_file_by_index(save_slot_handler.cur_slot - 1)
		data["save_slot"] = loaded_data["save_slot"]

# Public: Called when need to switch to another panel
func switch_panel(func_prop) -> void:
	emit_signal("update_menu_controller", "switch_panel", func_prop)

