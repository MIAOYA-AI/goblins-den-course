extends Resource
class_name ShieldData

# 应该创建一个物品数据基类 方便代码重用
@export var name:String
@export var shield_mesh:PackedScene
@export var condition:float
@export var max_condition:int

func decrease_condition(amount:int) -> void:
	condition=clampi(condition-amount,0,max_condition)
