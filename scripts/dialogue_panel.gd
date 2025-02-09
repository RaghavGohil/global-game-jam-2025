extends Panel

@export var dialogue_text: Label
@export var prev_button: Button
@export var next_button: Button
@export var character_image: TextureRect
@export var character_name_label: Label
@export var auto_advance: bool = false
@export var typing_speed: float = 0.05

var dialogues: Array = []
var current_index: int = 0
var typing_timer: Timer
var char_index: int = 0
var is_typing: bool = false  # New flag to track if typing is in progress

func _ready() -> void:
	# Hide panel initially
	visible = false  

	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.timeout.connect(_on_typing_timeout)
	add_child(typing_timer)

	prev_button.pressed.connect(_on_prev_pressed)
	next_button.pressed.connect(_on_next_pressed)

func set_dialogues(new_dialogues: Array) -> void:
	if new_dialogues.is_empty():
		return  # Don't show the panel if there's no dialogue
	
	print("Dialogue received:", new_dialogues)  # Debugging print

	dialogues = new_dialogues
	current_index = 0
	char_index = 0
	
	# Show panel when receiving data
	visible = true  
	update_dialogue()

func update_dialogue() -> void:
	if dialogues.is_empty():
		print("No dialogues available!")  # Debugging print
		return

	var dialogue_data = dialogues[current_index]
	dialogue_text.text = ""
	char_index = 0
	is_typing = true  # Typing is in progress
	typing_timer.start()

	# Ensure safe access
	character_image.texture = load(dialogue_data.get("image", null))
	character_name_label.text = dialogue_data.get("name", "")

	# Update button states properly
	prev_button.disabled = current_index == 0
	next_button.disabled = false  # Always enabled

func _on_typing_timeout() -> void:
	if current_index >= 0 and current_index < dialogues.size():
		var dialogue_data = dialogues[current_index]
		
		if dialogue_data.has("text") and dialogue_data["text"] is String:
			if char_index < dialogue_data["text"].length():
				dialogue_text.text += dialogue_data["text"][char_index]
				char_index += 1
				typing_timer.start()
			else:
				is_typing = false  # Typing is done
				typing_timer.stop()

func _on_prev_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		char_index = 0
		update_dialogue()
	print("Previous pressed, current index:", current_index)  # Debugging

func _on_next_pressed() -> void:
	# If the text is still typing, instantly reveal it
	if is_typing:
		var dialogue_data = dialogues[current_index]
		dialogue_text.text = dialogue_data.get("text", "")  # Show full text immediately
		is_typing = false
		typing_timer.stop()
		return  # Stop function here; user will need to press again to go to next

	# If already fully shown, proceed to the next dialogue
	if current_index < dialogues.size() - 1:
		current_index += 1
		char_index = 0
		update_dialogue()
	else:
		# Hide panel after last message when clicking next again
		visible = false  

	print("Next pressed, current index:", current_index)  # Debugging
