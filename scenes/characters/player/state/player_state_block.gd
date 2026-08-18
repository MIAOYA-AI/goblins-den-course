extends PlayerState
class_name PlayerStateBlock

func _ready() -> void:
	player.animation_player.play("block")
	await player.animation_player.animation_finished
	transition_state(Player.State.MOVING)
