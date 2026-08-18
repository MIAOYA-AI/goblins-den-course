extends PlayerState
class_name PlayerStateKicking

const DECELERATION:float=20

func _ready() -> void:
	player.animation_player.play("kick")
	if player.kick_ray_cast.is_colliding():
		if player.kick_ray_cast.get_collider() is Door:
			(player.kick_ray_cast.get_collider() as Door).open(player.global_position)
		elif player.kick_ray_cast.get_collider() is Enemy:
			(player.kick_ray_cast.get_collider() as Enemy).on_kicked()
	await player.animation_player.animation_finished
	transition_state(Player.State.MOVING)
	
func _physics_process(delta: float) -> void:
	player.velocity=player.velocity.move_toward(Vector3.ZERO,delta*DECELERATION)
