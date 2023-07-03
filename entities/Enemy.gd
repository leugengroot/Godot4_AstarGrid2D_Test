extends CharacterBody2D

var path: Array;
@onready var astar_grid: AStarGrid2D = AStarGrid2D.new();
var game_map: TileMap


func _ready() -> void:
	game_map = get_parent().get_node("TileMap");
	var used_cells = game_map.get_used_cells(1);
	astar_grid.set_default_compute_heuristic(AStarGrid2D.HEURISTIC_MANHATTAN);
	astar_grid.set_default_estimate_heuristic(AStarGrid2D.HEURISTIC_MANHATTAN);
	astar_grid.size = game_map.get_used_rect().size;
	astar_grid.cell_size = game_map.tile_set.tile_size;
	astar_grid.update();
	for cell in used_cells:
		astar_grid.set_point_solid(cell, true) 
	print("SOLID CELLS");
	for cell in used_cells:
		print(str(cell) + " " + str(astar_grid.is_point_solid(cell)))
	print("a* setup complete");
	_on_player_moved();


func _on_player_moved():
	var player_pos = get_parent().get_node("Player").position;
	astar_grid.update();
	var from_point = Vector2(position.x / 32, position.y / 32);
	var to_point = Vector2(player_pos.x / 32, player_pos.y / 32);
	path.clear();
	path = astar_grid.get_point_path(from_point, to_point);
	print_path(path);
	if path.size() > 1:
		position = path[1];

func print_path(path):
	var temp = "enemy_path=";
	for cell in path:
		temp += "[" + str(cell[0]/32) + "/" + str(cell[1]/32) + "], ";
	print(temp);
