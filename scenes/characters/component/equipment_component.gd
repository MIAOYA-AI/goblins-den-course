extends Node3D
class_name EquipmentComponent

const EQUIPED_ITEM_PREFAB:=preload("res://scenes/equipment/equiped_item.tscn")
const THROW_ITEM_PREFAB:=preload("res://scenes/equipment/thrown_item.tscn")

@export var furniture_data:FurnitureData
@export var furniture_placeholder:Node3D
@export var close_weapon_deep:bool
@export var weapon_spawn:Node3D
@export var weapon_data:WeaponData
@export var weapon_placeholder:Node3D
@export var weapon_reach_raycast:RayCast3D
@export var shield_data:ShieldData
@export var shield_placeholder:Node3D

func _ready() -> void:
	if weapon_data!=null:
		equip_weapon(weapon_data)
	if shield_data!=null:
		equip_shield(shield_data)
		
func equip_weapon(data:WeaponData,pickup_transform:Transform3D=Transform3D.IDENTITY)-> void:
	# 先清空手上的装备
	if has_weapon():
		throw_weapon(true)
	
	# 引用同一个资源时属性是全局共享的 因此这里需要创建一个副本
	weapon_data=data.duplicate()
	var weapon:=EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	weapon.weapon_data=data
	weapon.close_deep=close_weapon_deep
	weapon_placeholder.add_child(weapon)
	# 将攻击判定射线设为武器攻击距离
	weapon_reach_raycast.target_position.z=-sqrt(weapon_data.reach)
	# 先将武器设为拾取物品的位置与旋转 然后使用动画让变换归零
	if pickup_transform!=Transform3D.IDENTITY:
		# 拾取变换可能携带动画骨骼残留的非均匀缩放 正交归一将其剥离
		weapon.global_transform=Transform3D(pickup_transform.basis.orthonormalized(),pickup_transform.origin)
		animate_to_hand(weapon)
		
func equip_shield(data:ShieldData,pickup_transform:Transform3D=Transform3D.IDENTITY)-> void:
	if has_shield():
		throw_shield()
	
	shield_data=data.duplicate()
	var shield:=EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	shield.shield_data=data
	shield.close_deep=close_weapon_deep
	shield_placeholder.add_child(shield)
	if pickup_transform!=Transform3D.IDENTITY:
		# 同 equip_weapon 剥离可能被动画污染的非均匀缩放
		#shield.global_transform=Transform3D(pickup_transform.basis.orthonormalized(),pickup_transform.origin)
		#拾取动画最后一帧scale没有归一导致缩放污染使拾取的物品变大 修改动画后解决 也可用以上代码解决
		shield.global_transform = pickup_transform
		animate_to_hand(shield)
		
func equip_furniture(data:FurnitureData,pickup_transform:Transform3D=Transform3D.IDENTITY)-> void:
	# 先清空手上的装备
	if has_weapon():
		set_weapon_visible(false)
	
	if has_shield():
		set_shield_visible(false)

	# 引用同一个资源时属性是全局共享的 因此这里需要创建一个副本
	furniture_data=data.duplicate()
	var furniture:=EQUIPED_ITEM_PREFAB.instantiate() as EquipedItem
	furniture.furniture_data=data
	furniture.close_deep=close_weapon_deep
	furniture_placeholder.add_child(furniture)
	# 先将武器设为拾取物品的位置与旋转 然后使用动画让变换归零
	if pickup_transform!=Transform3D.IDENTITY:
		# 拾取变换可能携带动画骨骼残留的非均匀缩放 正交归一将其剥离
		furniture.global_transform=Transform3D(pickup_transform.basis.orthonormalized(),pickup_transform.origin)
		animate_to_hand(furniture)
		
func has_weapon() -> bool:
	return weapon_data != null and weapon_placeholder!=null and weapon_placeholder.get_child_count()>0

func get_weapon() -> EquipedItem:
	if has_weapon():
		return weapon_placeholder.get_child(0) as EquipedItem
	else:
		return null

func set_weapon_visible(flag:bool) -> void:
	if has_weapon():
		get_weapon().visible=flag
	
func has_shield() -> bool:
	return shield_data!=null and shield_placeholder!=null and shield_placeholder.get_child_count()>0

func get_shield() -> EquipedItem:
	if has_shield():
		return shield_placeholder.get_child(0) as EquipedItem
	else:
		return null
		
func set_shield_visible(flag:bool) -> void:
	if has_shield():
		get_shield().visible=flag
		
func has_furniture() -> bool:
	return furniture_data!=null and furniture_placeholder!=null and furniture_placeholder.get_child_count()>0
	
func get_furniture() -> EquipedItem:
	if has_furniture():
		return furniture_placeholder.get_child(0) as EquipedItem
	else:
		return null

func animate_to_hand(equiped_item:Node3D) -> void:
	var tween:=equiped_item.create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(equiped_item,"position",Vector3.ZERO,0.4)
	tween.parallel().tween_property(equiped_item,"rotation",Vector3.ZERO,0.2)
	
func throw_weapon(is_drop:bool=false)-> void:
	if has_weapon():
		var throw_item:ThrownItem= THROW_ITEM_PREFAB.instantiate() as ThrownItem
		throw_item.is_being_dropped=is_drop
		throw_item.weapon_data=weapon_data
		if weapon_spawn!=null:
			throw_item.global_transform=weapon_spawn.global_transform
		else:
			throw_item.global_transform=get_weapon().global_transform
		GameState.current_level.add_child(throw_item)
		weapon_data=null
		weapon_placeholder.get_child(0).queue_free()

func throw_shield() -> void:
	if has_shield():
		var throw_item:ThrownItem= THROW_ITEM_PREFAB.instantiate() as ThrownItem
		throw_item.is_being_dropped=true
		throw_item.shield_data=shield_data
		# 使用盾自身的变换（原来误用 get_weapon() 会在未持武器时空引用崩溃）
		# 并剥离动画骨骼残留的缩放 防止落地物品携带污染缩放
		var shield_transform:Transform3D=(shield_placeholder.get_child(0) as Node3D).global_transform
		throw_item.global_transform=Transform3D(shield_transform.basis.orthonormalized(),shield_transform.origin)
		GameState.current_level.add_child(throw_item)
		shield_data=null
		shield_placeholder.get_child(0).queue_free()
		
func throw_furniture()->void:
	if has_furniture():
		var throw_item:ThrownItem= THROW_ITEM_PREFAB.instantiate() as ThrownItem
		throw_item.is_being_dropped=false
		throw_item.furniture_data=furniture_data
		throw_item.global_transform=get_furniture().global_transform
		GameState.current_level.add_child(throw_item)
		furniture_data=null
		furniture_placeholder.get_child(0).queue_free()
