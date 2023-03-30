extends CanvasLayer


export(NodePath) var weapon;
export(NodePath) var weapon_hud;
export(NodePath) var crosshair;
export (Resource) var player_data

func _ready():	
	weapon = get_node(weapon);
	weapon_hud = get_node(weapon_hud);
	crosshair = get_node(crosshair);
	player_data.connect("updated", self, "update_interface")
	player_data.connect("died", self, "_on_player_died")
	
	update_interface()

func _process(_delta) -> void:
	_weapon_hud()
	_crosshair()
	update_interface()
	
func update_interface():
	$HealthBar.max_value = player_data.max_health
	$HealthBar.value = player_data.health

func _on_player_died():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://Levels/Menus/Death.tscn")
#when the death signal is triggered (from health hitting zero) change to death screen.


func _weapon_hud() -> void:
	var off = Vector2(180, 80);
	weapon_hud.position = get_viewport().size - off;

	weapon_hud.get_node("name").text = str(weapon.arsenal.values()[weapon.current].name);
	
	if weapon.arsenal.values()[weapon.current].name == "mk_23":
		weapon_hud.get_node("bullets").text = str(player_data.bullets_mk);
		weapon_hud.get_node("ammo").text = str(player_data.ammo_mk);
		
	if weapon.arsenal.values()[weapon.current].name == "glock_17":
		weapon_hud.get_node("bullets").text = str(player_data.bullets_gl);
		weapon_hud.get_node("ammo").text = str(player_data.ammo_gl);
		
	if weapon.arsenal.values()[weapon.current].name == "kriss":
		weapon_hud.get_node("bullets").text = str(player_data.bullets_kr);
		weapon_hud.get_node("ammo").text = str(player_data.ammo_kr);
		
	if weapon.arsenal.values()[weapon.current].name == "test":
		weapon_hud.get_node("bullets").text = str(player_data.bullets_tst);
		weapon_hud.get_node("ammo").text = str(player_data.ammo_tst);
# a less than optimal way of doing it, but it does work
#basicaly the script looks to see what gun we are holding, then looks for the right set of ammo/bullets.
		
		
#	weapon_hud.get_node("bullets").text = str(weapon.arsenal.values()[weapon.current].bullets);
#	weapon_hud.get_node("ammo").text = str(weapon.arsenal.values()[weapon.current].ammo);
		
	# Color
#	if weapon.arsenal.values()[weapon.current].bullets < (weapon.arsenal.values()[weapon.current].max_bullets/4):
#		weapon_hud.get_node("bullets").add_color_override("font_color", Color("#ff0000"));
#	elif weapon.arsenal.values()[weapon.current].bullets < (weapon.arsenal.values()[weapon.current].max_bullets/2):
#		weapon_hud.get_node("bullets").add_color_override("font_color", Color("#dd761b"));
#	else:
#		weapon_hud.get_node("bullets").add_color_override("font_color", Color("#ffffff"));

# this was the code which determined colour in the original version. I didn't bother to rework for the updated hub.

func _crosshair() -> void:
	crosshair.position = get_viewport().size/2;
