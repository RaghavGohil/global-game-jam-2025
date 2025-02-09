extends Node

@export var bgm_bus: String = "Music"
@export var sfx_bus: String = "SFX"

var bgm_player: AudioStreamPlayer
var sfx_players: Array = []  # Pool of SFX players

const MAX_SFX_PLAYERS = 10  # Prevent too many SFX players

var bgm_library = {
	"game_theme": preload("res://audio/Mixdown.wav"),
}

var sfx_library = {
	"footsteps1": preload("res://audio/Footsteps_1.wav"),
	"footsteps2": preload("res://audio/Footsteps_2.wav"),
	"footsteps3": preload("res://audio/Footsteps_3.wav"),
	"footsteps4": preload("res://audio/Footsteps_4.wav"),
	"jump1": preload("res://audio/Jump_1.wav"),
	"jump2": preload("res://audio/Jump_2.wav"),
	"levelComplete": preload("res://audio/Level complete.wav"),
	"bubbleFillUp": preload("res://audio/Balloon_bar fill up.wav"),
	"bubbleBurst": preload("res://audio/Balloon_shoot _2.wav"),
	"bubbleShoot": preload("res://audio/Balloon_shoot _1.wav"),
	"bubbleEnter": preload("res://audio/Balloon enter.mp3"),
	"bubbleExit": preload("res://audio/Balloon enter.wav"),
	"turretShoot": preload("res://audio/turretShoot.wav"),
	"buttonSelect": preload("res://audio/Button select.wav"),
	"buttonStart": preload("res://audio/Button start.wav"),
	"cartoonScientistAngry1": preload("res://audio/Cartoon_Scientist_Angry_1.wav"),
	"cartoonScientistAngry2": preload("res://audio/Cartoon_Scientist_Angry_2.wav"),
	"cartoonScientistAngry3": preload("res://audio/Cartoon_Scientist_Angry_3.wav"),
	"cartoonScientistScreaming": preload("res://audio/Cartoon_Scientist_Screaming.wav"),
	"playerDeath": preload("res://audio/Player death.wav"),
	"playerHurt": preload("res://audio/playerHurt.wav"),
	"forceField": preload("res://audio/forceField.wav"),
}

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
