extends Node2D

@export var health_points := 10
@onready var eat_cherry_sfx: AudioStreamPlayer = $eat_cherry_sfx

signal health_pack_used

func _ready() -> void:
	get_node("AnimatedSprite2D").play("default")

func _on_area_2d_body_entered(body: Node) -> void:
	if body.name == "Player" and body is CharacterBody2D:
		if body.has_method("heal"):
			body.heal(health_points)
			emit_signal("health_pack_used")
			eat_cherry_sfx.play()
			hide()
			await eat_cherry_sfx.finished
			queue_free()
