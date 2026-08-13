extends EnemyState
class_name EnemyStateDeath

func _enter_tree() -> void:
	#丢下手里武器
	enemy.equipment_component.throw_object(true)
	enemy.collision_shape.disabled=true
	enemy.skeleton_simulator.active=true
	enemy.skeleton_simulator.physical_bones_start_simulation()
	enemy.physical_bone_torso.apply_impulse(state_data.impulse_direction)
	var timer :=get_tree().create_timer(state_data.SIMULATION_TIME)
	timer.timeout.connect(freeze_ragdoll)

func freeze_ragdoll() -> void:
	for child in enemy.skeleton_simulator.get_children():
		if child is PhysicalBone3D:
			var bone := child as PhysicalBone3D
			var bone_rid:=bone.get_rid()
			PhysicsServer3D.body_set_state(bone_rid,PhysicsServer3D.BODY_STATE_SLEEPING,true)
