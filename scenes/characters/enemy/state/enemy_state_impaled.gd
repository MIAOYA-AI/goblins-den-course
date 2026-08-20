extends EnemyState
class_name EnemyStateImpaled

const BLOODFX:=preload("res://fx/blood_spurt.tscn")

func _enter_tree() -> void:
	var impaled_item:=state_data.EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	impaled_item.weapon_data=state_data.impaled_item_weapon_data
	enemy.physical_bone_torso.add_child(impaled_item)
	FxHelper.release_blood(enemy.physical_bone_torso.global_position,true)
	impaled_item.global_basis=state_data.thrown_item_basis
	impaled_item.translate_object_local(impaled_item.weapon_data.implale_local_translations)
	impaled_item.rotate_object_local(Vector3.UP,impaled_item.weapon_data.implate_local_rotation)
	state_data.impulse_direction=state_data.thrown_item_basis*Vector3.FORWARD*state_data.IMPALE_INTENSITY+Vector3.UP*state_data.IMPALE_INTENSITY
	# 击中敌人时暂停几帧并震动屏幕 效果不佳 时间点不对 体感像卡顿
	#GameEvents.impact_felt.emit(GameEvents.ImpactIntensity.MEDIUM)
	transition_state(Enemy.State.DEATH,state_data)
