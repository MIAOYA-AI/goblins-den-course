extends Node3D
class_name MetalSpark

@onready var sparks: GPUParticles3D = %Sparks
@onready var flash: GPUParticles3D = %Flash

func _ready() -> void:
	#一次性特效 播完后自释放
	flash.emitting=true
	sparks.emitting=true
	await sparks.finished
	queue_free()
