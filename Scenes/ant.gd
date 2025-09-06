extends CharacterBody2D

@export var enemy_data: Enemies
@export var player : Player 
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D  # adjust path to your animation node

var can_attack: bool = true
signal despawn

func _ready():
	anim.play("idle")
	if nav_agent:
		nav_agent.path_desired_distance = 2.0
		nav_agent.target_desired_distance = enemy_data.attack_range

func _physics_process(_delta: float) -> void:
	if not player:
		return
	
	# Update path target
	nav_agent.target_position = player.global_position

	# Move using pathfinding
	if not nav_agent.is_navigation_finished():
		var next_point = nav_agent.get_next_path_position()
		var dir = (next_point - global_position).normalized()
		velocity = dir * enemy_data.speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Attack check
	if global_position.distance_to(player.global_position) <= enemy_data.attack_range:
		if can_attack:
			attack()

	# Handle animation (same anim for walk + idle)
	if velocity.length() > 0.1:
		if anim.animation != "walk":
			anim.play("walk")
	else:
		if anim.animation != "idle":
			anim.play("idle")

func attack():
	if not player:
		return
	player.health -= enemy_data.damage
	player.emit_signal("health_changed", player.health)
	can_attack = false
	emit_signal("despawn")
