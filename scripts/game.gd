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
	"balloonFillUp": preload("res://audio/Balloon_bar fill up.wav"),
	"balloonBurst": preload("res://audio/Balloon_burst .wav"),
	"balloonShoot1": preload("res://audio/Balloon_shoot _1.wav"),
	"balloonShoot2": preload("res://audio/Balloon_shoot _2.wav"),
	"balloonEnter": preload("res://audio/Balloon enter.wav"),
	"balloonExit": preload("res://audio/Balloon exit.wav"),
	"buttonSelect": preload("res://audio/Button select.wav"),
	"buttonStart": preload("res://audio/Button start.wav"),
	"cartoonScientistAngry1": preload("res://audio/Cartoon_Scientist_Angry_1.wav"),
	"cartoonScientistAngry2": preload("res://audio/Cartoon_Scientist_Angry_2.wav"),
	"cartoonScientistAngry3": preload("res://audio/Cartoon_Scientist_Angry_3.wav"),
	"cartoonScientistScreaming": preload("res://audio/Cartoon_Scientist_Screaming.wav"),
	"playerDeath": preload("res://audio/Player death.wav"),
	"playerHurt": preload("res://audio/Player hurt.wav"),
}

func _ready():
	print('Init Game Manager')
	AudioManager.load_audio(sfx, bgm)
	AudioManager.play_bgm('game_theme')

func restart_lvl():
	transition_fade_out.emit()  # Emit signal to fade out and restart
