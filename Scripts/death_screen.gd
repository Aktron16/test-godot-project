extends Control

@onready var label: Label = $Panel/VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.modulate = Color.TRANSPARENT
	fade_in(2.0)

func fade_in(duration : float):
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0 , duration)
	tween.play()

func _on_play_again_pressed() -> void:
	PointSystem.reset()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
