extends PlayerState
class_name PlayerStateBlock

func _ready() -> void:
	player.animation_player.play("block")
	await player.animation_player.animation_finished
	transition_state(Player.State.MOVING)
	
func _physics_process(delta: float) -> void:
	player.velocity=player.velocity.move_toward(Vector3.ZERO,delta*DECELERATION)
