extends Node

const SAVES_PATH := "user://"
const SAVE_ENDING := ".save"

var save_files := []
var temp_save_file = null

onready var player = get_tree().get_root().find_node("character", true, false)
# Internal: Returns a list of all files in the save directory
#
# Example
#	list_files_in_save_directory()
#		=> ["user://1634645541.save", ...]
func list_files_in_save_directory() -> Array:
	var list = []
	var dir := Directory.new()
	if dir.open(SAVES_PATH) == OK and dir.list_dir_begin(true) == OK:
		var file_name := dir.get_next()
		while not file_name == "":
			if not dir.current_is_dir() and file_name.ends_with(SAVE_ENDING):
				list.append(file_name)
			file_name = dir.get_next()

	list.sort()
	for file in list:
		list[list.find(file)] = SAVES_PATH + file

	return list

# Internal: Opens a save file to ether save or retrive data
#
# file_name = path to the save file
# write_data = contains the data that will be saved. (Optional)
#
# Example
#	open_save_file("user://1634645541.save", "FIRE")
#		=> null
#
#	open_save_file("user://1634645541.save")
#		=> "FIRE"
#
# Returns Variant
func open_save_file(file_name:String, write_data = null):
	var data = {
		"global_transform" : player.global_transform
		
	}
	
	
	var beta = null
	var file = null

	if save_files.has(file_name) == false:
		save_files.push_front(file_name)

	if write_data:
		file = open_file(file_name, File.WRITE)
		file.store_var(write_data)

	else:
		file = open_file(file_name, File.READ)
		data = file.get_var()
	#	beta = file.get_var()

	file.close()
	return data

# Internal: Opens the provided file path with the provided mode
#
# file_name = path to the file
# mode_flag = determice if the open file is being read or writen to. (ModeFlags)
#
# Example
#	open_file("user://1634645541.save", File.WRITE)
#		= File.new()
func open_file(file_name:String, mode_flag) -> File:
	var file := File.new()
	if file.open(file_name, mode_flag) != OK:
		push_error("Failed to open save file")

	return file

# Public: Remove the save file and path by the save files index
func remove_save_file_by_index(index:int) -> void:

	var dir := Directory.new()

	if dir.remove(save_files[index]) != OK:
		push_error("Failed to remove save file")

	save_files.remove(index)

# Internal: Addes a new save file to the front the of the save files list
#
# Example
#	create_save_file_name()
#		=> "1637083225"
#
#	create_save_file_name()
#		=> null
#
# Returns String or Null
func create_save_file_name():
	var file_name = str(OS.get_unix_time())
	temp_save_file = SAVES_PATH + file_name + SAVE_ENDING

	if save_files.has(temp_save_file):
		return null

	return file_name

# Public: Removes and loads a new save files list
func refresh_save_files_list() -> void:
	save_files = list_files_in_save_directory()
	save_files.invert()

# Public: Returns the save data for the save file determined by the index number.
#
# Returns Variant
func load_save_file_by_index(index:int):
	return open_save_file(save_files[index])
