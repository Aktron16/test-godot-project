extends Node

class_name point_system

signal score_update(new_score)

var _points: int = 0
var points : int :
	get:
		return _points
	set(value):
		_points = clamp(value , 0 , 1000)
		emit_signal("score_update", _points)

func _ready() -> void:
	emit_signal("score_update",points)

func score_add(point):
	points += point
	#print(points)

func score_subtract(point):
	points -= point
	#print(points)
	
