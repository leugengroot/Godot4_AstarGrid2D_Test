extends CharacterBody2D

signal player_moved

const INPUTS = {
	"RIGHT_ARROW": Vector2.RIGHT, 
	"LEFT_ARROW": Vector2.LEFT, 
	"UP_ARROW": Vector2.UP, 
	"DOWN_ARROW": Vector2.DOWN
	}

@onready var ray_cast = $RayCast2D
	
func _unhandled_key_input(event):	
	handle_movment_keys(event);

func handle_movment_keys(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			if checkForRayCastCollision(dir) == "no_collision":
				move(dir);

func move(dir):
	position += INPUTS[dir] * 32;
	player_moved.emit();
	
func checkForRayCastCollision(dir):
	ray_cast.target_position = INPUTS[dir] * 32;
	ray_cast.force_raycast_update();	
	if ray_cast.is_colliding():
		match ray_cast.get_collider().get("type"):
			"NPC":
				return "ENEMY";
			"ENEMY":
				return "ENEMY"
		if ray_cast.get_collider().get("type") == "NPC":
			return "npc";
		else:
			return ray_cast.get_collider().get_cell_tile_data(0, get_actual_player_position() + INPUTS[dir]).get_custom_data("type");
	else:
		return "no_collision";

func get_actual_player_position():
	return Vector2(position.x / 32, position.y / 32);
