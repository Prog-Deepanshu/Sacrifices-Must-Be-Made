extends CharacterBody2D

signal health_depleted

var health = 100.0
var can_move = true  

@onready var happy_boo = $HappyBoo
@onready var hurt_box = $HurtBox
@onready var health_bar = $HealthBar

func _physics_process(delta):
	const SPEED = 600.0
	
	if can_move:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = direction * SPEED
		move_and_slide()
		
		
		if velocity.length() > 0.0:
			happy_boo.play_walk_animation()
		else:
			happy_boo.play_idle_animation()
	else:
		velocity = Vector2.ZERO
		move_and_slide()
		happy_boo.play_idle_animation()
	

	if can_move:
		const DAMAGE_RATE = 15.0
		var overlapping_mobs = hurt_box.get_overlapping_bodies()
		if overlapping_mobs:
			health -= DAMAGE_RATE * overlapping_mobs.size() * delta
			health_bar.value = health
			if health <= 0.0:
				health = 0
				can_move = false
				health_depleted.emit()  
