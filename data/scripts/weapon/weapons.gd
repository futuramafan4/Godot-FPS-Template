extends Spatial

# Get character's node path
export(NodePath) var character;

# Get head's node path
export(NodePath) var head;

# Get camera's node path
export(NodePath) var neck;

# Get camera's node path
export(NodePath) var camera;

export (Resource) var player_data


#var anim = owner.get_node("{}/mesh/anim".format([name], "{}"));
# Load weapon class for make weapons
var weapon = load("res://data/scripts/weapon/weapon.gd");

# All weapons
var arsenal : Dictionary;

# Current weapon
var current : int = 0;

var max_bullets = 975
var clip_mk = 12
var clip_gl = 12
var clip_kr = 32
var clip_tst = 22

# Dict of inputs
var input : Dictionary = {};

func _ready() -> void:
	set_as_toplevel(true);
	
	# Get camera node from path
	camera = get_node(camera);
	
	# Get neck node from path
	neck = get_node(neck);
	
	# Get head node from path
	head = get_node(head);
	
	# Get head node from path
	character = get_node(character);
	
	
	# Class reference : 
	# owner, name, firerate, ammo, damage, reload_speed;
	#				2.0,     950,    40,     1.2)
	# Create mk 23 using weapon classs
	arsenal["mk_23"] = weapon.weapon.new(self, "mk_23", 2.0, 950, 40, 1.2);
	
	# Create glock 17 using weapon class
	arsenal["glock_17"] = weapon.weapon.new(self, "glock_17", 3.0, 999, 35, 1.2);
	
	# Create kriss using weapon class
	arsenal["kriss"] = weapon.weapon.new(self, "kriss", 6.0, 999, 25, 1.5);
	
	arsenal["test"] = weapon.weapon.new(self, "test", 3.0, 130, 250, 5);
	
	for w in arsenal:
		arsenal.values()[current]._hide();

func _physics_process(_delta) -> void:
	# Call weapon function
	_weapon(_delta);
	_change();
	_position(_delta);

func _weapon(_delta) -> void:
	var anim = arsenal.values()[current].anim
	input["shoot"] = int(Input.is_action_pressed("mb_Shoot"));
	input["reload"] = int(Input.is_action_pressed("KEY_Reload"));
	input["zoom"] = int(Input.is_action_pressed("mb_Zoom"));
	
	arsenal.values()[current]._sprint(character.input["sprint"] or character.input["jump"], _delta);
	
	if not character.input["sprint"] or not character.direction:
		if input["shoot"]: #originally this information was kept in weapon.gd, but had to be moved here so data can be passed on to the resources file.
			#_shoot(_delta);
			if not anim.is_playing():  #prevents us from shooting when other animations are playing. Doesn't always work, but at least it prevents missfires most of the time.
				if arsenal.values()[current].name == "mk_23": 
					if player_data.bullets_mk > 0:
						#self.camera.rotation.x = lerp(self.camera.rotation.x, rand_range(1, 2), _delta);
						#self.camera.rotation.y = lerp(self.camera.rotation.y, rand_range(-1, 1), _delta);
						#commented out things from this section are related to experimentation
						anim.play("Shoot", 0, 2); #plays annimation, moved here, as it glitched when in the weapon.gd script.
						arsenal.values()[current]._shoot(_delta) #executes the _shoot part of weapon.gd
						#yield(get_tree().create_timer(0.4), "timeout")
						player_data.bullets_mk -= 1;
	#					print("fire")

				if arsenal.values()[current].name == "glock_17":
					if player_data.bullets_gl > 0:
						anim.play("Shoot", 0, 3); #second number (3) is the firerate
						arsenal.values()[current]._shoot(_delta)
						player_data.bullets_gl -= 1;
#						print("fire")

				if arsenal.values()[current].name == "kriss":
					if player_data.bullets_kr > 0:
						#self.camera.rotation.x = lerp(self.camera.rotation.x, rand_range(.5, 1), _delta);
						#self.camera.rotation.y = lerp(self.camera.rotation.y, rand_range(-.5, .5), _delta);
						#self.camera.shake_force = 0.002;
						#self.camera.shake_time = 0.2;
						anim.play("Shoot", 0, 6);
						arsenal.values()[current]._shoot(_delta)
						player_data.bullets_kr -= 1;
