extends PlayerState
class_name PlayerStateKicking

func _ready() -> void:
	player.animation_player.play("kick")
	if player.kick_ray_cast.is_colliding():
		var collider=player.kick_ray_cast.get_collider() as Node
		if collider is Door:
			(collider as Door).open(player.global_position)
		elif collider is Enemy:
			(collider as Enemy).on_kicked()
	await player.animation_player.animation_finished
	transition_state(Player.State.MOVING)
	
func _physics_process(delta: float) -> void:
	player.velocity=player.velocity.move_toward(Vector3.ZERO,delta*DECELERATION)
