extends Node

# scene transition

signal transition_fade_in
signal transition_fade_out

# sfx

func _ready():
	print('Init Game Manager')
	#AudioManager.play_bgm('game_theme')

func restart_lvl():
	transition_fade_out.emit()  # Emit signal to fade out and restart
