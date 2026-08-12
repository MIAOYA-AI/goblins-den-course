extends EnemyState
class_name EnemyStateImpaled

func _enter_tree() -> void:
	var impaled_item:=enemy.EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	impaled_item.weapon_data=enemy.impaled_item_weapon_data
	enemy.physical_bone_torso.add_child(impaled_item)
	impaled_item.global_basis=enemy.thrown_item_basis
	impaled_item.translate_object_local(impaled_item.weapon_data.implale_local_translations)
	impaled_item.rotate_object_local(Vector3.UP,impaled_item.weapon_data.implate_local_rotation)
	enemy.death_impulse=enemy.thrown_item_basis*Vector3.FORWARD*enemy.IMPALE_INTENSITY+Vector3.UP*enemy.IMPALE_INTENSITY
	transition_state(Enemy.State.DEATH)
