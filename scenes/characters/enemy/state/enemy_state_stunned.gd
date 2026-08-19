extends EnemyState
class_name EnemyStateStunned

const STUNNEDTIME:=1.5

func _enter_tree() -> void:
	enemy.pushback_force=state_data.impulse_direction*10
	enemy.animation_player.play("stunned")
	var timer :=get_tree().create_timer(STUNNEDTIME)
	timer.timeout.connect(stop_stunned)

func stop_stunned() -> void:
	transition_state(enemy.State.MOVING)
	
func _physics_process(delta: float) -> void:
	enemy.velocity=enemy.velocity.move_toward(Vector3.ZERO,delta*DECELERATION)
