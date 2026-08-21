extends RigidBody3D
class_name ThrownItem

@export var furniture_data:FurnitureData
@export var weapon_data:WeaponData
@export var shield_data:ShieldData

const PICKABLE_ITEM_PREFAB:=preload("res://scenes/equipment/pickable_item.tscn")
const BREAKABLE_ITEM_PREFAB:=preload("res://scenes/equipment/breakable_item.tscn")

@onready var collision_shape: CollisionShape3D = $CollisionShape

var is_being_dropped:bool=false
var original_basis:Basis

func _ready() -> void:
	var thrown_object:Node3D = null
	original_basis=global_transform.basis
	if weapon_data!=null:
		thrown_object=weapon_data.glb_mesh.instantiate()
	elif shield_data!=null:
		thrown_object=shield_data.glb_mesh.instantiate()
	elif furniture_data!=null:
		thrown_object=furniture_data.glb_mesh.instantiate()
	
	if thrown_object!=null:
		add_child(thrown_object)
		var mesh_node:MeshInstance3D=thrown_object.get_child(0) as MeshInstance3D
		collision_shape.shape=mesh_node.mesh.create_convex_shape()
		if weapon_data!=null and not is_being_dropped:
			gravity_scale=0
			linear_velocity=-global_basis.z*weapon_data.throw_movement_speed
			angular_velocity=-global_basis.y*weapon_data.throw_rotation_speed
		elif furniture_data!=null:
			gravity_scale=1
			linear_velocity=-global_basis.z*furniture_data.throw_movement_speed
			angular_velocity=-global_basis.y*furniture_data.throw_rotation_speed
			
		body_entered.connect(on_body_entered)

func on_body_entered(body:Node) -> void:
	if weapon_data!=null:
		if body is Enemy and not is_being_dropped:
			body.impale(self,original_basis)
		else:
			gravity_scale=1
			if not sleeping_state_changed.is_connected(on_sleep):
				sleeping_state_changed.connect(on_sleep)
	elif furniture_data!=null:
		var breakable_item:BreakableItem=BREAKABLE_ITEM_PREFAB.instantiate()
		breakable_item.furniture_data=furniture_data
		GameState.current_level.add_child(breakable_item)
		breakable_item.global_transform=global_transform
		breakable_item.explode()
		if body is Enemy and not is_being_dropped:
			body.try_stuuned(global_position.direction_to((body as Enemy).global_position))
		queue_free()

func on_sleep() -> void:
	var pickable_item:PickableItem=PICKABLE_ITEM_PREFAB.instantiate()
	if weapon_data!=null:
		pickable_item.weapon_data=weapon_data
	elif shield_data!=null:
		pickable_item.shield_data=shield_data
	elif furniture_data!=null:
		pickable_item.furniture_data=furniture_data
	GameState.current_level.add_child(pickable_item)
	pickable_item.global_transform=global_transform
	queue_free()
