extends Area

export (Resource) var player_data

func _on_Area_body_entered(body):
	if body.has_method("gain_ammo_gl"):
#		if player_data.ammo_gl < 200:
			body.gain_ammo_gl(100);
			queue_free()
