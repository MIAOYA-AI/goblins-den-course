extends EnemyState
class_name EnemyStateBlock

func _ready() -> void:
	enemy.animation_player.play("block")
	await enemy.animation_player.animation_finished
	transition_state(enemy.State.MOVING)
