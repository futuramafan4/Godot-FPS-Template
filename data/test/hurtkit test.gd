extends Area

export (int) var damage = 9
onready var get_hurt = get_node("/root/L_Main/character")


func _on_Area_body_entered(body):
	body.get_node("character").get_hurt(4)
	queue_free()
#	body.get_hurt(4);
#	body.get_hurt(4);
