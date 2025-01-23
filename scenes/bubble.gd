extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ensure any necessary setup happens here.
	pass

# Function to apply an impulse in a given direction
func set_impulse(impulse: Vector2):
	# Apply impulse to the RigidBody2D in the direction
	apply_impulse(impulse, Vector2.ZERO)
