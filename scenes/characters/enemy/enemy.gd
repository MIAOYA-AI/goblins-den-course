extends CharacterBody3D
class_name Enemy

signal screamed

const GRAVITY:=20

@onready var physical_bone_torso: PhysicalBone3D = %"Physical Bone Torso"
@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var skeleton_simulator: PhysicalBoneSimulator3D = %PhysicalBoneSimulator3D
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var equipment_component: EquipmentComponent = %EquipmentComponent
@onready var player_detection_area: Area3D = %PlayerDetectionArea
@onready var weapon_reach_raycast: RayCast3D = %WeaponReachRaycast
@onready var health_component: HealthComponent = %HealthComponent
@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D

@export var player:Player
@export var duration_between_attacks:int
@export var run_speed:float

enum State {MOVING,IMPALE,DEATH,SLASHING,HURT,BLOCK,STUUNED}
var state:State
var state_node:EnemyState
var time_since_last_attack:int
var pushback_force:=Vector3.ZERO

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_detected)
	switch_state(State.MOVING)
	
func _physics_process(delta: float) -> void:
	#死亡后由布娃娃物理接管，清空残余速度并停止角色本体移动
	if state == State.DEATH:
		velocity = Vector3.ZERO
		set_physics_process(false)
		return
	process_movement(delta)

func switch_state(new_state:State,data:EnemyStateData=EnemyStateData.new()) -> void:
	if state_node!=null:
		state_node.queue_free()
	var state_map:={
		State.MOVING:EnemyStateMoving,
		State.IMPALE:EnemyStateImpaled,
		State.DEATH:EnemyStateDeath,
		State.SLASHING:EnemyStateSlashing,
		State.HURT:EnemyStateHurt,
		State.BLOCK:EnemyStateBlock,
		State.STUUNED:EnemyStateStunned
	}
	state_node=state_map[new_state].new(self,data)
	state_node.transition_requested.connect(switch_state)
	state_node.name="State:"+State.keys()[new_state]
	state=new_state
	add_child(state_node)
	
func process_movement(delta:float) -> void:
	process_gravity(delta)
	process_pushback(delta)
	move_and_slide()
	
func process_gravity(delta:float) -> void:
	if not is_on_floor():
		velocity.y-=GRAVITY*delta
		
func process_pushback(delta:float) -> void:
	if pushback_force!=Vector3.ZERO:
		pushback_force=pushback_force.move_toward(Vector3.ZERO,delta*40)
		velocity=pushback_force

func impale(thrown_item:ThrownItem,item_basis:Basis) -> void:
	var impale_data:EnemyStateData=EnemyStateData.new()
	if player!=null and equipment_component.has_shield() and !can_be_hurt():
		var hit_dirction:=thrown_item.global_position.direction_to(global_position)
		impale_data.impulse_direction=hit_dirction
		switch_state(State.BLOCK,impale_data)
	else:
		impale_data.impaled_item_weapon_data=thrown_item.weapon_data
		impale_data.thrown_item_basis=item_basis
		switch_state(State.IMPALE,impale_data)
		thrown_item.queue_free()
	screamed.emit()

func on_kicked() -> void:
	screamed.emit()
	var state_data:EnemyStateData=EnemyStateData.new()
	if player!=null:
		var kick_direction:Vector3=(global_position-player.global_position).normalized()
		state_data.impulse_direction=kick_direction
	if can_be_stuuned() or equipment_component.has_shield():
		switch_state(State.STUUNED,state_data)
	else:
		switch_state(State.BLOCK,state_data)
		
func can_be_hurt() -> bool:
	return state==State.STUUNED or state==State.SLASHING
	
func can_be_stuuned() -> bool:
	return state==State.SLASHING
		
func on_player_detected(body:Node3D) -> void:
	player=body

func has_registered_player() -> bool:
	return player!=null and is_instance_valid(player)

func is_player_within_reach() -> bool:
	if has_registered_player() and equipment_component.has_weapon():
		return weapon_reach_raycast.is_colliding()
	else:
		return false
		
func try_recrive_hit(damage:int,source_player:Player) -> void:
	var hit_direction:Vector3=(global_position-source_player.global_position).normalized()
	var damage_data:EnemyStateData=EnemyStateData.new()
	damage_data.impulse_direction=hit_direction
	screamed.emit()
	player=source_player
	if equipment_component.has_shield() and !can_be_hurt():
		switch_state(State.BLOCK,damage_data)
	else:
		damage_data.damage=damage
		switch_state(State.HURT,damage_data)
