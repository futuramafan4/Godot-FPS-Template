extends Control

#var Fullscreen_on = true
const VOLUME_FRACTIONS := 50

#Attach everything to a variable;
onready var master_volume := $VBC_Options/VBoxContainer/MasterVolume/MasterVolume
onready var vsync = $VBC_Options/VBoxContainer/V_Sync/Vsync
onready var Fullscreen = $VBC_Options/VBoxContainer/Display_lbl/Fullscreen

func _ready():
	master_volume.max_value = VOLUME_FRACTIONS
	master_volume.value = UserData.get_config("master_volume") * VOLUME_FRACTIONS
	Fullscreen.pressed = UserData.get_config("Fullscreen")
	vsync.pressed = UserData.get_config("vsync")
	
func _on_HSlider_value_changed(value):
	UserData.save_config("master_volume", value/VOLUME_FRACTIONS)
	
func _on_Vsync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	UserData.save_config("Vsync", button_pressed)

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	UserData.save_config("Fullscreen", button_pressed)


func _on_Apply_pressed():
	pass

func _on_Back_pressed():
	get_tree().change_scene("res://Levels/Menus/Menus.tscn")
