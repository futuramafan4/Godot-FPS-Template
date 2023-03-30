extends StaticBody

# The path to the turret root node (needed to send the signal pack up)
export (NodePath) var path_to_turret_root
var hurt
func _ready():
	pass

func _damage(damage) -> void:
		hurt = damage * 10
		
		get_node(path_to_turret_root).bullet_hit(hurt)
