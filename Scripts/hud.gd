extends Control

@onready var player = $"../../Player"
@onready var score_disp: Label = $Gem_texture/Score
@onready var health_label: Label = $VBoxContainer/Health_bar/Health
@onready var health_bar: ProgressBar = $VBoxContainer/Health_bar
@onready var speed_bar: ProgressBar = $VBoxContainer/Speed_bar

func _ready():
	# Connect signals
	player.health_changed.connect(func(new_health):
		update_health_disp(new_health, player.max_health)
	)
	player.max_health_changed.connect(func(new_max_health):
		update_health_disp(player.health, new_max_health)
	)
	player.speed_n_max_speed_change.connect(update_speed_disp)
	player.score_update.connect(update_score_disp)

	# Initial update after everything is ready
	call_deferred("_update_initial_ui")

func _update_initial_ui():
	update_health_disp(player.health, player.max_health)
	update_score_disp(player.points)
	update_speed_disp(player.char_speed,player.max_speed)

func update_health_disp(health: int, max_health: int):
	health_label.text = "%d / %d" %[health,max_health]
	health_bar.max_value = max_health
	health_bar.value = health

func update_score_disp(score: int):
	score_disp.text = "x " + str(score)

func update_speed_disp(speed : int,max_speed : int):
	speed_bar.max_value = max_speed
	speed_bar.value = speed
