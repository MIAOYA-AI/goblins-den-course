class_name EnemyStateData

const IMPALE_INTENSITY:=100.0
const EQUIPED_ITEM_PREFAB:=preload("res://scenes/equipment/equiped_item.tscn")
const SIMULATION_TIME:=3.0

var impaled_item_weapon_data:WeaponData
var thrown_item_basis:Basis
var impulse_direction:Vector3=Vector3.ZERO
var damage:int
