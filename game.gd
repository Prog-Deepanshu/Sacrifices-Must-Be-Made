extends Node

@onready var player = $Player
@onready var restart_button = $CanvasLayer/GameOverScreen/RestartButton
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var timer = $Timer
@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var final_score_label = $CanvasLayer/GameOverScreen/FinalScoreLabel
var score = 0
var is_game_over = false
var spawn_rate = 1.5
var difficulty_timer = 0.0

func _ready():
	
	score = 0
	is_game_over = false
	restart_button.visible = false
	score_label.text = "Score: 0"
	add_to_group("Mobs")
	
	restart_button.pressed.connect(_on_RestartButton_pressed)
	timer.timeout.connect(_on_timer_timeout)
	player.health_depleted.connect(game_over)
	game_over_screen.visible = false
	restart_button.visible = false


	timer.wait_time = spawn_rate
	timer.start()

	set_process(true)

func _process(delta):
	if is_game_over:
		return


	score += 10 * delta
	score_label.text = "Score: %d" % int(score)


	difficulty_timer += delta
	if difficulty_timer >= 3.0:  
		difficulty_timer = 0.0
		spawn_rate = max(spawn_rate - 0.15, 0.2)
		timer.wait_time = spawn_rate
		print("Increased difficulty! New spawn rate:", spawn_rate)


	if player.health <= 0:
		game_over()

func spawn_mob():
	if is_game_over:
		return  

	var new_mob = preload("res://mob.tscn").instantiate()
	
	var angle = randf() * TAU  
	
	var distance = randf_range(400, 700)
	
	var offset = Vector2(cos(angle), sin(angle)) * distance
	
	new_mob.global_position = player.global_position + offset
	
	add_child(new_mob)

func game_over():
	if is_game_over:
		return

	is_game_over = true

	timer.stop()
	set_process(false)
	player.can_move = false

	player.visible = false

	for mob in get_tree().get_nodes_in_group("Mobs"):
		mob.visible = false

	game_over_screen.visible = true
	game_over_screen.modulate.a = 0
	final_score_label.text = "Final Score: %d" % int(score)

	var tween = create_tween()
	tween.tween_property(game_over_screen, "modulate:a", 1.0, 0.4)

	restart_button.visible = true


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func _on_timer_timeout():
	if not is_game_over:
		spawn_mob()
func show_game_over_flash():
	game_over_screen.visible = true  
	game_over_screen.modulate.a = 0  

	var tween = Tween.new()
	add_child(tween)
	tween.tween_property(game_over_screen, "modulate:a", 1.0, 0.3)  # Fade in over 0.3 seconds
	tween.play()
		
