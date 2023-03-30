extends Spatial

export(NodePath) var character;

const CAMERA_TURN_SPEED = 200

export var sensibility : float = 0.2;  # Mouse sensitivity
export var captured : bool = true; # Does not let the mouse leave the screen

func _ready():
	character = get_node(character);

func _physics_process(_delta) -> void:
	# Calls function to switch between locked and unlocked mouse
	_mouse_toggle();

func _mouse_toggle() -> void:
	# Function to lock or unlock the mouse in the center of the screen
	if Input.is_action_just_pressed("KEY_ESCAPE"):
		# Captured will receive the opposite of the value itself
		captured = !captured;
	
	if captured:
		# Locks the mouse in the center of the screen
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	else:
		# Unlocks the mouse from the center of the screen
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


func look_updown_rotation(rotation = 0):
	"""
	Returns a new Vector3 which contains only the x direction
	We'll use this vector to compute the final 3D rotation later
	"""
	var toReturn = self.get_rotation() + Vector3(rotation, 0, 0)

	##
	## We don't want the player to be able to bend over backwards
	## neither to be able to look under their arse.
	## Here we'll clamp the vertical look to 90° up and down
	toReturn.x = clamp(toReturn.x, PI / -2, PI / 2)

	return toReturn

func look_leftright_rotation(rotation = 0):
	"""
	Returns a new Vector3 which contains only the y direction
	We'll use this vector to compute the final 3D rotation later
	"""
	return character.get_rotation() + Vector3(0, rotation, 0)




#func _camera_rotation(_event) -> void:
#	# If the mouse is locked
#	if captured:
#		var camera : Dictionary = {0: $".", 1: $"."};
#
#		if _event is InputEventMouseMotion:
#			# Rotates the camera on the x axis
#			#camera[0].rotation.x += -deg2rad(_event.relative.y * sensibility);
#
#			# Rotates the camera on the y axis
#			camera[1].rotation.y += -deg2rad(_event.relative.x * sensibility);
#
#		# Creates a limit for the camera on the x axis
#		var max_angle: int = 85; # Maximum camera angle
#		camera[0].rotation.x = min(camera[0].rotation.x,  deg2rad(max_angle))
#		camera[0].rotation.x = max(camera[0].rotation.x, -deg2rad(max_angle))


func _input(event):
	"""
	First person camera controls
	"""
	##
	## We'll only process mouse motion events
	if not event is InputEventMouseMotion:
		return

	##
	## We'll use the parent node "Player" to set our left-right rotation
	## This prevents us from adding the x-rotation to the y-rotation
	## which would result in a kind of flight-simulator camera
	character.set_rotation(look_leftright_rotation(event.relative.x / -CAMERA_TURN_SPEED))

	##
	## Now we can simply set our y-rotation for the camera, and let godot
	## handle the transformation of both together
	self.set_rotation(look_updown_rotation(event.relative.y / -CAMERA_TURN_SPEED))



#func _input(_event) -> void:
#	# Calls the function to rotate the camera
#	_camera_rotation(_event);
