extends Resource

class_name Enemies

@export var damage : int = 10
@export var speed : int = 20
@export var attack_range : float = 15
@export var attack_cooldown : float = 1.0

func setup(_speed: int, _damage: int, _attack_range : float, _attack_cooldown : float) -> void:
	speed = _speed
	damage = _damage
	attack_range = _attack_range
	attack_cooldown = _attack_cooldown
