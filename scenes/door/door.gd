extends StaticBody3D
class_name Door

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func open(source_position:Vector3) -> void:
	collision_shape.disabled=true
	# 判断玩家在门的相对位置 也可以传入basis 通过门与玩家的局部-z轴向量来运算判断
	var player_dir:=(source_position-global_position).normalized()
	if player_dir.dot(-global_basis.z)>0:
		animation_player.play("open-left")
	else:
		animation_player.play("open-right")