#						print("fire")

				if arsenal.values()[current].name == "test":
					if player_data.bullets_tst > 0:
						anim.play("Shoot", 0, 3);
						arsenal.values()[current]._shoot(_delta)
						player_data.bullets_tst -= 1;
#						print("fire")
		
		arsenal.values()[current]._zoom(input["zoom"], _delta);
	
	if input["reload"]:
		#if not anim.is_playing():
		#	if not input["shoot"]:
			if arsenal.values()[current].name == "mk_23": #basically executes the following lines if we are holding the mk_23.
				var mk_bullets_needed = clip_mk - player_data.bullets_mk # determine how many bullets needed
				if player_data.ammo_mk > mk_bullets_needed:# make sure we have more ammo than bullets needed
					anim.play("Reload", 0.2, 1.2);
					player_data.bullets_mk = clip_mk #sets the number of bullets (in magazine to the clip size (number of bullets that go into the magazine).
					player_data.ammo_mk -= mk_bullets_needed# remove the needed bullets for reload from the ammo variable
				elif player_data.ammo_mk != 0: # if we dont have enough ammo to fully refill the magazine
					player_data.bullets_mk += player_data.ammo_mk # add number from ammo to the magazine
					player_data.ammo_mk = 0 # then empty the ammo variable
					anim.play("Reload", 0.2, 1.2);
						
						
			if arsenal.values()[current].name == "glock_17":
				var gl_bullets_needed = clip_gl - player_data.bullets_gl
				if player_data.ammo_gl > gl_bullets_needed:
					anim.play("Reload", 0.2, 1.2);
					player_data.bullets_gl = clip_gl
					player_data.ammo_gl -= gl_bullets_needed
				elif player_data.ammo_gl != 0:
					player_data.bullets_gl += player_data.ammo_gl
					player_data.ammo_gl = 0
					anim.play("Reload", 0.2, 1.2);
					
			if arsenal.values()[current].name == "kriss":
				var kr_bullets_needed = clip_kr - player_data.bullets_kr
				if player_data.ammo_kr > kr_bullets_needed:
					anim.play("Reload", 0.2, 1.2);
					player_data.bullets_kr = clip_kr
					player_data.ammo_kr -= kr_bullets_needed
				elif player_data.ammo_kr != 0:
					player_data.bullets_kr += player_data.ammo_kr
					player_data.ammo_kr = 0
					anim.play("Reload", 0.2, 1.2);
							
			if arsenal.values()[current].name == "test":
				var tst_bullets_needed = clip_tst - player_data.bullets_tst
				if player_data.ammo_tst > tst_bullets_needed:
					anim.play("Reload", 0.2, 1.2);
					player_data.bullets_tst = clip_tst
					player_data.ammo_tst -= tst_bullets_needed
				elif player_data.ammo_tst != 0:
					player_data.bullets_tst += player_data.ammo_tst
					player_data.ammo_tst = 0
					anim.play("Reload", 0.2, 1.2);
		
#			if arsenal.values()[current].name == "test":
#				if player_data.bullets_tst < clip_tst and player_data.ammo_mk > 0:
#					arsenal.values()[current]._reload();
#					for b in player_data.ammo_tst:
#						player_data.bullets_tst += 1
#						player_data.ammo_tst -= 1;
#
#						if player_data.ammo_tst >= clip_mk:
#							break;
		
		#arsenal.values()[current]._reload();
	
	# Update arsenal
	for w in range(arsenal.size()):
		arsenal.values()[w]._update(_delta);
	
func _change() -> void:
	# change weapons
	for w in range(arsenal.size()):
		if arsenal.values()[w] != arsenal.values()[current]:
			arsenal.values()[w]._hide();
		else:
			arsenal.values()[w]._draw();

func _position(_delta) -> void:
	var y_lerp = 20;
	var x_lerp = 40;
	
	global_transform.origin = head.global_transform.origin;
	
	if not input["zoom"]:
		rotation.x = lerp_angle(rotation.x, camera.global_transform.basis.get_euler().x, y_lerp * _delta);
		rotation.y = lerp_angle(rotation.y, camera.global_transform.basis.get_euler().y, x_lerp * _delta);
	else:
		rotation = camera.global_transform.basis.get_euler();

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			var anim = arsenal.values()[current].anim
			
			if not anim.is_playing():
				if event.scancode == KEY_1:
					current = 0;
				if event.scancode == KEY_2:
					current = 1;
				if event.scancode == KEY_3:
					current = 2;
				if event.scancode == KEY_4:
					current = 3;
