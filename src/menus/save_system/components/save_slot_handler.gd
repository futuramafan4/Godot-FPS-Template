extends Node

const SAVE_TEXT := "%02d/%02d/%02d %02d:%02d:%02d"

var cur_slot := -1
var slots = null
var screen = null

func _init(save_slot_screen, save_slots):
	screen = save_slot_screen
	slots = save_slots

# Internal: Creates a save slot button usring the provided save file name
#
# file_name = Contains the file name thats used to generate the save slot button
#
# Example
#	create_save_slot_button("user://1634645541.save")
func create_save_slot_button(slot_name:String) -> void:
	var b := Button.new()
	slots.add_child(b)
	b.text = slot_name
	b.toggle_mode = true
	b.group = slots.get_child(0).group
	if b.connect("pressed", screen, "_on_save_slot_pressed", [b]) != OK:
		push_error("Save slot failed to connect")

# Internal: Generates the save slot name from the provided file name
#
# file_name = Contains the file name thats used to generate the slot name
#
# Example
#	create_slot_name_using_file_name("634645541")
#		=> 2021/10/19 12:12:21
func create_slot_name_using_file_name(file_name:String) -> String:
	var date := OS.get_datetime_from_unix_time(int(file_name))
	return SAVE_TEXT % [date.year, date.month, date.day, date.hour, date.minute, date.second]

# Internal: Calls for a save slot to be created and added to Scroll list
#
# file_name = Contains the save file path
#
# Example
#	create_save_slot("user://1634645541.save")
func create_save_slot(name:String) -> void:
	create_save_slot_button(name)
	slots.move_child(slots.get_child(slots.get_child_count()-1), 1)

# Internal: Updates the name and position of the selected save slot
#
# file_name = Contains the save file path
#
# Example
#	update_save_slot("user://1634645541.save")
func move_current_save_slot_to_top() -> void:
	slots.move_child(slots.get_child(cur_slot), 1)
	cur_slot = 1

# Public: Removes the current selected save slot and select the next available.
func remove_current_save_slot() -> void:
	slots.get_child(cur_slot).free()

	if slots.get_child_count() == cur_slot:
		cur_slot = slots.get_child_count() - 1

	slots.get_child(cur_slot).pressed = true

# Internal: Removed all save slots except for the first one.
func remove_all_save_slots() -> void:
	for save_slot in slots.get_children():
		if save_slot.get_index() != 0:
			slots.remove_child(save_slot)
			save_slot.queue_free()

	cur_slot = 0

# Internal: Creates the save slot using the save files list
func load_save_slots() -> void:
	for file_name in screen.file_handler.save_files:
		var loaded_data = screen.file_handler.open_save_file(file_name)
		if loaded_data == null:
			continue

		if loaded_data.has("save_slot"):
			create_save_slot_button(loaded_data["save_slot"])
		else:
			create_save_slot_button(create_slot_name_using_file_name(file_name))

# Public: Has the save slots removed and reloaded from save files list
func refresh_save_slots() -> void:
	remove_all_save_slots()
	load_save_slots()
