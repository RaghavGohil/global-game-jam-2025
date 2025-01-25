extends Node2D

@export var transition_color_rect:ColorRect

func _ready():
	transition_color_rect.fade_in()

func restart_lvl():
	transition_color_rect.fade_out_and_restart()
