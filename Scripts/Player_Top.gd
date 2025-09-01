extends CharacterBody2D

signal health_changed(new_health)
signal score_update(new_score)

@export var Char_speed := 100
@export var Char_accel := 10
@export var health := 100:
	set(value_1):
		health = clamp(value_1,0,100)

@onready var points := 0:
	set(value_2):
		points = clamp(value_2,0,1000)

var input: Vector2
@onready var anim = get_node("AnimationPlayer")

func _ready():
	health = 50
	emit_signal("health_changed", health)
	emit_signal("score_update", points)

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down_back") - Input.get_action_strength("forward_up")
	return input.normalized()

func _physics_process(delta: float) -> void:
	var player_input = get_input()
	velocity = lerp(velocity ,player_input * Char_speed , delta * Char_accel)
	move_and_slide()
	
		# Choose animation based on direction & movement
	if player_input.length() > 0:
		play_run_animation(player_input)
	else:
		play_idle_animation()

func play_idle_animation():
	if anim.current_animation.begins_with("Idle"):
		return
	var last_dir = get_last_direction()
	anim.play("Idle_" + last_dir)

func play_run_animation(direction: Vector2):
	var dir_name = get_direction_name(direction)
	if anim.current_animation == "Run_" + dir_name:
		return
	anim.play("Run_" + dir_name)

func get_direction_name(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "front" if direction.y > 0 else "back"

func get_last_direction() -> String:
	# Use velocity to determine the last direction moved
	if abs(velocity.x) > abs(velocity.y):
		return "right" if velocity.x > 0 else "left"
	else:
		return "front" if velocity.y > 0 else "back"

func heal(amount):
	health += amount
	emit_signal("health_changed",health)
	#print(health)

func score(point):
	points += point
	emit_signal("score_update",points)
	#print(points)
