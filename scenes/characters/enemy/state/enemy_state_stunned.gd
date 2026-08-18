extends EnemyState
class_name EnemyStateStunned

const STUNNEDTIME:=2.0

func _enter_tree() -> void:
	enemy.animation_player.play("stunned")
	var timer :=get_tree().create_timer(STUNNEDTIME)
	timer.timeout.connect(stop_stunned)

func stop_stunned() -> void:
	transition_state(enemy.State.MOVING)
