extends Node
class_name player_upgrades

const HEALTH_N_SPEED_RES = preload("res://Resources/health_n_speed_res.tres")

signal change_max_health(new_max_health)
signal change_max_speed(new_max_speed)
signal change_speed(new_speed)

# Values
var max_health: int = HEALTH_N_SPEED_RES.max_health
var maxspeed: int = HEALTH_N_SPEED_RES.max_speed
var _speed: int = HEALTH_N_SPEED_RES.speed
var speed: int:
	get: return _speed
	set(value): 
		_speed = clamp(value, 10, maxspeed)
		emit_signal("change_speed", _speed)

# Buttons
@onready var decrease_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/decrease_health_bt
@onready var increase_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/increase_health_bt

@onready var decrease_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/decrease_maxspeed_bt
@onready var increase_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/increase_maxspeed_bt

@onready var decrease_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/decrease_speed_bt
@onready var increase_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/increase_speed_bt

func _ready():
	# Hide decrease buttons by default
	decrease_health_bt.visible = false
	decrease_maxspeed_bt.visible = false
	decrease_speed_bt.visible = false

	# Connect buttons safely
	_connect_button(increase_health_bt, _on_increase_health_pressed)
	_connect_button(decrease_health_bt, _on_decrease_health_pressed)

	_connect_button(increase_maxspeed_bt, _on_increase_maxspeed_pressed)
	_connect_button(decrease_maxspeed_bt, _on_decrease_maxspeed_pressed)

	_connect_button(increase_speed_bt, _on_increase_speed_pressed)
	_connect_button(decrease_speed_bt, _on_decrease_speed_pressed)

func _connect_button(bt: Button, func_ref: Callable) -> void:
	if not bt.pressed.is_connected(func_ref):
		bt.pressed.connect(func_ref)

func _process(_delta: float) -> void:
	# Enable/disable increase buttons based on points & limits
	var can_upgrade = PointSystem.points >= 10
	increase_health_bt.disabled = not can_upgrade
	increase_maxspeed_bt.disabled = not can_upgrade
	increase_speed_bt.disabled = not can_upgrade or speed >= maxspeed


# Helper to change value safely
func _change_value(ref: int, delta: int, min_val: int, max_val: int) -> int:
	return clamp(ref + delta, min_val, max_val)

# Health
func _on_increase_health_pressed():
	if PointSystem.points >= 10:
		PointSystem.score_subtract(10)
		max_health = _change_value(max_health, 10, 10, 1000)
		emit_signal("change_max_health", max_health)

func _on_decrease_health_pressed():
	max_health = _change_value(max_health, -10, 10, 1000)
	emit_signal("change_max_health", max_health)

# Max speed
func _on_increase_maxspeed_pressed():
	if PointSystem.points >= 10:
		PointSystem.score_subtract(10)
		maxspeed = _change_value(maxspeed, 5, 10, 1000)
		emit_signal("change_max_speed", maxspeed)

func _on_decrease_maxspeed_pressed():
	maxspeed = _change_value(maxspeed, -5, 10, 1000)
	emit_signal("change_max_speed", maxspeed)

# Speed
func _on_increase_speed_pressed():
	if PointSystem.points >= 10:
		PointSystem.score_subtract(10)
		speed = _change_value(speed, 5, 10, maxspeed)

func _on_decrease_speed_pressed():
	speed = _change_value(speed, -5, 10, maxspeed)
