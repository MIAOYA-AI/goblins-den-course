class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var select_ray_cast: RayCast3D = %SelectRayCast
@onready var equipment_component: EquipmentComponent = %EquipmentComponent

const MAX_ANGLE_LOOK_UP:=deg_to_rad(70)
const MAX_ANGLE_LOOK_DOWN:=deg_to_rad(-70)

@export var acceleration:float = 30.0
@export var jump_force:float = 12
@export var gravity:float = 0.98
@export var mouse_sensitivity:float = 0.002
@export var walk_speed:float = 3.0
@export var run_speed:float = 6.0

enum State {MOVING,PICKING_UP,THROWING}
var state:State
var state_node:PlayerState

var current_focused_item:PickableItem=null
var input_dir:=Vector2.ZERO
var run:bool=false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	switch_state(State.MOVING)
	
func switch_state(new_state:State) -> void:
	if state_node!=null:
		state_node.queue_free()
	var state_map:={
		State.MOVING:PlayerStateMoving,
		State.PICKING_UP:PlayerStatePickingUp,
		State.THROWING:PlayerStateThrowing
	}
	state_node=state_map[new_state].new(self)
	state_node.transition_requested.connect(switch_state)
	state_node.name="State:"+State.keys()[new_state]
	state=new_state
	add_child(state_node)
	
# 每个渲染帧执行一次 不会出现丢帧的问题
func _process(_delta: float) -> void:
	input_dir=Input.get_vector("strafe_left","strafe_right","backward","forward")
	
# 移动和碰撞检测必须要在物理帧中进行
# 固定频率运动 与渲染帧无关 所以可能出现跳帧的问题
func _physics_process(delta: float) -> void:
	check_jump_input()
	process_gravity()
	move_and_slide()
	check_for_pickable_item()
	
func process_movement(delta:float) -> void:
	var input_3d_space:=Vector3(input_dir.x,0,-input_dir.y)#角色面朝-z
	var target_speed:=run_speed if Input.is_action_pressed("run") else walk_speed
	var desired_velocity:=transform.basis*input_3d_space*target_speed
	if input_3d_space==Vector3.ZERO:
		velocity.x=move_toward(velocity.x,0,acceleration*delta)
		velocity.z=move_toward(velocity.z,0,acceleration*delta)
	else:
		velocity.x=move_toward(velocity.x,desired_velocity.x,acceleration*delta)
		velocity.z=move_toward(velocity.z,desired_velocity.z,acceleration*delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouse_sensitivity) # PI 3.14 => 180 degrees
		camera.rotate_x(-event.relative.y*mouse_sensitivity)
		camera.rotation.x=clampf(camera.rotation.x,MAX_ANGLE_LOOK_DOWN,MAX_ANGLE_LOOK_UP)
		
func check_jump_input() -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y=jump_force
	
func process_gravity() -> void:
	if !is_on_floor():
		velocity.y-=gravity

func check_for_pickable_item() -> void:
	var target_node:Node=null
	if select_ray_cast.is_colliding():
		var collider:=select_ray_cast.get_collider()
		if collider is PickableItem:
			target_node=collider
	
	if target_node!=current_focused_item:
		if current_focused_item:
			current_focused_item.unhightlight()
		current_focused_item=target_node
		if current_focused_item is PickableItem:
			current_focused_item.hightlight()

func can_pickup_object() -> bool:
	return current_focused_item!=null
