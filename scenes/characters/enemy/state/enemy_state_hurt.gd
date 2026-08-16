extends EnemyState
class_name EnemyStateHurt

func _enter_tree() -> void:
	enemy.health_component.take_damage(state_data.damage)
	FxHelper.release_blood(enemy.physical_bone_torso.global_position,false)
	if enemy.health_component.is_dead():
		state_data.impulse_direction=state_data.impulse_direction*state_data.IMPALE_INTENSITY+Vector3.UP*state_data.IMPALE_INTENSITY
		transition_state(enemy.State.DEATH,state_data)
		return
	GameEvents.impact_felt.emit(GameEvents.ImpactIntensity.LOW)
	enemy.pushback_force=state_data.impulse_direction*10
	enemy.animation_player.play("hurt")
	await enemy.animation_player.animation_finished
	transition_state(enemy.State.MOVING)
