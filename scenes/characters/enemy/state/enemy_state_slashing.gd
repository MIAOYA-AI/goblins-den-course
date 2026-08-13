extends EnemyState
class_name EnemyStateSlashing

func _enter_tree() -> void:
	enemy.animation_player.play("slash")
	await enemy.animation_player.animation_finished
	transition_state(enemy.State.MOVING)
