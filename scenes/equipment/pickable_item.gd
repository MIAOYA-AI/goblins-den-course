extends StaticBody3D
class_name PickableItem

const HIGHTLIGHT_MATERIAL:=preload("res://materials/hightlight_material.tres")

var mesh_node:MeshInstance3D
@export var furniture_data:FurnitureData
@export var weapon_data:WeaponData
@export var shield_data:ShieldData
@onready var collision_shape: CollisionShape3D = $CollisionShape

var hightlight_material:StandardMaterial3D

func _ready() -> void:
	var pickable_object:Node3D=null
	hightlight_material=HIGHTLIGHT_MATERIAL.duplicate()
	if weapon_data:
		pickable_object=weapon_data.glb_mesh.instantiate()
	elif shield_data:
		pickable_object=shield_data.glb_mesh.instantiate()
	elif furniture_data:
		pickable_object=furniture_data.glb_mesh.instantiate()
	if pickable_object!=null:
		add_child(pickable_object)
		mesh_node=pickable_object.get_child(0) as MeshInstance3D
	if mesh_node!=null:
		collision_shape.shape=mesh_node.mesh.create_convex_shape(false,true)

func hightlight() -> void:
	if mesh_node:
		mesh_node.material_override=hightlight_material
		
func unhightlight() -> void:
	if mesh_node:
		mesh_node.material_override=null
