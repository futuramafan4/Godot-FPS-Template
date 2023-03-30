tool
extends Control
signal options_difficulty(difficulty)
signal options_vfx(vfx_on)
signal options_music(music_on)
signal options_sfx(sfx_on)



var _menu = preload("res://addons/menusplugin/menus_icon.png")
var _menus = preload("res://addons/menusplugin/Menus.tscn")
var menus
var panel_bg_colors = StyleBoxFlat.new()
var font_bg_colors = StyleBoxFlat.new()
var control_bg_colors = StyleBoxFlat.new()
var control_hover_bg_colors = StyleBoxFlat.new()
var control_pressed_bg_colors = StyleBoxFlat.new()
var control_normal_bg_colors = StyleBoxFlat.new()
var button_hover_bg_colors = StyleBoxFlat.new()
var button_pressed_bg_colors = StyleBoxFlat.new()
var button_normal_bg_colors = StyleBoxFlat.new()

var _slot = preload("res://addons/menusplugin/Slot.tscn")
var slots_available : int = 10
var slot_number : int

var difficulty
var easy_on
var medium_on
var hard_on
var fullscreen_on = true
var vfx_on
var music_on
var sfx_on

export (Texture)  var  texture = preload("res://addons/menusplugin/image_placeholder.png")
export var title_border:int = 0
export (Color)  var  panel_color = Color(0.13,0.13,0.13,1 )
export (Color)  var font_colors = Color( 1, 1, 1, 1 )
export (Color) var control_hover_colors = Color( 0.77, 0.87, 0.99, 1 )
export (Color) var control_pressed_colors = Color( 0.08, 0.48, 0.93, 1 )
export (Color) var control_normal_colors = Color( 0.42, 0.65, 0.91, 1)
export var new_game : String = "Copy path to the actioal game scene here, inside of quotsation marks"
export(String, MULTILINE) var _credits = "Game credits."



func _ready():
	menus = _menus.instance()
	if check_if_config_exits() == true:
		load_config()
	else:
		create_config_file()
	yield(get_tree(),"idle_frame")
	panel_bg_colors.set_bg_color(Color(panel_color))
	menus.get_node("TextureRect").texture = texture
	menus.get_node("Panel").set("custom_styles/panel", panel_bg_colors)
	add_child(menus)
	menus.get_node("Sprite").frame = title_border
	menus.get_node("Sprite").modulate = Color( 0.42, 0.65, 0.91, 1)
	connection_settings()
	menus.get_node("VBC_Credits/VBoxContainer/Credits").text = _credits
	#// Not in use yet, still working on it.
	create_save_game_slot()
	#/////////////////////////////////////////
		
		
		
			
