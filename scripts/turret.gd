extends StaticBody2D

@export var bullet_scene: PackedScene  # Assign bullet scene in the inspector
@export var fire_rate: float = 1.0  # Time between shots
@export var range: float = 40.0  # Detection range
@export var bullet_speed: float = 60.0  # Speed of bullets
@export var fire_point: Node2D
@export var turret_head: Node2D
@export var fire_timer: Timer

var target: CharacterBody2D = null  # Stores reference to player

func _ready():
	# Ensure fire_timer exists before setting properties
	if fire_timer:
		fire_timer.wait_time = fire_rate
		fire_timer.timeout.connect(_on_fire_timer_timeout)
		fire_timer.start()
	else:
		push_error("Fire timer is not assigned!")

func _process(delta):
	if not turret_head or not fire_point:
		push_error("Turret head or fire point is not assigned!")
		return

	# Look for the nearest player within range
	var players = get_tree().get_nodes_in_group("player")  
	var nearest_player = null
	var min_distance = range  

	for player in players:
		if player is CharacterBody2D:  # Ensure it's a valid CharacterBody2D
			var distance = global_position.distance_to(player.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_player = player

	target = nearest_player  # Assign the closest player or null if none found

	# Rotate turret towards target
	if target:
		var direction = (turret_head.global_position - target.global_position).normalized()
		turret_head.rotation = direction.angle() - PI / 2  # Adjust for initial orientation

# Fires a bullet when timer goes off
func _on_fire_timer_timeout():
	if target and bullet_scene and fire_point:
		AudioManager.play_sfx("turretShoot")
		var bullet = bullet_scene.instantiate()
		if not bullet:
			push_error("Bullet scene could not be instantiated!")
			return
		
		get_tree().current_scene.add_child(bullet)  # Ensure bullet is added to the correct node
		bullet.global_position = fire_point.global_position
		
		# Ensure bullet has a set_direction method
		if bullet.has_method("set_direction"):
			bullet.set_direction((target.global_position - fire_point.global_position).normalized(), bullet_speed)
		else:
			push_error("Bullet scene is missing 'set_direction' method!")
