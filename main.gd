extends Node2D

func _ready() -> void:
	var enemy = $Enemy;
	
	$Player.player_moved.connect(enemy._on_player_moved);
