extends Node

@export var bgm_bus: String = "Music"
@export var sfx_bus: String = "SFX"

var bgm_player: AudioStreamPlayer
var sfx_players: Array = []  # Pool of SFX players

const MAX_SFX_PLAYERS = 10  # Prevent too many SFX players

# Holds loaded sounds
var bgm_library: Dictionary = {}
var sfx_library: Dictionary = {}

# Tween to handle fade-in/out (using create_tween)
var tween: Tween

# The listener's position (usually the camera or player)
var listener_position: Vector2 = Vector2.ZERO

func _ready():
	# Create a single AudioStreamPlayer for background music
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = bgm_bus
	bgm_player.autoplay = false
	add_child(bgm_player)
	
	# Preload all SFX players
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = sfx_bus
		add_child(player)
		sfx_players.append(player)
	
	print("[AudioManager] Initialized")

	# Connect the finished signal of bgm_player to restart the track
	bgm_player.finished.connect(Callable(self, "_on_bgm_finished"))

# Load sounds dynamically (Call once per scene/game)
func load_audio(sfx_dict: Dictionary, bgm_dict: Dictionary):
	sfx_library = sfx_dict
	bgm_library = bgm_dict
	print("[AudioManager] Audio Loaded | BGM:", bgm_library.keys(), " | SFX:", sfx_library.keys())

# Play Background Music and restart it when it ends
func play_bgm(name: String):
	if name in bgm_library:
		if bgm_player != null:
			# Stop previous BGM and reset time to 0
			print("[AudioManager] Stopping previous BGM")
			bgm_player.stop()
			bgm_player.stream = bgm_library[name]
			bgm_player.play()
			bgm_player.seek(0)  # Reset time to 0 when starting the new track
			print("[AudioManager] BGM started:", name)
		else:
			print("[AudioManager] Error: bgm_player not initialized")
	else:
		print("[AudioManager] BGM not found:", name)

# Handle BGM finishing and restart it
func _on_bgm_finished():
	print("[AudioManager] BGM finished, restarting track.")
	bgm_player.seek(0)  # Restart the BGM from the beginning
	bgm_player.play()   # Play it again
	print("[AudioManager] BGM restarted.")

# Stop BGM
func stop_bgm():
	bgm_player.stop()
	print("[AudioManager] Stopped BGM")

# Play Sound Effect
func play_sfx(name: String):
	if name in sfx_library:
		# Find an available SFX player
		for player in sfx_players:
			if !player.playing:
				player.stream = sfx_library[name]
				player.play()
				print("[AudioManager] Playing SFX:", name)
				return
		# If all players are busy, you can either log or handle this case
		print("[AudioManager] No available SFX players!") 
	else:
		print("[AudioManager] SFX not found:", name)

# Set Volume (0 - 1)
func set_bgm_volume(value: float):
	var bus_index = AudioServer.get_bus_index(bgm_bus)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		print("[AudioManager] BGM Volume set to", value)
	else:
		print("[AudioManager] Invalid BGM bus:", bgm_bus)

func set_sfx_volume(value: float):
	var bus_index = AudioServer.get_bus_index(sfx_bus)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		print("[AudioManager] SFX Volume set to", value)
	else:
		print("[AudioManager] Invalid SFX bus:", sfx_bus)
