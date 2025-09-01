extends CharacterBody2D

@export var Char_speed := 100
@export var health := 100:
	set(value):
		health = clamp(value,0,100)

@onready var anim = get_node("AnimationPlayer")

func _ready() -> void:
	health = 50

func _movement(speed):
	if Input.is_action_pressed("forward_up") or Input.is_action_pressed("ui_up"):
		velocity.y = -speed
		velocity.x = 0
		anim.play("Idle")
	elif Input.is_action_pressed("down_back") or Input.is_action_pressed("ui_down"):
		velocity.y = speed
		velocity.x = 0
		anim.play("Idle")
	elif Input.is_action_pressed("left") or Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		velocity.y = 0
		get_node("AnimatedSprite2D").flip_h = true
		anim.play("Run")
	elif Input.is_action_pressed("right") or Input.is_action_pressed("ui_right"):
		velocity.x = speed
		velocity.y = 0
		get_node("AnimatedSprite2D").flip_h = false
		anim.play("Run")
	else:
		velocity.x = 0
		velocity.y =0
		anim.play("Idle")
	
	move_and_slide()
	
	
func _physics_process(_delta: float) -> void:
	_movement(Char_speed)

func regen():
	pass
