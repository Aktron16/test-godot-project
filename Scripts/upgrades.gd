extends Node

class_name player_upgrades

const HEALTH_N_SPEED_RES = preload("res://Resources/health_n_speed_res.tres")

signal change_max_health(mew_max_health)
signal change_max_speed(new_max_speed)
signal change_speed(new_speed)


@onready var maxhealth : int = HEALTH_N_SPEED_RES.max_health
@onready var decrease_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/decrease_health_bt
@onready var increase_health_bt: Button = $Panel/VBoxContainer/HBoxContainer/increase_health_bt

@onready var maxspeed : int = HEALTH_N_SPEED_RES.max_speed
@onready var decrease_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/decrease_maxspeed_bt
@onready var increase_maxspeed_bt: Button = $Panel/VBoxContainer2/HBoxContainer/increase_maxspeed_bt

@onready var speed : int = HEALTH_N_SPEED_RES.speed :
	set(value_speed):
		speed = clamp(value_speed, 10, maxspeed)
@onready var decrease_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/decrease_speed_bt
@onready var increase_speed_bt: Button = $Panel/VBoxContainer3/HBoxContainer/increase_speed_bt

func _ready():
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

func _on_decrease_health_pressed():
	maxhealth = max(maxhealth - 10, 10) # Prevent going below 10
	emit_signal("change_max_health", maxhealth)

func _on_increase_health_pressed():
	maxhealth += 10
	emit_signal("change_max_health", maxhealth)

func _on_decrease_maxspeed_pressed():
	maxspeed = max(maxspeed - 5, 10) # Prevent going below 10
	#print(maxspeed)
	emit_signal("change_max_speed", maxspeed)

func _on_increase_maxspeed_pressed():
	maxspeed += 5
	#print(maxspeed)
	emit_signal("change_max_speed", maxspeed)

func _on_decrease_speed_pressed():
	speed = max(speed - 5, 10)
	#print(speed)
	emit_signal("change_speed",speed)

func _on_increase_speed_pressed():
	speed += 5
	#print(speed)
	emit_signal("change_speed",speed)
