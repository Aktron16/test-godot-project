extends Node2D

@onready var canvas = $CanvasLayer/Confirm_Quit
@onready var upgrade_screen: player_upgrades = $CanvasLayer/Upgrade_screen

@export var health_pack_amount : int = 20
var cherry = preload("res://Scenes/cherries.tscn")

@export var gems_amount : int = 50
var gems = preload("res://Scenes/gems.tscn")

@export var enemies : int = 10
var ants = preload("res://Scenes/ant.tscn")

func _ready() -> void:
	obj_spawner(cherry, health_pack_amount)
	obj_spawner(gems, gems_amount)
	obj_spawner(ants, enemies)
	canvas.visible = false
	upgrade_screen.visible = false

func rand_coord() -> Vector2:
	return Vector2(randi_range(50, 2070), randi_range(20, 620))

func obj_spawner(obj, amount : int ):
	for i in range(amount):
		spawner(obj, rand_coord())
	#print("Spawned %d cherries" % amount)

func spawner(obj,pos : Vector2):
	var instance = obj.instantiate()
	instance.position = pos
	add_child(instance)
# Connect the signal and replace the pack when it's used
	if instance.has_signal("health_pack_used"):
		instance.connect("health_pack_used", Callable(self, "_on_health_pack_used"))
	if instance.has_signal("gem_collected"):
		instance.connect("gem_collected", Callable(self, "_on_gem_collected"))
	if instance.has_signal("despawn"):
		instance.connect("despawn", Callable(self, "_respawn_enemy"))

func _on_health_pack_used():
	call_deferred("spawner",cherry,rand_coord())

func _on_gem_collected():
	call_deferred("spawner",gems,rand_coord())

func _respawn_enemy():
	call_deferred("spawner",ants,rand_coord())


func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	_close_exit()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):  # Default action for Escape
		canvas.visible = not canvas.visible

func _open_exit():
	canvas.visible = true

func _close_exit():
	canvas.visible = false
