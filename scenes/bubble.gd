extends RigidBody2D

@export var min_lifetime: float = 3.0  # Minimum explosion time
@export var max_lifetime: float = 6.0  # Maximum explosion time
@export var explosion_particles: PackedScene  # Assign the explosion effect in Inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ensure any necessary setup happens here.
	start_lifetime_timer()

# Function to apply an impulse in a given direction
func set_impulse(impulse: Vector2):
	# Apply impulse to the RigidBody2D in the direction
	apply_impulse(impulse, Vector2.ZERO)

func start_lifetime_timer():
	var timer = Timer.new()
	var random_time = randf_range(min_lifetime, max_lifetime)  # Random time between 3-6 sec
	timer.wait_time = random_time
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_explode"))
	add_child(timer)
	timer.start()

func _explode():
	if explosion_particles:
		var explosion = explosion_particles.instantiate()
		get_parent().add_child(explosion)  # Make sure it's added to the scene!
		explosion.global_position = global_position
	queue_free()

func _on_area_2d_body_entered(body:Node2D):
	if not body.is_in_group('player'):
		print(body.name)
		_explode()
