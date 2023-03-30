extends Control

func _on_New_Game_pressed():

	get_tree().change_scene("res://Levels/Test Level/L_Main.tscn")
	pass # Replace with function body.
	
	
func _on_Options_pressed():
	get_tree().change_scene("res://Levels/Menus/Options.tscn")
	


func _on_Exit_pressed():
	get_tree().quit()
