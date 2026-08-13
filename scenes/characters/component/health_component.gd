extends Node
class_name HealthComponent

@export var max_health:int
@export var cur_health:int

func _ready() -> void:
	cur_health=max_health

func take_damage(damage:int) -> void:
	cur_health=clampi(cur_health-damage,0,max_health)
	
func is_dead() -> bool:
	return cur_health==0
