extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	# if the escape key is pressed, pause the game and show the pause menue. Then make mouse visable.
	
func _on_Pause_pressed():
	get_tree().paused = false
	hide()
	
func _on_Exit_pressed():
	get_tree().quit()
func _on_Save_pressed():
#	$VBC_Main2/VBoxContainer.hide()
#	$VBC_Main2/CenterContainer.hide()
#	$Panel2.hide()
	$save.show()

	
func _on_Restart_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Levels/Test Level/L_Main.tscn")
	
func _on_Options_pressed():
	$VBC_Main2/VBoxContainer.hide()
	$VBC_Main2/CenterContainer.hide()
	$Panel2.hide()
	$Panel.show()
#	$Sprite.show()
	$VBC_Options.show()
	pass # Replace with function body.


func _on_Vsync_toggled(button_pressed):
	OS.vsync_enabled = $VBC_Options/VBoxContainer/V_Sync/Vsync.pressed
#this settings menu isnt connected to the config file like the main menu version.

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = $VBC_Options/VBoxContainer/Display_lbl/Fullscreen.pressed

func _on_Back_pressed():
	$VBC_Main2/VBoxContainer.show()
	$VBC_Main2/CenterContainer.show()
	$Panel2.show()
	$Panel.hide()
#	$Sprite.hide()
	$VBC_Options.hide()


func _on_Load_pressed():
	#$VBC_Main2/VBoxContainer.hide()
	#$VBC_Main2/CenterContainer.hide()
	#$Panel2.hide()
	$load.show()
