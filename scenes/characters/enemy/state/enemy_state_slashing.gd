extends EnemyState
class_name EnemyStateSlashing

func _enter_tree() -> void:
	enemy.animation_player.play("slash")
	await enemy.animation_player.animation_finished
	transition_state(enemy.State.MOVING)
	
func _physics_process(delta: float) -> void:
	if enemy.weapon_reach_raycast.is_colliding():
		var collider:=enemy.weapon_reach_raycast.get_collider() as Player
		if collider is Player:
			if !collider.can_get_hurt():
				GameEvents.impact_felt.emit(GameEvents.ImpactIntensity.LOW)
				var state_data:EnemyStateData=EnemyStateData.new()
				var push_direction:=(enemy.global_position-collider.global_position).normalized()
				state_data.impulse_direction=push_direction
				transition_state(enemy.State.STUUNED,state_data)
			#collider.try_receive_hit(enemy,enemy.equipment_component.weapon_data.get_damage_dealt())
