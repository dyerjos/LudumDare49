extends KinematicBody2D

export(int, 1, 4) var player_id = 1
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 100
export (float) var FRICTION = 0.25
export (bool) var HAS_GOLD = false

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
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	
func process_tile():
	if(player_id == 1):
		var _local_position = MainTileMap.to_local(global_position)
		var _map_position = MainTileMap.world_to_map(_local_position) # tile coordinate!
		if _map_position == prev_map_position:
			return
		else:
#			print("new tile")
#			print("map pos: %s" % _map_position)
			var tile_id = MainTileMap.get_cellv(_map_position)
#			print("tile_id: %s" % tile_id)
#			var name = MainTileMap.tile_set.tile_get_name(tile_id) # use tile_id instead for performance
#			print("tile name: %s" % name)
			match tile_id:
				5:
#					print("Ice 1")
					MainTileMap.set_cellv(_map_position, 3)
				3:
#					print("Ice level 2")
					MainTileMap.set_cellv(_map_position, 0)
				0:
#					print("Ice level 3")
					MainTileMap.set_cellv(_map_position, 10)
				10:
#					print("hole in ice!")
					print('you died! go back to home maybe?')
#				22:
#					print("grey floor")
#					# no more gold can be removed
#				29:
#					print("grey floor level 1 gold")
#					# no longer in use
				31:
#					print("grey floor level 2 gold")
					if not HAS_GOLD:
						HAS_GOLD = true
						GameManager.GOLD_IN_CENTER -= 1
						MainTileMap.set_cellv(_map_position, 22)
				21:
#					print("grey floor level 3 gold")
					if not HAS_GOLD:
						HAS_GOLD = true
						GameManager.GOLD_IN_CENTER -= 1
						MainTileMap.set_cellv(_map_position, 31)
				13:
#					print("wood floor")
					if HAS_GOLD:
						HAS_GOLD = false
						add_gold_to_player(player_id)
						MainTileMap.set_cellv(_map_position, 15)
				15:
#					print("wood floor level 2 gold")
					if HAS_GOLD:
						HAS_GOLD = false
						add_gold_to_player(player_id)
						MainTileMap.set_cellv(_map_position, 14)
#				14:
#					print("wood floor level 3 gold")
#					# no more gold can be added
#				11:
#					print("warning tile")
#				4:
#					print("speckled snow")
		
			prev_map_position = _map_position
			
func add_gold_to_player(player_id):
	match player_id:
		1:
			GameManager.PLAYER_GOLD_1 += 1
		2:
			GameManager.PLAYER_GOLD_2 += 1
		3:
			GameManager.PLAYER_GOLD_3 += 1
		4:
			GameManager.PLAYER_GOLD_4 += 1
		


