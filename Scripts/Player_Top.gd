extends CharacterBody2D
class_name Player

var upgrade = player_upgrades.new()

signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal speed_n_max_speed_change(new_speed,new_max_speed)
signal dead()

const HEALTH_N_SPEED_RES = preload("res://Player/health_n_speed_res.tres") as health_n_speed_res

var max_speed: int = HEALTH_N_SPEED_RES.max_speed
var _char_speed : int =HEALTH_N_SPEED_RES.speed
var char_speed : int :
	get:
		return _char_speed
	set(value_speed):
		_char_speed = clamp(value_speed, 10, max_speed)
		emit_signal("speed_n_max_speed_change", _char_speed, max_speed)

var char_accel : int = 10
var max_health : int = HEALTH_N_SPEED_RES.max_health
var _health : int = 50
var health : int :
	get:
		return _health
	set(value_1):
		_health = clamp(value_1,0,max_health)
		emit_signal("health_changed", _health)

var hurting : bool = false
var is_alive : bool = true
var input: Vector2 = Vector2.ZERO
@onready var anim = get_node("AnimationPlayer")
@onready var upgrade_screen: player_upgrades = $"../CanvasLayer/Upgrade_screen"

func _ready():
	upgrade_screen.change_max_health.connect(max_health_change)
	upgrade_screen.change_max_speed.connect(max_speed_change)
	upgrade_screen.change_speed.connect(speed_change)
	emit_signal("health_changed", health)
	emit_signal("max_health_changed",max_health)
	emit_signal("speed_n_max_speed_change",char_speed,max_speed)

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down_back") - Input.get_action_strength("forward_up")
	return input.normalized()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("temp_dead"):
		health -= (health-1)

func _physics_process(delta: float) -> void:
	var player_input = get_input()
	velocity = lerp(velocity ,player_input * char_speed , delta * char_accel)
	move_and_slide()
	
	# Choose animation based on direction & movement
	if hurting:
		return
	if not is_alive:
		return
	if player_input.length() > 0 :
		play_run_animation(player_input)
	elif player_input.length() == 0 :
		play_idle_animation()
	
	if health <= 0 and is_alive:
		_death()

func play_idle_animation():
	if anim.current_animation.begins_with("Idle"):
		return
	anim.play("Idle_" + get_last_direction())

func play_run_animation(direction: Vector2):
	var dir_name = get_direction_name(direction)
	if anim.current_animation == "Run_" + dir_name:
		return
	anim.play("Run_" + dir_name)

func play_hurt_animation():
	anim.play("Hurt_" + get_last_direction())

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

func hurt(amount):
	if not is_alive or health <= 0:
		return  # ignore hits if dead or dying
	health -= amount
	hurting = true
	play_hurt_animation()
	anim.animation_finished.connect(_on_hurt_finished , CONNECT_ONE_SHOT)

func _on_hurt_finished(anim_name : String):
	if anim_name.begins_with("Hurt"):
		hurting = false

func max_health_change(maxhealth):
	max_health = maxhealth
	health = clamp(health, 0, max_health)
	emit_signal("max_health_changed",max_health)
	#print(max_health)

func max_speed_change(maxspeed):
	max_speed = maxspeed
	char_speed = clamp(char_speed, 10, max_speed)

func speed_change(speed):
	char_speed = clamp(speed, 10, max_speed)

func _death():
	if not is_alive:
		return
	is_alive = false
	set_physics_process(false)
	anim.play("Death")
	anim.animation_finished.connect(_on_death_finished, CONNECT_ONE_SHOT)

func _on_death_finished(anim_name : StringName):
	if anim_name == "Death":
		emit_signal("dead")

func _on_area_2d_body_entered(body) -> void:
	if body is CharacterBody2D and body.name == "Player":
		upgrade_screen.visible = true

func _on_area_2d_body_exited(body) -> void:
	if body is CharacterBody2D and body.name == "Player":
		upgrade_screen.visible = false
