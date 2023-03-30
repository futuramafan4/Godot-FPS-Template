extends Area

export (Resource) var player_data

func _on_PainFloor_body_entered(body):
	if body.has_method("get_hurt"):
			body.get_hurt(100000);
			# this floor hurts a lot. Basically this is made to kill the player if they fall of the map.
