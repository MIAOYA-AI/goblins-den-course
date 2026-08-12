extends PlayerState
class_name PlayerStatePickingUp

func _enter_tree() -> void:
	var pickable_object:=player.current_focused_item
	player.animation_player.play("pick_up")
	await player.animation_player.animation_finished
	if pickable_object.weapon_data!=null:
		player.equipment_component.equip_weapon(pickable_object.weapon_data,pickable_object.global_transform)
		pickable_object.queue_free()
	transition_state(Player.State.MOVING)
