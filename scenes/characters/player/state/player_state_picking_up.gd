extends PlayerState
class_name PlayerStatePickingUp

func _process(delta: float) -> void:
	if player.Input.is_action_just_pressed("use") and player.can_pickup_object():
		pickup_object()

func _enter_tree() -> void:
	var pickable_object:=player.current_focused_item
	if pickable_object.weapon_data!=null:
		player.equipment_component.equip_weapon(pickable_object.weapon_data,pickable_object.global_transform)
		pickable_object.queue_free()
		
func pickup_object()->void:
	var pickable_object:=player.current_focused_item
	if pickable_object.weapon_data!=null:
		player.equipment_component.equip_weapon(pickable_object.weapon_data,pickable_object.global_transform)
		pickable_object.queue_free()
