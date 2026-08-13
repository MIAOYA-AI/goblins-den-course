extends PlayerState
class_name PlayerStateAttacking

const TIMEREMITDAMAGE:float=0.3

func _enter_tree() -> void:
	player.animation_player.play("slash")
	if player.weapon_reach_raycast.is_colliding() and player.weapon_reach_raycast.get_collider() is Enemy:
		var timer :=get_tree().create_timer(TIMEREMITDAMAGE)
		timer.timeout.connect(emit_damage)
	await player.animation_player.animation_finished
	transition_state(Player.State.MOVING)

func emit_damage() -> void:
	var damage:=player.equipment_component.weapon_data.get_damage_dealt()
	var enemy:=player.weapon_reach_raycast.get_collider() as Enemy
	if enemy!=null:
		var impact_direction=(enemy.global_position-player.global_position).normalized()
		(player.weapon_reach_raycast.get_collider() as Enemy).try_recrive_hit(damage,impact_direction)
