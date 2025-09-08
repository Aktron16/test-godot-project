extends Node2D

@onready var player : Player = $Player
@onready var canvas = $CanvasLayer/Confirm_Quit
@onready var upgrade_screen: Control = $CanvasLayer/Upgrade_screen
@onready var death_screen: Control = $CanvasLayer/Death_screen

@export var health_pack_amount : int = 20
var cherry = preload("res://Scenes/cherries.tscn")

@export var gems_amount : int = 50
var gems = preload("res://Scenes/gems.tscn")

@export var enemy_amount : int = 20
var Enemy_scene = preload("res://Scenes/Enemies.tscn")
const ANTS_RES = preload("res://Enemies/Enemies_Res/Ants_res.tres")
const BATS_RES = preload("res://Enemies/Enemies_Res/Bats_res.tres")
const BEAR_RES = preload("res://Enemies/Enemies_Res/Bear_res.tres")

func _ready() -> void:
	initial_enemy_spawner(enemy_amount)
	obj_spawner(cherry, health_pack_amount)
	obj_spawner(gems, gems_amount)
	
	# Hide menus at start
	canvas.visible = false
	upgrade_screen.visible = false
	death_screen.visible = false

	# Allow menus to work while paused
	canvas.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	death_screen.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Connect once
	if not player.is_connected("dead", Callable(self, "_player_dead")):
		player.connect("dead", Callable(self, "_player_dead"))

func _process(_delta: float) -> void:
	# Toggle pause with ESC (ui_cancel)
	if Input.is_action_just_pressed("ui_cancel") and not death_screen.visible:
		if get_tree().paused:
			_unpause_game()
		else:
			_pause_game()

# -------------------------------
# Pause system
# -------------------------------
func _pause_game():
	get_tree().paused = true
	canvas.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # show cursor

func _unpause_game():
	get_tree().paused = false
	canvas.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide cursor if needed

# -------------------------------
# Death system
# -------------------------------
func _player_dead():
	death_screen.visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# -------------------------------
# Enemy + object spawning
# -------------------------------
func rand_coord() -> Vector2:
	return Vector2(randi_range(50, 2070), randi_range(20, 620))

func rand_enemy():
	var enemy_types = [ANTS_RES, BATS_RES, BEAR_RES]
	return enemy_types.pick_random()

func initial_enemy_spawner(e_amount : int):
	for i in range(e_amount):
		enemy_spawner()

func enemy_spawner():
	var enemy = Enemy_scene.instantiate()
	enemy.enemy_data = rand_enemy()
	enemy.global_position = rand_coord()
	add_child(enemy)
	
	if enemy.is_in_group("Enemy"):
		enemy.player = player
	if enemy.has_signal("despawn"):
		enemy.connect("despawn", Callable(self, "_respawn_enemy"))

func obj_spawner(obj, amount : int):
	for i in range(amount):
		spawner(obj)

func spawner(obj):
	var instance = obj.instantiate()
	instance.position = rand_coord()
	add_child(instance)
	
	if instance.has_signal("health_pack_used"):
		instance.connect("health_pack_used", Callable(self, "_on_health_pack_used"))
	if instance.has_signal("gem_collected"):
		instance.connect("gem_collected", Callable(self, "_on_gem_collected"))

func _on_health_pack_used():
	call_deferred("spawner", cherry)

func _on_gem_collected():
	call_deferred("spawner", gems)

func _respawn_enemy():
	call_deferred("enemy_spawner")

# -------------------------------
# Quit menu buttons
# -------------------------------
func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	_unpause_game()