#Sets All Control's Signal connections
func connection_settings():

	#//Main Menu
	for button_main in get_tree().get_nodes_in_group("buttons_main"):
		button_main.connect("pressed", self, "_buttons_main_pressed",[button_main.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		button_main.set("custom_styles/hover", control_hover_bg_colors)
		button_main.set("custom_styles/pressed", control_pressed_bg_colors)
		button_main.set("custom_styles/normal", control_normal_bg_colors)
		button_main.rect_size.y = 32
		
		
		
	#//Options Menu
	for radio_option in get_tree().get_nodes_in_group("radios_option"):
		radio_option.connect("pressed", self, "_radios_option_pressed",[radio_option.pressed, radio_option.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		radio_option.set("custom_styles/hover", control_hover_bg_colors)
		radio_option.set("custom_styles/pressed", control_pressed_bg_colors)
		radio_option.set("custom_styles/normal", control_normal_bg_colors)
		
	for checkbox_option in get_tree().get_nodes_in_group("checkboxes_option"):
		checkbox_option.connect("pressed", self, "_checkboxes_option_pressed",[checkbox_option.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		checkbox_option.set("custom_styles/hover", control_hover_bg_colors)
		checkbox_option.set("custom_styles/pressed", control_pressed_bg_colors)
		checkbox_option.set("custom_styles/normal", control_normal_bg_colors)
		
	for button_option in get_tree().get_nodes_in_group("buttons_option"):
		button_option.connect("pressed", self, "_button_option_pressed",[button_option.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		button_option.set("custom_styles/hover", control_hover_bg_colors)
		button_option.set("custom_styles/pressed", control_pressed_bg_colors)
		button_option.set("custom_styles/normal", control_normal_bg_colors)
		button_option.rect_size.y = 32
		
		
	#// Not in use yet, still working on it
	#// Save/Load Menu
	
#	for slot_saveload in get_tree().get_nodes_in_group("slots"):
#		slot_saveload.connect("pressed", self, "_slot_saveload_pressed",[slot_saveload.name])
		
	for button_saveload in get_tree().get_nodes_in_group("buttons_saveload"):
		button_saveload.connect("pressed", self, "_button_saveload_pressed",[button_saveload.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		button_saveload.set("custom_styles/hover", control_hover_bg_colors)
		button_saveload.set("custom_styles/pressed", control_pressed_bg_colors)
		button_saveload.set("custom_styles/normal", control_normal_bg_colors)
	#/////////////////////////////////////////
		
		
		
	#// Credits Menu
	for button_credit in get_tree().get_nodes_in_group("buttons_credit"):
		button_credit.connect("pressed", self, "_button_credit_pressed",[button_credit.name])
		control_hover_bg_colors.set_bg_color(Color(control_hover_colors))
		control_pressed_bg_colors.set_bg_color(Color(control_pressed_colors))
		control_normal_bg_colors.set_bg_color(Color(control_normal_colors))
		button_credit.set("custom_styles/hover", control_hover_bg_colors)
		button_credit.set("custom_styles/pressed", control_pressed_bg_colors)
		button_credit.set("custom_styles/normal", control_normal_bg_colors)
#///////////////////////////////////////////////////////////////////////
		
		
		
		
	#//Main Menu Control Signals
func  _buttons_main_pressed(button_main_name):
	if button_main_name == "New Game":
		menus.get_node("VBC_Main").visible = false
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
		get_tree().change_scene(new_game)
	elif button_main_name == "Options":
		menus.get_node("VBC_Main").visible = false
		menus.get_node("VBC_Options").visible = true
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
	elif button_main_name == "SaveLoad":
		menus.get_node("VBC_Main").visible = false
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
		pass
	elif button_main_name == "Credits":
		menus.get_node("VBC_Main").visible = false
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = true
	elif button_main_name == "Exit":
		get_tree().quit()
		
	#//////////////////////////////////////////////////
	
	
	
	
#//Options Menu Control Signals
func _radios_option_pressed(button_pressed, radio_option_name):
	for radio in get_tree().get_nodes_in_group("radios_option"):
		if !radio.pressed:
			radio.pressed = false
	difficulty = radio_option_name
	match(radio_option_name.capitalize()):
			"Easy":
				easy_on = true
				medium_on = false
				hard_on = false
			"Medium":
				easy_on = false
				medium_on = true
				hard_on = false
			"Hard":
				easy_on = false
				medium_on = false
				hard_on = true
	emit_signal("options_difficulty", difficulty)
			

		
func _checkboxes_option_pressed(checkboxes_option_name):
	if checkboxes_option_name == "Fullscreen":
		if fullscreen_on == true:
			OS.set_window_fullscreen(true)
			fullscreen_on = false
		elif fullscreen_on == false:
			OS.set_window_fullscreen(false)
			fullscreen_on = true
	elif checkboxes_option_name == "Vfx":
		if vfx_on == true:
			vfx_on = false
		elif vfx_on == false:
			vfx_on = true
		emit_signal("options_vfx", vfx_on)
	elif checkboxes_option_name == "Music":
		if music_on == true:
			music_on = false
		elif music_on == false:
			music_on = true
		emit_signal("options_music", music_on)
	elif checkboxes_option_name == "Sfx":
		if sfx_on == true:
			sfx_on = false
		elif sfx_on == false:
			sfx_on = true
		emit_signal("options_sfx", sfx_on)
		
func  _button_option_pressed(button_option_name):
	if button_option_name == "Back":
		menus.get_node("VBC_Main").visible = true
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
		save_config()
		yield(get_tree(),"idle_frame")
		load_config()
	#//////////////////////////////////////////////////
	
	
	
	
#// Not in use yet, still working on it
#// Save/Load menu Control Signals
func _slot_saveload_pressed(slot_saveload_name):
	slot_saveload_name.activated = false
	slot_saveload_name.get_node("Title").text = "DONE"
	pass
	
func _button_saveload_pressed(button_saveload_name):
	if button_saveload_name == "Back":
		menus.get_node("VBC_Main").visible = true
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
	#//////////////////////////////////////////////////
	#/////////////////////////////////////////
	
	
	
	
#// Credits menu Control Signals
func  _button_credit_pressed(button_credit_name):
	if button_credit_name == "Back":
		menus.get_node("VBC_Main").visible = true
		menus.get_node("VBC_Options").visible = false
		menus.get_node("VBC_SaveLoad").visible = false
		menus.get_node("VBC_Credits").visible = false
		
		
	#//////////////////////////////////////////////////
	
	
	
#// Not in use yet, still working on it.
func _slot_delete_pressed(slot):
	for slot in get_tree().get_nodes_in_group("slots"):
		pass
	
func create_save_game_slot():
	for slot_available in slots_available:
		if slots_available > 0:
			var slot = _slot.instance()
			slot_number += 1
			slot.get_node("Position").text = str(slot_number)
			slots_available -= 1
			menus.get_node("VBC_SaveLoad/VBoxContainer/ScrollContainer/GridContainer").add_child(slot)
#/////////////////////////////////////////





#// All functions below are functions used by the functions above

#//Saves the configuration file from the Options menu after you cklick its Back button
func save_config():
	var file =  File.new()
	var file_exists = file.file_exists("user://settings.ini")
	if file_exists:
		var config = ConfigFile.new()
		config.set_value("Play", "Difficulty", difficulty)
		config.set_value("Play", "Easy", easy_on)
		config.set_value("Play", "Medium", medium_on)
		config.set_value("Play", "Hard", hard_on)
		config.set_value("Visuals", "Fullscreen", fullscreen_on)
		config.set_value("Visuals", "Vfx", vfx_on)
		config.set_value("Sound", "Music", music_on)
		config.set_value("Sound", "Sfx", sfx_on)
		config.save("user://settings.ini")
		file.close()
		emit_signal("options_difficulty", difficulty)
		emit_signal("options_vfx", vfx_on)
		emit_signal("options_music", music_on)
		emit_signal("options_sfx", sfx_on)
		
		
#//Createa a configuration settings menu for the Options Menu settings
func create_config_file():
	var config = ConfigFile.new()
	config.set_value("Play", "Difficulty", "Easy")
	config.set_value("Play", "Easy", true)
	config.set_value("Play", "Medium", false)
	config.set_value("Play", "Hard", false)
	config.set_value("Visuals", "Fullscreen", true)
	config.set_value("Visuals", "Vfx", true)
	config.set_value("Sound", "Music", true)
	config.set_value("Sound", "Sfx", true)
	config.save("user://settings.ini")
	emit_signal("options_difficulty", difficulty)
	emit_signal("options_vfx", vfx_on)
	emit_signal("options_music", music_on)
	emit_signal("options_sfx", sfx_on)
	yield(get_tree(),"idle_frame")
	load_config()
	
	
#//Loads the configuration settings file for the Options menu settings for the game
func load_config():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("user://settings.ini")

	# If the file didn't load, ignore it.
	if err != OK:
		return

	# Fetch the data for each section.
	difficulty = config.get_value("Play", "Difficulty")
	easy_on = config.get_value("Play", "Easy")
	medium_on = config.get_value("Play", "Medium")
	hard_on = config.get_value("Play", "Hard")
	fullscreen_on = config.get_value("Visuals", "Fullscreen")
	vfx_on = config.get_value("Visuals", "Vfx")
	music_on = config.get_value("Sound", "Music")
	sfx_on = config.get_value("Sound", "Sfx")
	menus.get_node("VBC_Options/VBoxContainer/Difficulty_lbl/Easy").pressed = easy_on
	menus.get_node("VBC_Options/VBoxContainer/Difficulty_lbl/Medium").pressed = medium_on
	menus.get_node("VBC_Options/VBoxContainer/Difficulty_lbl/Hard").pressed = hard_on
	menus.get_node("VBC_Options/VBoxContainer/Display_lbl/Fullscreen").pressed = fullscreen_on
	menus.get_node("VBC_Options/VBoxContainer/Visuals_lbl/Vfx").pressed = vfx_on
	menus.get_node("VBC_Options/VBoxContainer/Music_lbl/Music").pressed = music_on
	menus.get_node("VBC_Options/VBoxContainer/Sfx_lbl/Sfx").pressed = sfx_on
	emit_signal("options_difficulty", difficulty)
	emit_signal("options_vfx", vfx_on)
	emit_signal("options_music", music_on)
	emit_signal("options_sfx", sfx_on)

func check_if_config_exits() -> bool:
	var file =  File.new()
	var file_exists = file.file_exists("user://settings.ini")
	file.close()
	if file_exists:
		return true
	return false
