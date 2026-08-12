extends Resource
class_name WeaponData

@export var name:String
@export var condition:int
@export var max_condition:int
@export var damage_min:int
@export var damage_max:int
@export var reach:float
@export var throw_rotation_speed:float
@export var throw_movement_speed:float
@export var waepon_mesh:PackedScene
@export var implale_local_translations:Vector3
@export var implate_local_rotation:float

func get_damage_dealt()->int:
	return randi_range(damage_min,damage_max)

func decrease_condition(amount:int)-> void:
	condition=clampi(condition-amount,0,max_condition)
