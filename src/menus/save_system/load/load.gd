extends PanelContainer

onready var player = get_tree().get_root().find_node("character", true, false)
signal update_menu_controller(func_name, func_prop)
export(Resource) var player_data
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

# Public: Loads the selected save slot's game
func  _on_load_pressed() -> void:
	var loaded_data = file_handler.open_save_file(
		file_handler.save_files[save_slot_handler.cur_slot - 1]
	)
	player_data.health = (loaded_data["health"])
	player_data.ammo_mk = (loaded_data["ammo_mk"])
	player_data.ammo_gl = (loaded_data["ammo_gl"])
	player_data.ammo_kr = (loaded_data["ammo_kr"])
	player_data.ammo_tst = (loaded_data["ammo_tst"])
	player_data.bullets_mk = (loaded_data["bullets_mk"])
	player_data.bullets_gl = (loaded_data["bullets_gl"])
	player_data.bullets_kr = (loaded_data["bullets_kr"])
	player_data.bullets_tst = (loaded_data["bullets_tst"])
	#player.global_transform = (loaded_data["global_transform"])
	get_tree().change_scene(loaded_data["current_scene"])
#	if loaded_data:
#		#	push_error("Unable to load scene from save file")
	get_tree().paused = false
		
func _on_delete_pressed() -> void:
	file_handler.remove_save_file_by_index(save_slot_handler.cur_slot-1)
	save_slot_handler.remove_current_save_slot()

	if save_slot_handler.cur_slot == 0:
		update_load_delete_buttons(true)

# Public: Updated the current slot with the pressed save slot's index
#
# button = Contain's the button object that was pressed
#
# Example
#	_on_save_slot_pressed(button.tscn)
func _on_save_slot_pressed(button: Button) -> void:
	save_slot_handler.cur_slot = button.get_index()
	update_load_delete_buttons(false)

# Public: Called when need to switch to another panel
#
# func_prop = Name of the panel to switch to.
#
# Example
#	switch_panel("pause")
func switch_panel(func_prop:String) -> void:
	emit_signal("update_menu_controller", "switch_panel", func_prop)

# Public: Calls for the screen to be refreshed when sceen becomes visable
func _on_visibility_changed() -> void:
	if self.visible:
		refresh_screen()

# Internal: Updates the delete and load buttons disable property
func update_load_delete_buttons(disabled:bool) -> void:
	setup_screen.buttons["delete"].disabled = disabled
	setup_screen.buttons["load"].disabled = disabled

# Internal: Called for the save slots to be reloaded
func refresh_screen() -> void:
	file_handler.refresh_save_files_list()
	save_slot_handler.refresh_save_slots()
	update_load_delete_buttons(true)
