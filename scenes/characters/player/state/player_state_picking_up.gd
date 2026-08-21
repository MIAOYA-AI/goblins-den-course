extends PlayerState
class_name PlayerStatePickingUp

var is_carrying:bool=false

func _enter_tree() -> void:
	var pickable_object:=player.current_focused_item
	if pickable_object.weapon_data!=null:
		player.animation_player.play("pick_up")
		player.equipment_component.equip_weapon(pickable_object.weapon_data,pickable_object.global_transform)
		player.animation_player.animation_finished.connect(on_animation_finished)
	elif pickable_object.shield_data!=null:
		player.animation_player.play("pick_up")
		player.equipment_component.equip_shield(pickable_object.shield_data,pickable_object.global_transform)
		player.animation_player.animation_finished.connect(on_animation_finished)
	elif pickable_object.furniture_data!=null:
		player.animation_player.play("lift")
		player.equipment_component.equip_furniture(pickable_object.furniture_data,pickable_object.global_transform)
		is_carrying=true
	pickable_object.queue_free()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use") and is_carrying:
		transition_state(Player.State.THROWING)
	
func _physics_process(delta: float) -> void:
	player.process_movement(delta)
	player.velocity*=0.7

func on_animation_finished(_anim_name:String) -> void:
	transition_state(Player.State.MOVING)
