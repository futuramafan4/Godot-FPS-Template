extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
export (String, FILE, "*.tscn") var play_scene
export (Resource) var player_data

func _ready():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
#	$character/hud.hide()

func _on_New_Game_pressed():
	get_tree().paused = false
	player_data.reset()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	get_tree().change_scene(play_scene)
	
#	get_tree().change_scene("res://Levels/Test Level/L_Main.tscn")
	
func _on_Options_pressed():
	get_tree().change_scene("res://Levels/Menus/Options.tscn")
	
func _on_Load_pressed():
	$load.show()

func _on_Exit_pressed():
	get_tree().quit()





