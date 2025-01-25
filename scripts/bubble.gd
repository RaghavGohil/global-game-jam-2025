extends RigidBody2D

@export var min_lifetime: float = 3.0  # Minimum explosion time
@export var max_lifetime: float = 6.0  # Maximum explosion time
@export var explosion_particles: PackedScene  # Assign the explosion effect in Inspector

@export var min_start_scale: float = 0.2 
@export var max_start_scale: float = 0.4 
@export var growth_duration: float = 0.2 

func _ready():
	start_lifetime_timer()
	start_growth_effect()

func start_growth_effect():
	var org_scale = scale
	var target_scale = Vector2(randf_range(min_start_scale, max_start_scale), randf_range(min_start_scale, max_start_scale))
	scale = Vector2(0.1, 0.1)  # Start small
	var tween = create_tween()
	tween.tween_property(self, "scale", org_scale , growth_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func set_impulse(impulse: Vector2):
	apply_central_impulse(impulse)  # Fixed for Godot 4

func start_lifetime_timer():
	var timer = Timer.new()
	timer.wait_time = randf_range(min_lifetime, max_lifetime)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_explode"))
	add_child(timer)
	timer.start()
	
	# Cleanup timer after explosion
	timer.connect("timeout", Callable(timer, "queue_free"))

func _explode():
	if explosion_particles:
		var explosion = explosion_particles.instantiate()
		get_parent().add_child(explosion)  # Add to scene
		explosion.global_position = global_position
		explosion.emitting = true  # Start particle animation
		
		# Auto-delete particle effect after it finishes
		explosion.connect("finished", Callable(explosion, "queue_free"))
	
	queue_free()  # Remove bubble

func _on_area_bubble_area_entered(area): #if anything other than player, explode
	if not area.is_in_group("player") and not area.is_in_group('bubble') and not area.is_in_group('force_field'):
		_explode()

func _on_area_bubble_body_entered(body):
	if not body.is_in_group("player"):
		_explode()
