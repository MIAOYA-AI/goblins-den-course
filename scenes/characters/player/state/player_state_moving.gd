extends PlayerState
class_name PlayerStateMoving

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use") and player.can_pickup_object():
		transition_state(Player.State.PICKING_UP)
	if Input.is_action_just_pressed("throw"):
		transition_state(Player.State.THROWING)
	if Input.is_action_just_pressed("action"):
		transition_state(Player.State.ATTACKING)

func _physics_process(delta: float) -> void:
	player.process_movement(delta)
	var horizontal_velocity:Vector3=Vector3(player.velocity.x,0,player.velocity.y)
	if horizontal_velocity.length_squared()>0.1 and player.is_on_floor():
		player.animation_player.play("run")
	else:
		player.animation_player.play("idle")
