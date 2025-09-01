extends Node2D

@onready var canvas = $CanvasLayer/Confirm_Quit

@export var health_pack_amount := 20
var cherry = preload("res://Scenes/cherries.tscn")

@export var gems_amount := 50
var gems = preload("res://Scenes/gems.tscn")

func _ready() -> void:
	obj_spawner(cherry, health_pack_amount)
	obj_spawner(gems, gems_amount)
	canvas.visible = false

func rand_coord():
	var x = randi_range(50,2070)
	var y = randi_range(20,620)
	var pos := Vector2(x , y)
	return pos

func obj_spawner(obj, amount):
	for i in amount:
		spawner(obj, rand_coord())
	#print("Spawned %d cherries" % amount)

func spawner(obj,pos):
	var instance = obj.instantiate()
	instance.position = pos
	add_child(instance)
# Connect the signal and replace the pack when it's used
	if instance.has_signal("health_pack_used"):
		instance.connect("health_pack_used", Callable(self, "_on_health_pack_used"))
	if instance.has_signal("gem_collected"):
		instance.connect("gem_collected", Callable(self, "_on_gem_collected"))

func _on_health_pack_used():
	call_deferred("spawner",cherry,rand_coord())

func _on_gem_collected():
	call_deferred("spawner",gems,rand_coord())


func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	_close_exit()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):  # Default action for Escape
		if canvas.visible == true:
			_close_exit()
		else:
			_open_exit()

func _open_exit():
	canvas.visible = true

func _close_exit():
	canvas.visible = false
