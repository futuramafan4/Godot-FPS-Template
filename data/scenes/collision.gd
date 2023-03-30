extends CollisionShape

export (Resource) var player_data

func _on_collision_area_entered(area):
	get_hurt(area.damage)
	pass # Replace with function body.

#func _on_Invulnerability_timeout():
#	$CollisionShape2D.disabled = false


func get_hurt(damage):
	player_data.health -= damage



