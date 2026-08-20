extends Node3D
@onready var body_detection: Area3D = %BodyDetection

func _ready() -> void:
	body_detection.body_entered.connect(on_body_entered)
	
func on_body_entered(body:CharacterBody3D) -> void:
	body.take_trap_damage()
