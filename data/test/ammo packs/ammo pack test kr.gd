extends Area

export (Resource) var player_data

func _on_Area_body_entered(body):
	if body.has_method("gain_ammo_kr"): #check to make sure whatever body is touching the ammo pack has the method gain ammo kr
#		if player_data.ammo_kr < 200:
			body.gain_ammo_kr(100); #add 100 ammo(up to the maximum set in player_data
			queue_free()#delete from the map
