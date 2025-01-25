extends StaticBody2D

@export var sprite: Sprite2D  # The sprite that will fade in and out
@export var fade_duration: float = 2.0  # Duration for the fade effect
@export var cycle_duration: float = 5.0  # Duration for one full oscillation cycle
@export var collider: CollisionShape2D  # The collider for interaction

var oscillation_timer: Timer

func _ready():
	if not sprite:
		print("Error: Sprite not assigned!")
		return
	if not collider:
		print("Error: Collider not assigned!")
		return
	
	# Create and configure the oscillation Timer
	oscillation_timer = Timer.new()
	oscillation_timer.wait_time = cycle_duration
	oscillation_timer.one_shot = false  # Continuous oscillation
	oscillation_timer.timeout.connect(_on_oscillation_timeout)
	add_child(oscillation_timer)

	# Start the oscillation cycle
	oscillation_timer.start()

# Oscillation timer callback to trigger fading and collider interaction
func _on_oscillation_timeout():
	var current_opacity = sprite.modulate.a

	if current_opacity > 0.5:  # If mostly visible, fade out
		fade_out()
	else:  # If mostly invisible, fade in
		fade_in()

# Fade the sprite out (to transparency) and disable collider after fade completes
func fade_out():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(disable_collider)  # Disable collider AFTER fading out

# Fade the sprite in (to full opacity) and enable collider after fade completes
func fade_in():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, fade_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(enable_collider)  # Enable collider AFTER fading in

# Disable the collider to make the platform passable
func disable_collider():
	collider.set_deferred("disabled", true)  # Use `set_deferred` to avoid physics issues

# Enable the collider to make the platform interactable
func enable_collider():
	collider.set_deferred("disabled", false)
