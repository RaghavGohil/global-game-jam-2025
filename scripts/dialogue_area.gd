extends Area2D

@onready var dialogue_ui = $"../UI/DialoguePanel"

@export var json_file_path: String  # Path to the JSON file
var dialogues: Array = []  # Will hold the parsed dialogue data

func _ready() -> void:
	load_dialogues_from_json()  # Load dialogues on startup
	body_entered.connect(_on_body_entered)

func load_dialogues_from_json() -> void:
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(content)
		
		if error == OK:
			dialogues = json.data  # Store parsed JSON data
			print("Loaded dialogues:", dialogues)  # Debugging print
		else:
			print("Error parsing JSON:", error)
	else:
		print("Failed to load JSON file:", json_file_path)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and dialogues.size() > 0:
		print("Player entered, setting dialogues.")
		dialogue_ui.set_dialogues(dialogues)  # Send loaded dialogues
