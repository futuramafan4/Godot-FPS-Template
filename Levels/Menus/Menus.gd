extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
export (String, FILE, "*.tscn") var play_scene

func _on_New_Game_pressed():
	get_tree().change_scene(play_scene)
#	get_tree().change_scene("res://Levels/Test Level/L_Main.tscn")
	
func _on_Options_pressed():
	get_tree().change_scene("res://Levels/Menus/Options.tscn")
	
func _on_Load_pressed():
	pass # Replace with function body.

func _on_Exit_pressed():
	get_tree().quit()





