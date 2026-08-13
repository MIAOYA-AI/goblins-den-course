extends Node3D
class_name EquipmentComponent

const EQUIPED_ITEM_PREFAB:=preload("res://scenes/equipment/equiped_item.tscn")
const THROW_ITEM_PREFAB:=preload("res://scenes/equipment/thrown_item.tscn")

@export var close_weapon_deep:bool
@export var weapon_spawn:Node3D
@export var weapon_data:WeaponData
@export var weapon_placeholder:Node3D

func _ready() -> void:
	if weapon_data!=null:
		equip_weapon(weapon_data)
		
func equip_weapon(data:WeaponData,pickup_transform:Transform3D=Transform3D.IDENTITY)-> void:
	# 先清空手上的装备
	if has_weapon():
		throw_object(true)
	
	# 引用同一个资源时属性是全局共享的 因此这里需要创建一个副本
	weapon_data=data.duplicate()
	var weapon:=EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	weapon.weapon_data=data
	weapon.close_deep=close_weapon_deep
	weapon_placeholder.add_child(weapon)
	if pickup_transform!=Transform3D.IDENTITY:
		weapon.global_transform=pickup_transform
		animate_to_hand(weapon)
		
func has_weapon() -> bool:
	return weapon_data != null and weapon_placeholder.get_child_count()>0

func get_equip() -> EquipedItem:
	if has_weapon():
		return weapon_placeholder.get_child(0) as EquipedItem
	else:
		return null

func animate_to_hand(equiped_item:Node3D) -> void:
	var tween:=equiped_item.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(equiped_item,"position",Vector3.ZERO,0.4)
	tween.parallel().tween_property(equiped_item,"rotation",Vector3.ZERO,0.2)
	
func throw_object(is_drop:bool=false)-> void:
	if has_weapon():
		var throw_item:ThrownItem= THROW_ITEM_PREFAB.instantiate() as ThrownItem
		throw_item.is_being_dropped=is_drop
		throw_item.weapon_data=weapon_data
		if weapon_spawn!=null:
			throw_item.global_transform=weapon_spawn.global_transform
		else:
			throw_item.global_transform=get_equip().global_transform
		GameState.current_level.add_child(throw_item)
		weapon_data=null
		weapon_placeholder.get_child(0).queue_free()
