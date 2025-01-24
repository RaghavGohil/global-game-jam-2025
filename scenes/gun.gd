extends Sprite2D

@export var player: Node2D  # Reference to the player node (must be assigned!)
@export var gun_tip: Node2D

# Movement and flip
var mouse_pos: Vector2
var player_pos: Vector2

# Shooting
@export var bubble_scene: PackedScene  # Assign bubble scene in Inspector
@export var particle_fx: CPUParticles2D  # Assign particle effect

func _process(delta):
	# Ensure player is assigned
	if not player:
		print("Error: Player node is not assigned!")
		return
	
	# Get positions
	mouse_pos = get_global_mouse_position()
	player_pos = player.global_position  # Get the actual player position

	# Flip gun based on mouse position
	flip_gun()

	# Rotate gun towards mouse
	rotate_gun()

	# Shoot the gun and spawn a bubble	
	if Input.is_action_just_pressed("shoot"):
		shoot_bubble()


func flip_gun():
	# Flip gun sprite based on mouse position relative to player
	flip_v = mouse_pos.x < player_pos.x

func rotate_gun():
	# Rotate gun to point at the mouse
	look_at(mouse_pos)
	
func shoot_bubble():
	if not bubble_scene:
		print("Bubble scene not assigned!")
		return
	
	# Create the bubble instance
	var bubble = bubble_scene.instantiate() as Node2D
	player.get_parent().add_child(bubble)  # Add to player's parent
	
	# Position bubble at gun's position
	bubble.global_position = gun_tip.global_position
	
	# Get shooting direction
	var direction:Vector2 = (mouse_pos - player_pos).normalized()
	
	# Apply an impulse to move the bubble forward
	if bubble.has_method("set_impulse"):
		bubble.set_impulse(direction*0.015)
	
	# Play particle effect safely
	if particle_fx:
		particle_fx.restart()  # Restart effect
	else:
		print("Warning: Particle effect is not assigned!")
