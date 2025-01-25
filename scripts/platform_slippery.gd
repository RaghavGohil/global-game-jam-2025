extends StaticBody2D

@export var move_distance: float = 200.0  # Distance the platform moves
@export var move_speed: float = 2.0  # Speed of movement (higher = faster)
@export var move_horizontal: bool = true  # Enable horizontal movement
@export var move_vertical: bool = false  # Enable vertical movement

var start_position: Vector2
var time_passed: float = 0.0  # Time tracker for oscillation

func _ready():
	start_position = global_position  # Store the initial position

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
	
	# Apply the new position
	global_position = new_position  
