extends CharacterBody2D

signal died

var speed = randf_range(200, 300)
var health = 7

var can_move = true   # Added: controls if mob can move
var can_attack = true # For future firing logic

@onready var player = get_node("/root/Game/Player")
@onready var slime = $Slime

func _ready():
	# Add mob to group for easy stopping
	add_to_group("Mobs")
	slime.play_walk()

func _physics_process(delta):
	if not can_move:
		return  # Stop movement if game is over


	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()

	

func take_damage():
	slime.play_hurt()
	health -= 1

	if health <= 0:
		emit_signal("died")

		var smoke_scene = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = smoke_scene.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()

func stop():
	can_move = false
	can_attack = false
	velocity = Vector2.ZERO
