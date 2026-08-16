extends Node3D
class_name BloodSpurt

@onready var blood: GPUParticles3D = %Blood
@onready var sparks: GPUParticles3D = %Sparks

var show_sparks:=true

func _ready() -> void:
	if show_sparks:
		sparks.emitting=true
	blood.emitting=true
	await blood.finished
	queue_free()
