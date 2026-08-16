extends Node3D
class_name BaseRoom

@onready var floors: GridMap = %Floors
@onready var ceilings: GridMap = %Ceilings
@onready var enemies: Node3D = %Enemies

var cell_ids_with_no_ceiling:=[]

func _ready() -> void:
	fill_ceilings()
	prep_enemies()
	
func fill_ceilings() -> void:
	for cell_name:String in ["Ground","Hole-Corner","Hole-Side","Hole-UTurn"]:
		cell_ids_with_no_ceiling.push_back((floors.mesh_library.find_item_by_name(cell_name)))
	var used_cells:Array[Vector3i]=floors.get_used_cells()
	for cell_coords in used_cells:
		var tile_id:int=floors.get_cell_item(cell_coords)
		if cell_ids_with_no_ceiling.has(tile_id):
			ceilings.set_cell_item(cell_coords,0)

func prep_enemies() -> void:
	for enemy:Enemy in enemies.get_children():
		enemy.screamed.connect(call_all_enemy)
		
func call_all_enemy() -> void:
	for enemy:Enemy in enemies.get_children():
		enemy.player=GameState.current_player
