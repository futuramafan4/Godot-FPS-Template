extends KinematicBody

class_name Player
# All speed variables
var n_speed : float = 12; # Normal
var s_speed : float = 16; # Sprint
var w_speed : float = 14; # Walking
var c_speed : float = 10; # Crouch

# Physics variables
var gravity      : float = 50; # Gravity force
var jump_height  : float = 17; # Jump height
var friction     : float = 25; # friction

# All vectors
var velocity     : = Vector3(); # Velocity vector
var direction    : = Vector3(); # Direction Vector
var acceleration : = Vector3(); # Acceleration Vector

export (Resource) var player_data

onready var GRAVITY = ProjectSettings.get("physics/3d/default_gravity") / 1000

#export (int) var max_health = 100
var current_health 
#
# All character inputs
var input : Dictionary = {};

func _physics_process(_delta) -> void:
	# Function for movement
	_movement(_delta);
	
	# Function for crouch
	_crouch(_delta);
	
	# Function for jump
	_jump(_delta);
	
	# Function for sprint
	_sprint(_delta)
	
	
#	self.blend_animations()
	

func _movement(_delta) -> void:
	# Inputs
	input["left"]   = int(Input.is_action_pressed("KEY_Left"));
	input["right"]  = int(Input.is_action_pressed("KEY_Right"));
	input["foward"] = int(Input.is_action_pressed("KEY_Forward"));
	input["back"]   = int(Input.is_action_pressed("KEY_Back"));
	
	# Check is on floor
	if is_on_floor():
		direction = Vector3();
	else:
		direction = direction.linear_interpolate(Vector3(), friction * _delta);
		
		# Applies gravity
		velocity.y += -gravity * _delta;
	
	var basis = $"head".global_transform.basis;
	direction += (-input["left"]    + input["right"]) * basis.x;
	direction += (-input["foward"]  +  input["back"]) * basis.z;
	
	direction.y = 0; direction = direction.normalized()
	
	# Interpolates between the current position and the future position of the character
	var target = direction * n_speed; direction.y = 0;
	var temp_velocity = velocity.linear_interpolate(target, n_speed * _delta);
	
	# Applies interpolation to the velocity vector
	velocity.x = temp_velocity.x;
	velocity.z = temp_velocity.z;
	
	# Calls the motion function by passing the velocity vector
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), false, 4, PI/4, false);

#func blend_animations():
#	animation_tree["parameters/run/blend_position"] = -direction.z
#	animation_tree["parameters/strafe/blend_position"] = direction.x

func _crouch(_delta) -> void:
	# Inputs
	input["crouch"] = int(Input.is_action_pressed("KEY_Crouch"));
	
	# Get the character's head node
	var head = $"head";
	
	# If the head node is not touching the ceiling
	if not head.is_colliding():
		# Takes the character collision node
		var collision = $"collision";
		
		# Get the character's collision shape
		var shape = collision.shape.height;
		
		# Changes the shape of the character's collision
		shape = lerp(shape, 2 - (input["crouch"] * 1.5), c_speed  * _delta);
		
		# Apply the new character collision shape
		collision.shape.height = shape;

func _jump(_delta) -> void:
	# Inputs
	input["jump"] = int(Input.is_action_pressed("KEY_Jump"));
	
	# Makes the player jump if he is on the ground
	if input["jump"]:
		if is_on_floor():
			velocity.y = jump_height;

func _sprint(_delta) -> void:
	# Inputs
	input["sprint"] = int(Input.is_action_pressed("KEY_Sprint"));
	
	# Make the character sprint
	if not input["crouch"]: # If you are not crouching
		# switch between sprint and walking
		var toggle_speed : float = w_speed + ((s_speed - w_speed) * input["sprint"])
		
		# Create a character speed interpolation
		n_speed = lerp(n_speed, toggle_speed, 3 * _delta);
	else:
		# Create a character speed interpolation
		n_speed = lerp(n_speed, w_speed, _delta);
	
#		self.blend_animations()

func get_hurt(damage):
	player_data.health -= damage

func gain_ammo_mk(pickup):
	player_data.ammo_mk += pickup

func gain_ammo_gl(pickup):
	player_data.ammo_gl += pickup
	
func gain_ammo_kr(pickup):
	player_data.ammo_kr += pickup
	
func gain_ammo_tst(pickup):
	player_data.ammo_tst += pickup
#these functions pass on the information to playerdata, so that we can add or subtract ammo/health
#this allows enemys to do damage, along with the player to pickup ammo/health packs
