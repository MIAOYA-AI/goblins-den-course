extends CharacterBody3D
class_name Enemy

@onready var physical_bone_torso: PhysicalBone3D = %"Physical Bone Torso"
@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var skeleton_simulator: PhysicalBoneSimulator3D = %PhysicalBoneSimulator3D
@onready var animation_player: AnimationPlayer = $character/AnimationPlayer
@onready var equipment_component: EquipmentComponent = %EquipmentComponent

enum State {MOVING,IMPALE,DEATH}
var state:State
var state_node:EnemyState

func _ready() -> void:
	switch_state(State.MOVING)

func switch_state(new_state:State,data:EnemyStateData=EnemyStateData.new()) -> void:
	if state_node!=null:
		state_node.queue_free()
	var state_map:={
		State.MOVING:EnemyStateMoving,
		State.IMPALE:EnemyStateImpaled,
		State.DEATH:EnemyStateDeath
	}
	state_node=state_map[new_state].new(self,data)
	state_node.transition_requested.connect(switch_state)
	state_node.name="State:"+State.keys()[new_state]
	state=new_state
	add_child(state_node)

func impale(thrown_item:ThrownItem,item_basis:Basis) -> void:
	var impale_data:EnemyStateData=EnemyStateData.new()
	impale_data.impaled_item_weapon_data=thrown_item.weapon_data
	impale_data.thrown_item_basis=item_basis
	switch_state(State.IMPALE,impale_data)
	thrown_item.queue_free()
