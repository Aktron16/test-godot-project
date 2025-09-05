extends Node

class_name player_upgrades

const HEALTH_N_SPEED_RES = preload("res://Resources/health_n_speed_res.tres")

signal change_max_health(mew_max_health)
signal change_max_speed(new_max_speed)
signal change_speed(new_speed)


var max_health : int = HEALTH_N_SPEED_RES.max_health
@onready var decrease_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/decrease_health_bt
@onready var increase_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/increase_health_bt

var maxspeed : int = HEALTH_N_SPEED_RES.max_speed
@onready var decrease_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/decrease_maxspeed_bt
@onready var increase_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/increase_maxspeed_bt

var _speed : int = HEALTH_N_SPEED_RES.speed
var speed : int :
	get:
		return _speed
	set(value_speed):
		_speed = clamp(value_speed, 10, maxspeed)
@onready var decrease_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/decrease_speed_bt
@onready var increase_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/increase_speed_bt

func _ready():
	if decrease_health_bt.visible == true:
		decrease_health_bt.visible = false
	if decrease_maxspeed_bt.visible == true:
		decrease_maxspeed_bt.visible = false
	if decrease_speed_bt.visible == true:
		decrease_speed_bt.visible = false
	
	# Safe connect for health buttons
	if not decrease_health_bt.pressed.is_connected(_on_decrease_health_pressed):
		decrease_health_bt.pressed.connect(_on_decrease_health_pressed)
	if not increase_health_bt.pressed.is_connected(_on_increase_health_pressed):
		increase_health_bt.pressed.connect(_on_increase_health_pressed)
	
	# Safe connect for max speed buttons
	if not decrease_maxspeed_bt.pressed.is_connected(_on_decrease_maxspeed_pressed):
		decrease_maxspeed_bt.pressed.connect(_on_decrease_maxspeed_pressed)
	if not increase_maxspeed_bt.pressed.is_connected(_on_increase_maxspeed_pressed):
		increase_maxspeed_bt.pressed.connect(_on_increase_maxspeed_pressed)
	
	# Safe connect for speed buttons
	if not decrease_speed_bt.pressed.is_connected(_on_decrease_speed_pressed):
		decrease_speed_bt.pressed.connect(_on_decrease_speed_pressed)
	if not increase_speed_bt.pressed.is_connected(_on_increase_speed_pressed):
		increase_speed_bt.pressed.connect(_on_increase_speed_pressed)

func _process(_delta: float) -> void:
	if speed >= maxspeed:
		increase_speed_bt.disabled = true
	else:
		increase_speed_bt.disabled = false

func _on_decrease_health_pressed():
	max_health = max(max_health - 10, 10) # Prevent going below 10
	emit_signal("change_max_health", max_health)

func _on_increase_health_pressed():
	max_health += 10
	emit_signal("change_max_health", max_health)

func _on_decrease_maxspeed_pressed():
	maxspeed = max(maxspeed - 5, 10) # Prevent going below 10
	#print(maxspeed)
	emit_signal("change_max_speed", maxspeed)

func _on_increase_maxspeed_pressed():
	maxspeed += 5
	#print(maxspeed)
	emit_signal("change_max_speed", maxspeed)

func _on_decrease_speed_pressed():
	speed = clamp(speed - 5, 10, maxspeed)
	#print(speed)
	emit_signal("change_speed",speed)

func _on_increase_speed_pressed():
	speed = clamp(speed + 5, 10, maxspeed)
	#print(speed)
	emit_signal("change_speed",speed)
