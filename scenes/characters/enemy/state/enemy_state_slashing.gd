extends EnemyState
class_name EnemyStateSlashing

func _enter_tree() -> void:
	enemy.animation_player.play("slash")
	if enemy.weapon_reach_raycast.is_colliding():
		var collider:=enemy.weapon_reach_raycast.get_collider() as Player
		if collider is Player and collider.state==Player.State.BLOCK:
			var state_data:EnemyStateData=EnemyStateData.new()
			var push_direction:=(enemy.global_position-collider.global_position).normalized()
			state_data.impulse_direction=push_direction
			transition_state(enemy.State.STUUNED,state_data)
			return
	await enemy.animation_player.animation_finished
	transition_state(enemy.State.MOVING)
