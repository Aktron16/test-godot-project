extends Node2D

@export var points := 2
@onready var gem_pick_sfx: AudioStreamPlayer = $gem_pick_sfx

signal gem_collected

func _ready() -> void:
	get_node("AnimatedSprite2D").play("default")

func _on_area_2d_body_entered(body: Node) -> void:
	if body.name == "Player" and body is CharacterBody2D:
		PointSystem.score_add(points)
		emit_signal("gem_collected")
		gem_pick_sfx.play()
		hide()
		await gem_pick_sfx.finished
		queue_free()
