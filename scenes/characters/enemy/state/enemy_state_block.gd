extends EnemyState
class_name EnemyStateBlock



func _ready() -> void:
	#GameEvents.impact_felt.emit(GameEvents.ImpactIntensity.LOW)
	FxHelper.release_metal_spark(enemy.equipment_component.shield_placeholder.global_position)
	enemy.pushback_force=state_data.impulse_direction*10
	enemy.animation_player.play("block")
	#await enemy.animation_player.animation_finished
	#transition_state(enemy.State.MOVING)

func _physics_process(delta: float) -> void:
	enemy.velocity=enemy.velocity.move_toward(Vector3.ZERO,delta*DECELERATION)
	if enemy.velocity==Vector3.ZERO:
		transition_state(enemy.State.MOVING)
