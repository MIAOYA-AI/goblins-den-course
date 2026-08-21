extends PlayerState
class_name PlayerStateThrowing

var is_throw_weapon:bool=false

func _ready() -> void:
	if player.equipment_component.has_furniture():
		player.animation_player.play("throw_furniture")
		player.equipment_component.throw_furniture()
	elif player.equipment_component.has_weapon():
		is_throw_weapon=true
		player.animation_player.play("throw_weapon")
	await player.animation_player.animation_finished
	# 武器在动画播完后再扔
	if player.equipment_component.has_weapon() and is_throw_weapon:
		player.equipment_component.throw_weapon()
	player.equipment_component.set_shield_visible(true)
	player.equipment_component.set_weapon_visible(true)
	transition_state(Player.State.MOVING)
