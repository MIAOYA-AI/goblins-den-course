extends CharacterBody3D
class_name Enemy

@onready var physical_bone_torso: PhysicalBone3D = %"Physical Bone Torso"
@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var skeleton_simulator: PhysicalBoneSimulator3D = %PhysicalBoneSimulator3D

const EQUIPED_ITEM_PREFAB:=preload("res://scenes/equipment/equiped_item.tscn")
const IMPALE_INTENSITY:=100.0
const SIMULATION_TIME:=3.0

enum State {MOVING,IMPALE,DEATH}
var state:State
var state_node:EnemyState
var impaled_item_weapon_data:WeaponData
var thrown_item_basis:Basis
var death_impulse:Vector3=Vector3.ZERO

func _ready() -> void:
	switch_state(State.MOVING)

func switch_state(new_state:State) -> void:
	if state_node!=null:
		state_node.queue_free()
	var state_map:={
		State.MOVING:EnemyStateMoving,
		State.IMPALE:EnemyStateImpaled,
		State.DEATH:EnemyStateDeath
	}
	state_node=state_map[new_state].new(self)
	state_node.transition_requested.connect(switch_state)
	state_node.name="State:"+State.keys()[new_state]
	state=new_state
	add_child(state_node)

func impale(thrown_item:ThrownItem,item_basis:Basis) -> void:
	impaled_item_weapon_data=thrown_item.weapon_data
	thrown_item_basis=item_basis
	switch_state(State.IMPALE)
	thrown_item.queue_free()
