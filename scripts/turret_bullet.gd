extends RigidBody2D

@export var speed: float  # Bullet speed
@export var lifetime: float = 3.0  # Time before bullet disappears
@export var timer: Timer  # Timer for auto-delete

var direction: Vector2 = Vector2.ZERO  # Direction the bullet moves in

func _ready():
	# Auto-delete bullet after `lifetime` seconds
	timer.wait_time = lifetime
	timer.timeout.connect(queue_free)
	timer.start()

	# Set the rotation of the bullet to face the direction
	rotation = direction.angle()

func _physics_process(delta):
	if direction != Vector2.ZERO:
		# Move the bullet in the direction
		linear_velocity = direction * speed  # Use RigidBody2D's linear velocity to move

# Function to set direction and speed
func set_direction(new_direction: Vector2, new_speed: float):
	direction = new_direction.normalized()
	speed = new_speed

	# Set the rotation of the bullet to face the new direction
	rotation = direction.angle()
	
# area is for the bullet to die. we dont want the bullet to die when it's touching a player
func _on_area_2d_area_entered(area:Area2D):
	queue_free()

# area is for the bullet to die. we dont want the bullet to die when it's touching a player
func _on_area_2d_body_entered(body:Node2D):
	queue_free()
