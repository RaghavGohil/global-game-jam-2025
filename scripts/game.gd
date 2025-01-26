extends Node

# scene transition

signal transition_fade_in
signal transition_fade_out

# sfx

var bgm = {
	"game_theme": preload("res://audio/Mixdown.wav"),
}

var sfx = {
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
	"bubbleEnter": preload("res://audio/Balloon enter.wav"),
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

func _ready():
	print('Init Game Manager')
	AudioManager.load_audio(sfx, bgm)
	AudioManager.play_bgm('game_theme')

func restart_lvl():
	transition_fade_out.emit()  # Emit signal to fade out and restart
