extends KinematicBody

export var durability : int = 100;

func _damage(damage) -> void:
	if durability > 0:
		var dam_calc = durability - damage;
		
		if dam_calc <= 0:
			durability -= damage;
			queue_free()
		else:
			durability -= damage;

