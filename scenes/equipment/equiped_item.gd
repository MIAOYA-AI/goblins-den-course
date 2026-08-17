extends Node3D
class_name EquipedItem

const ZCLIP_MATERIAL:=preload("res://materials/zclip_material.tres")

@export var close_deep:bool
@export var weapon_data:WeaponData
@export var shield_data:ShieldData

func _ready() -> void:
	var equiped_object:Node3D
	if weapon_data:
		equiped_object=weapon_data.waepon_mesh.instantiate()
	elif shield_data:
		equiped_object=shield_data.shield_mesh.instantiate()
	if equiped_object!=null:
		add_child(equiped_object)
		var mesh_node:=equiped_object.get_child(0) as MeshInstance3D
		if mesh_node!=null and close_deep:
			mesh_node.material_override=ZCLIP_MATERIAL.duplicate()
