extends ParallaxBackground

var scroll_speed: float = 100.0
func _process(delta: float) -> void:
	scroll_offset.x -= scroll_speed * delta
