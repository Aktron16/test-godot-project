extends Node2D  # or 'Control' if you're using UI as the base

@onready var canvas = $Confirm_Quit
@onready var Quit_button = $Quit
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
var scroll_speed: float = 100.0

func _ready():
	canvas.visible = false
	
func _on_quit_pressed() -> void:
	_open_exit()

func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	_close_exit()

func _process(delta: float) -> void:
	parallax_background.scroll_offset.x -= scroll_speed * delta
	if Input.is_action_just_pressed("ui_cancel"):  # Default action for Escape
		if canvas.visible == true:
			_close_exit()
		else:
			_open_exit()

func _open_exit():
	canvas.visible = true

func _close_exit():
	canvas.visible = false


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")
