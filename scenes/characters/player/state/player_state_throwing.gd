extends PlayerState
class_name PlayerStateThrowing

func _ready() -> void:
	player.animation_player.play("throw_weapon")
	await player.animation_player.animation_finished
	player.equipment_component.throw_weapon()
	transition_state(Player.State.MOVING)
