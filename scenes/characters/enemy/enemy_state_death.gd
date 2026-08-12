extends EnemyState
class_name EnemyStateDeath

func _enter_tree() -> void:
	enemy.collision_shape.disabled=true
	enemy.skeleton_simulator.active=true
	enemy.skeleton_simulator.physical_bones_start_simulation()
	enemy.physical_bone_torso.apply_impulse(enemy.death_impulse)
	var timer :=get_tree().create_timer(enemy.SIMULATION_TIME)
	timer.timeout.connect(freeze_ragdoll)

func freeze_ragdoll() -> void:
	for child in enemy.skeleton_simulator.get_children():
		if child is PhysicalBone3D:
			var bone := child as PhysicalBone3D
			var bone_rid:=bone.get_rid()
			PhysicsServer3D.body_set_state(bone_rid,PhysicsServer3D.BODY_STATE_SLEEPING,true)
