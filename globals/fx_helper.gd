extends Node

const BLOODFX:=preload("res://fx/blood_spurt.tscn")

func release_blood(position:Vector3,show_sparks:bool) -> void:
	var blood_fx:=BLOODFX.instantiate() as BloodSpurt
	blood_fx.show_sparks=show_sparks
	GameState.current_level.add_child(blood_fx)
	blood_fx.global_position=position

func release_metal_spark(position:Vector3) -> void:
	pass
