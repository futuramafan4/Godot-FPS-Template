extends Area

export (Resource) var player_data

func _on_Area_body_entered(body):
	if body.has_method("gain_ammo_tst"):
#		if player_data.ammo_tst < 200:
			body.gain_ammo_tst(100);
			queue_free()
