extends ColorRect

@export var fade_time: float  # Time for fade effect
var tween: Tween

func _ready():
	self.material.set_shader_parameter("fade", 1.0)  # Start with black screen
	Game.transition_fade_out.connect(fade_out_and_restart)  # Listen for fade-out event
	fade_in()

func fade_in():
	tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/fade", 0.0, fade_time)

func fade_out_and_restart():
	tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/fade", 1.0, fade_time)
	await tween.finished  # Wait for fade-out to complete
	get_tree().reload_current_scene()  # Restart scene
