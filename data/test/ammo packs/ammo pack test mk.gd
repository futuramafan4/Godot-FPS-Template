extends Area

export (Resource) var player_data

func _on_Area_body_entered(body):
	if body.has_method("gain_ammo_mk"):
#		if player_data.ammo_mk < 200:
			body.gain_ammo_mk(100);
			queue_free()
