extends Node

@export var bgm_bus: String = "Music"
@export var sfx_bus: String = "SFX"

var bgm_player: AudioStreamPlayer
var sfx_players: Array = []  # Pool of SFX players

const MAX_SFX_PLAYERS = 10  # Prevent too many SFX players

# Holds loaded sounds
var bgm_library: Dictionary = {}
var sfx_library: Dictionary = {}

func _ready():
	print('Init Audio Manager')
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

# Load sounds dynamically (Call once per scene/game)
func load_audio(sfx_dict: Dictionary, bgm_dict: Dictionary):
	sfx_library = sfx_dict
	bgm_library = bgm_dict
	print("[AudioManager] Audio Loaded | BGM:", bgm_library.keys(), " | SFX:", sfx_library.keys())

# Play Background Music
func play_bgm(name: String, loop: bool = true):
	# Check if the BGM name exists in the library
	if name in bgm_library:
		if bgm_player != null:
			# Ensure previous BGM stops before playing new one
			bgm_player.stop()

			# Get the BGM stream from the library
			var bgm_stream = bgm_library[name]

			# Ensure the stream is valid before attempting to set loop or play
			#if bgm_stream == null:
				#print("[AudioManager] Error: BGM stream is null for:", name)
				#return
			#
			## Set the loop property of the AudioStream (not the AudioStreamPlayer)
			#bgm_stream.loop = loop

			# Assign the stream to the player and play
			bgm_player.stream = bgm_stream

			# Check if the audio stream is loaded and ready to play
			if bgm_player.stream != null:
				bgm_player.play()
				print("[AudioManager] Playing BGM:", name)
			else:
				print("[AudioManager] Error: Unable to assign BGM stream to player for:", name)
		else:
			print("[AudioManager] Error: bgm_player not initialized")
	else:
		print("[AudioManager] BGM not found:", name)
		
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
