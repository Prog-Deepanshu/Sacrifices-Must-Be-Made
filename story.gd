extends Node2D

@onready var video_player = $VideoStreamPlayer

func _ready():
	video_player.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():

	get_tree().change_scene_to_file("res://survivors_game.tscn")
