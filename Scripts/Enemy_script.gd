extends CharacterBody2D

@export var enemy_data: Enemies
@onready var player: Player
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim : AnimatedSprite2D 
@onready var collision_shape_2d: CollisionShape2D

var can_attack: bool = true
signal despawn

func _ready():
	if enemy_data:
		setup_enemy(enemy_data)
	if nav_agent:
		nav_agent.path_desired_distance = 2.0
		nav_agent.target_desired_distance = enemy_data.attack_range

func setup_enemy(data : Enemies):
	# Swap in sprite
	if data.sprite_scene:
		var sprite_instance = data.sprite_scene.instantiate()
		if anim: anim.queue_free()
		if collision_shape_2d : collision_shape_2d.queue_free()
		add_child(sprite_instance)
		anim = sprite_instance.get_node_or_null("AnimatedSprite2D")
		collision_shape_2d = sprite_instance.get_node_or_null("CollisionShape2D")
		if not anim:
			print("Warning: AnimatedSprite2D not found in sprite scene!")
		elif not collision_shape_2d:
			print("Warning: CollisionShape2D not found in sprite scnen!")

func _physics_process(_delta: float) -> void:
	if not player:
		print("no player")
		return
	
	# Update path target
	nav_agent.target_position = player.global_position
	# Move using pathfinding
	if not nav_agent.is_navigation_finished():
		var next_point = nav_agent.get_next_path_position()
		var dir = (next_point - global_position)
		var direction = dir.normalized()
		_animation(dir)
		velocity = direction * enemy_data.speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Attack check
	if global_position.distance_to(player.global_position) <= enemy_data.attack_range:
		if can_attack:
			attack()

func _animation(dir: Vector2):
	if not anim or anim.animation == "":
		return
	# If enemy is moving
	if velocity.length() > 0.1:
		# Flip depending on horizontal direction
		if dir.x < 0:
			anim.flip_h = true   # facing left
		elif dir.x > 0:
			anim.flip_h = false    # facing right
		
		anim.play("walk")
	else: anim.play("idle")

func attack():
	if not player:
		return
	if player.has_method("hurt"):
		player.hurt(enemy_data.damage)
	can_attack = false
	emit_signal("despawn")
	queue_free()
