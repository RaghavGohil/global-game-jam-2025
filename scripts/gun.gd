extends Sprite2D

@export var player: Node2D  # Reference to the player node (must be assigned!)
@export var gun_tip: Node2D
@export var bubble_scene: PackedScene  # Assign bubble scene in Inspector
@export var particle_fx: CPUParticles2D  # Assign particle effect
@export var cooldown_time: float = 0.5  # Cooldown time in seconds
@export var cooldown_timer: Timer

# Movement and flip
var mouse_pos: Vector2
var player_pos: Vector2

# Shooting cooldown
var can_shoot: bool = true  

func _ready():
	# Ensure player is assigned
	if not player:
		print("Error: Player node is not assigned!")
		return
	
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_shoot_cooldown_timeout)

func _process(delta):
	# Get positions
	mouse_pos = get_global_mouse_position()
	player_pos = player.global_position

	# Flip and rotate gun
	flip_gun()
	rotate_gun()

	# Shoot with cooldown
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_bubble()

func flip_gun():
	flip_v = mouse_pos.x < player_pos.x

func rotate_gun():
	look_at(mouse_pos)

func shoot_bubble():
	if not bubble_scene:
		print("Bubble scene not assigned!")
		return
	AudioManager.play_sfx('bubbleShoot')
	
	# Prevent further shooting
	can_shoot = false
	cooldown_timer.start()  # Start cooldown timer
	
	# Create and position the bubble
	var bubble = bubble_scene.instantiate() as Node2D
	player.get_parent().add_child(bubble)
	bubble.global_position = gun_tip.global_position
	
	# Get shooting direction and apply impulse
	var direction: Vector2 = (mouse_pos - player_pos).normalized()
	if bubble.has_method("set_impulse"):
		bubble.set_impulse(direction * 0.015)
	
	# Play particle effect
	if particle_fx:
		particle_fx.restart()
	else:
		print("Warning: Particle effect is not assigned!")

# Timer callback function
func _on_shoot_cooldown_timeout():
	can_shoot = true  # Re-enable shooting
