extends Node2D


@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	print("Start pressed")  
	get_tree().change_scene_to_file("res://story.tscn")  

func _on_quit_pressed():
	print("Quit pressed")   
	get_tree().quit()
