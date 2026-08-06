extends Node3D
class_name EquipedItem

const ZCLIP_MATERIAL:=preload("res://materials/zclip_material.tres")

@export var close_deep:bool
@export var weapon_data:WeaponData

func _ready() -> void:
	var equiped_object:=weapon_data.waepon_mesh.instantiate()
	if equiped_object!=null:
		add_child(equiped_object)
		var mesh_node:=equiped_object.get_child(0) as MeshInstance3D
		if mesh_node!=null and close_deep:
			mesh_node.material_override=ZCLIP_MATERIAL.duplicate()
