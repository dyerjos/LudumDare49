extends KinematicBody2D

export(int, 1, 4) var player_id = 1
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 100
export (float) var FRICTION = 0.25

#const ice = preload('res://MusicAndSound/IntenseMusic.tscn')

var velocity = Vector2.ZERO
var prev_map_position = null

onready var PlayerSprite = get_node("Sprite" + str(player_id))
onready var MainTileMap = get_node("../MainTileMap")

func _physics_process(delta):
	move(delta)
	process_tile()

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.y = -Input.get_action_strength("move_up_player" + str(player_id))
	input_vector.y += Input.get_action_strength("move_down_player" + str(player_id))
	input_vector.x = -Input.get_action_strength("move_left_player" + str(player_id))
	input_vector.x +=  Input.get_action_strength("move_right_player" + str(player_id))
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		if input_vector.y >= 0.707:
			PlayerSprite.play("Down")
		elif input_vector.y <= -0.707:
			PlayerSprite.play("Up")
		elif input_vector.x <= -0.707:
			PlayerSprite.play("Right")
			PlayerSprite.flip_h = true
		elif input_vector.x >= 0.707:
			PlayerSprite.play("Right")
			PlayerSprite.flip_h = false
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:\
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
func process_tile():
	if(player_id == 1):
		var _local_position = MainTileMap.to_local(global_position)
		var _map_position = MainTileMap.world_to_map(_local_position) # tile coordinate!
		if _map_position == prev_map_position:
			return
		else:
			print("new tile")
			print("map pos: %s" % _map_position)
			var tile_id = MainTileMap.get_cellv(_map_position)
			print("tile_id: %s" % tile_id)
			var name = MainTileMap.tile_set.tile_get_name(tile_id)
			print("tile name: %s" % name)
			match tile_id:
				0:
					print("Trigger Event A")
				1:
					print("Trigger Event B")
		
			prev_map_position = _map_position


