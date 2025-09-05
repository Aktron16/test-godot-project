extends Control

@export var player_path : NodePath
@onready var player: Player = get_node(player_path)
@onready var score_disp: Label = $Gem_texture/Score
@onready var health_label: Label = $VBoxContainer/Health_bar/Health
@onready var health_bar: ProgressBar = $VBoxContainer/Health_bar
@onready var speed_bar: ProgressBar = $VBoxContainer/Speed_bar
@onready var speed_label: Label = $VBoxContainer/Speed_bar/Speed

func _ready():
	if not player:
		push_error("HUD could not find Player node!")
		return

	# Only connect if the node actually has the signal
	if player.has_signal("health_changed"):
		player.connect("health_changed",Callable(self, "_on_health_changed"))
	if player.has_signal("max_health_changed"):
		player.connect("max_health_changed",Callable(self, "_on_max_health_changed"))
	if player.has_signal("speed_n_max_speed_change"):
		player.connect("speed_n_max_speed_change",Callable(self, "update_speed_disp"))
	if not PointSystem.score_update.is_connected(update_score_disp):
		PointSystem.score_update.connect(update_score_disp)

	# Initial update after Player + PointSystem are ready
	call_deferred("_update_initial_ui")

func _on_health_changed(new_health: int):
	update_health_disp(new_health, player.max_health)

func _on_max_health_changed(new_max_health: int):
	update_health_disp(player.health, new_max_health)

func _update_initial_ui():
	update_health_disp(player.health, player.max_health)
	update_score_disp(PointSystem.points)
	update_speed_disp(player.char_speed,player.max_speed)

func update_health_disp(health: int, max_health: int):
	health_label.text = "%d / %d" %[health,max_health]
	health_bar.max_value = max_health
	health_bar.value = health

func update_score_disp(score: int):
	score_disp.text = "x " + str(score)

func update_speed_disp(speed : int,max_speed : int):
	speed_label.text = "    Speed Percentage (%d / %d)" % [speed, max_speed]
	speed_bar.max_value = max_speed
	speed_bar.value = speed
