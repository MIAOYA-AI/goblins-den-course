extends Node
class_name EnemyState

var enemy:Enemy

signal transition_requested(new_state:Enemy.State)

func _init(source_enemy:Enemy) -> void:
	enemy=source_enemy

func transition_state(new_state:Enemy.State) -> void:
	transition_requested.emit(new_state)
