extends Resource
#Spatial
signal updated
signal died

export (int) var max_health = 10 setget set_max_health
export (int) var health = max_health setget set_health

export (int) var max_ammo = 100 setget set_max_ammo
export (int) var ammo = max_ammo setget set_ammo

export (int) var max_ammo_mk = 200 setget set_max_ammo_mk
export (int) var ammo_mk = max_ammo_mk setget set_ammo_mk
export (int) var max_ammo_gl = 200 setget set_max_ammo_gl
export (int) var ammo_gl = max_ammo_gl setget set_ammo_gl
export (int) var max_ammo_kr = 200 setget set_max_ammo_kr
export (int) var ammo_kr = max_ammo_kr setget set_ammo_kr
export (int) var max_ammo_tst = 200 setget set_max_ammo_tst
export (int) var ammo_tst = max_ammo_tst setget set_ammo_tst
#sets the max ammo for each weapon. Starting ammo is set in the character scene. It appears in the inspector of the weapons node.
#a variable for how many bullets to start will will be needed, but the current method works for testing

export (int) var max_bullets_mk = 12 setget set_max_bullets_mk #basically sets the maximum number of bullets in the magazine
export (int) var bullets_mk = max_bullets_mk setget set_bullets_mk #bullets_mk keeps track of how many pullets left in the magazine
export (int) var max_bullets_gl = 12 setget set_max_bullets_gl
export (int) var bullets_gl = max_bullets_gl setget set_bullets_gl
export (int) var max_bullets_kr = 32 setget set_max_bullets_kr
export (int) var bullets_kr = max_bullets_kr setget set_bullets_kr
export (int) var max_bullets_tst = 22 setget set_max_bullets_tst
export (int) var bullets_tst = max_bullets_tst setget set_bullets_tst


#func reset():
#	health = max_health
#	ammo = max_ammo
#	ammo_mk = max_ammo_mk
#	ammo_gl = max_ammo_gl
#	ammo_kr = max_ammo_kr
#	ammo_tst = max_ammo_tst
#	emit_signal("updated")
#Will be used to reset the numbers to maximum value, or starting value when that is implemented as a seporate variable
#Will be used for the "restart game" option

func set_max_health(new_max_health):
	max_health = new_max_health
	emit_signal("updated")


func set_health(new_health):
	health = clamp(new_health, 0, max_health)
	if health < 1:
		emit_signal("died") #signals the game to show the death screen
	emit_signal("updated")
#used to keep track of current health

func set_max_ammo_mk(new_max_ammo_mk):
	max_ammo_mk = new_max_ammo_mk
	emit_signal("updated")
# basically resets the values to max

func set_ammo_mk(new_ammo_mk):
	ammo_mk = clamp(new_ammo_mk, 0, max_ammo_mk)
	emit_signal("updated")
	
func set_max_bullets_mk(new_max_bullets_mk):
	max_bullets_mk = new_max_bullets_mk
	emit_signal("updated")

func set_bullets_mk(new_bullets_mk):
	bullets_mk = clamp(new_bullets_mk, 0, max_bullets_mk)
	emit_signal("updated")

func set_max_ammo_gl(new_max_ammo_gl):
	max_ammo_gl = new_max_ammo_gl
	emit_signal("updated")

func set_ammo_gl(new_ammo_gl):
	ammo_gl = clamp(new_ammo_gl, 0, max_ammo_gl)
	emit_signal("updated")

func set_max_bullets_gl(new_max_bullets_gl):
	max_bullets_gl = new_max_bullets_gl
	emit_signal("updated")

func set_bullets_gl(new_bullets_gl):
	bullets_gl = clamp(new_bullets_gl, 0, max_bullets_gl)
	emit_signal("updated")

func set_max_ammo_kr(new_max_ammo_kr):
	max_ammo_kr = new_max_ammo_kr
	emit_signal("updated")

func set_ammo_kr(new_ammo_kr):
	ammo_kr = clamp(new_ammo_kr, 0, max_ammo_kr)
	emit_signal("updated")

func set_max_bullets_kr(new_max_bullets_kr):
	max_bullets_kr = new_max_bullets_kr
	emit_signal("updated")

func set_bullets_kr(new_bullets_kr):
	bullets_kr = clamp(new_bullets_kr, 0, max_bullets_kr)
	emit_signal("updated")

func set_max_ammo_tst(new_max_ammo_tst):
	max_ammo_tst = new_max_ammo_tst
	emit_signal("updated")

func set_ammo_tst(new_ammo_tst):
	ammo_tst = clamp(new_ammo_tst, 0, max_ammo_tst)
	emit_signal("updated")

func set_max_bullets_tst(new_max_bullets_tst):
	max_bullets_tst = new_max_bullets_tst
	emit_signal("updated")

func set_bullets_tst(new_bullets_tst):
	bullets_tst = clamp(new_bullets_tst, 0, max_bullets_tst)
	emit_signal("updated")

func set_max_ammo(new_max_ammo):
	max_ammo = new_max_ammo
	emit_signal("updated")

func set_ammo(new_ammo):
	ammo = clamp(new_ammo, 0, max_ammo)
	emit_signal("updated")
