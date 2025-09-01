extends Control

@onready var player = $"../../Player"
@onready var score_disp = $Gem_texture/Score
@onready var health_disp = $Health

func _ready():
	player.health_changed.connect(update_health_disp)
	player.score_update.connect(update_score_disp)
	# Update display immediately after connecting
	update_health_disp(player.health)
	update_score_disp(player.points)

func update_health_disp(health : int):
	health_disp.text = "Health: %d" % health

func update_score_disp(score : int):
	score_disp.text = "x " + str(score)
