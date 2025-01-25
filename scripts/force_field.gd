extends StaticBody2D

@export var force_strength: float = 0.05  # Adjusted repelling force

func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("bubble"):  
		area.get_parent().set_meta("inside_force_field", true)  # Mark as inside

func _on_area_2d_area_exited(area: Area2D):
	if area.is_in_group("bubble"):
		area.get_parent().set_meta("inside_force_field", false)  # Mark as outside

func _process(delta):
	for body in get_overlapping_bubbles():
		if body.get_meta("inside_force_field", false):
			var force = calculate_force(body.global_position)
			body.apply_force(force, Vector2.ZERO)  # Apply force continuously

# Find all bubbles in the repelling area
func get_overlapping_bubbles():
	var bubbles = []
	for area in $Area2D.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is RigidBody2D:
			bubbles.append(parent)
	return bubbles

# Calculate the repelling force
func calculate_force(target_position: Vector2) -> Vector2:
	var direction = (target_position - global_position).normalized()
	return direction * force_strength  # Apply constant force
