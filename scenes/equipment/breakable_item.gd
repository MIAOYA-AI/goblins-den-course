extends Node3D
class_name BreakableItem

const EXPLOSION_FORCE:=3.0

@export var furniture_data:FurnitureData

var breakable_object:Node3D = null

func _ready() -> void:
	if furniture_data!=null:
		breakable_object=furniture_data.glb_fragments_mesh.instantiate()
		#var all_collision_shape:=find_children("*", "CollisionShape3D", true, false)
		add_child(breakable_object)
		for fragment:RigidBody3D in breakable_object.get_children():
			fragment.set_collision_layer_value(1,false)
			
func explode() -> void:
	if breakable_object!=null:
		for fragment:RigidBody3D in breakable_object.get_children():
			fragment.apply_impulse(fragment.position*EXPLOSION_FORCE,global_position)
			GameEvents.impact_felt.emit(GameEvents.ImpactIntensity.LOW)
