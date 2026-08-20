extends Area3D
class_name SpikesTrap

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
func on_body_entered(body:CharacterBody3D) -> void:
	body.take_trap_damage()
