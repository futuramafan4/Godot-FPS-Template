extends Area

export (Resource) var player_data

func _on_Area_body_entered(body):
	if body.has_method("get_hurt"):
		if player_data.health < 10:
			body.get_hurt(-10);
			queue_free()
