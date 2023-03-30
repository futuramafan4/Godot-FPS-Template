tool
extends EditorPlugin

var menus

func _enter_tree():
	add_custom_type("Menus", "Control", preload("res://addons/menusplugin/menus.gd"), preload("res://addons/menusplugin/menus_icon.png"))




func _exit_tree():
	remove_custom_type("Menus")
