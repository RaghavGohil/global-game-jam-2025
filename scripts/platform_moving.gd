extends StaticBody2D

@export var move_distance: float = 200.0  # Distance the platform moves
@export var move_speed: float = 2.0  # Speed of movement (higher = faster)
@export var move_horizontal: bool = true  # Enable horizontal movement
@export var move_vertical: bool = false  # Enable vertical movement

var start_position: Vector2
var time_passed: float = 0.0  # Time tracker for oscillation
var last_position: Vector2  # Stores previous position
var player: CharacterBody2D = null  # Reference to the player

func _ready():
	start_position = global_position  # Store the initial position
	last_position = global_position  # Initialize last position

	# Connect signals from the Area2D (Make sure it's a child of the platform)
	var area = $Area2D  # Ensure you have an Area2D as a child of the platform
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)

func _process(delta):
	time_passed += delta * move_speed  # Increment time for smooth oscillation
	
	# Calculate oscillation offset
	var oscillation_offset = sin(time_passed) * move_distance
	
	# Determine movement direction
	var new_position = start_position
	if move_horizontal:
		new_position.x += oscillation_offset
	if move_vertical:
		new_position.y += oscillation_offset
	
	# Calculate platform movement delta
	var platform_movement = new_position - last_position
	last_position = new_position  # Update last position

	# Move the player along with the platform
	if player:
		player.global_position += platform_movement

	# Apply the new position
	global_position = new_position  

# Detect when the player steps onto the platform
func _on_body_entered(body):
	if body is CharacterBody2D:
		player = body  # Store reference to the player

# Detect when the player leaves the platform
func _on_body_exited(body):
	if body == player:
		player = null  # Remove reference when the player leaves
