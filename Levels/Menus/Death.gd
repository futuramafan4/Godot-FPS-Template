extends Control

export (Resource) var player_data


func _on_New_Game_pressed():
	get_tree().paused = false
	player_data.reset()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	get_tree().change_scene("res://Levels/Test Level/L_Main.tscn")
	pass # Replace with function body.
	
	
func _on_Options_pressed():
	get_tree().change_scene("res://Levels/Menus/Options.tscn")
	


func _on_Exit_pressed():
	get_tree().quit()


func _on_SaveLoad_pressed():
	$load.show()
