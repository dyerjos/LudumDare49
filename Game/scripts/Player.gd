extends KinematicBody2D

export(int, 1, 4) var player_id = 1
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 100
export (float) var FRICTION = 0.25
export (bool) var HAS_GOLD = false
export (bool) var IS_BOT = null

#const ice = preload('res://MusicAndSound/IntenseMusic.tscn')

var velocity = Vector2.ZERO
var prev_map_position = null
var target = null

onready var PlayerSprite = get_node("Sprite" + str(player_id))
onready var MainTileMap = get_node("../../Navigation2D/MainTileMap")	

func _physics_process(delta):
	process_tile()
	
func _process(delta: float) -> void:
	if IS_BOT == null:
		match player_id:
			1:
				IS_BOT = false
			2:
				if GameManager.NUMBER_OF_BOTS > 0:
					IS_BOT = true
			3:
				if GameManager.NUMBER_OF_BOTS > 1:
					IS_BOT = true
			4:
				if GameManager.NUMBER_OF_BOTS > 2:
					IS_BOT = true
				
	if not IS_BOT:
		move(delta)
	else:
		seek()
		move(delta)

func seek():
	if not HAS_GOLD:
		var tile_id_of_gold_1_spot = MainTileMap.get_cellv(Vector2(32,32))
		var tile_id_of_gold_2_spot = MainTileMap.get_cellv(Vector2(31,31))
		var tile_id_of_gold_3_spot = MainTileMap.get_cellv(Vector2(31,32))
		var tile_id_of_gold_4_spot = MainTileMap.get_cellv(Vector2(32,31))
		if tile_id_of_gold_1_spot != 22:
	#		target = Vector2(32,32)
			target = get_node("../../Position2D").position
		elif tile_id_of_gold_2_spot != 22:
	#		target = Vector2(31,31)
			target = get_node("../../Position2D2").position
		elif tile_id_of_gold_3_spot != 22:
	#		target = Vector2(31,32)
			target = get_node("../../Position2D3").position
		elif tile_id_of_gold_4_spot != 22:
	#		target = Vector2(32,31)
			target = get_node("../../Position2D4").position
		else: 
			return
	else:
		target = get_node("../../StartingPositions/Player_start" + str(player_id)).position

func move(delta):
	var input_vector = Vector2.ZERO
	if not IS_BOT:
		input_vector.y = -Input.get_action_strength("move_up_player" + str(player_id))
		input_vector.y += Input.get_action_strength("move_down_player" + str(player_id))
		input_vector.x = -Input.get_action_strength("move_left_player" + str(player_id))
		input_vector.x += Input.get_action_strength("move_right_player" + str(player_id))
	else:
		input_vector = target - self.position
#		print(input_vector)
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
#	print(global_position)
	var _local_position = MainTileMap.to_local(global_position)
	var _map_position = MainTileMap.world_to_map(_local_position) # tile coordinate!
#		print(_map_position)
	if _map_position == prev_map_position:
		return
	else:
#			print("new tile")
		print("map pos: %s" % _map_position)
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
				if GameManager.PERMA_DEATH == true:
					GameManager.CURRENT_PLAYER_COUNT -= 1
					if HAS_GOLD == true:
						HAS_GOLD = false
						$Gold.visible = false
						GameManager.LOST_GOLD += 1
					queue_free()
				else:
					if HAS_GOLD == true:
						HAS_GOLD = false
						$Gold.visible = false
						GameManager.LOST_GOLD += 1
					self.position = get_node("../../StartingPositions/Player_start" + str(player_id)).position
#				22:
#					print("grey floor")
#					# no more gold can be removed
			29:
#					print("grey floor level 1 gold")
				if not HAS_GOLD:
					take_gold_from_center()
					MainTileMap.set_cellv(_map_position, 22)
			31:
#					print("grey floor level 2 gold")
				if not HAS_GOLD:
					take_gold_from_center()
					MainTileMap.set_cellv(_map_position, 29)
			21:
#					print("grey floor level 3 gold")
				if not HAS_GOLD:
					take_gold_from_center()
					MainTileMap.set_cellv(_map_position, 31)
			13:
#					print("wood floor")
				if HAS_GOLD:
#					print(player_id)
					match player_id:
						1:
							if _map_position == Vector2(1,1) or _map_position ==  Vector2(1,2) or _map_position == Vector2(2,1) or _map_position == Vector2(2,2):
								print(_map_position)
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 35)
						2:
							if _map_position == Vector2(61,1) or _map_position == Vector2(61,2) or _map_position == Vector2(62,1) or _map_position == Vector2(62,2):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 35)
						3:
							if _map_position == Vector2(1, 61) or _map_position == Vector2(1,62) or _map_position == Vector2(2,61) or _map_position == Vector2(2,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 35)
						4:
							if _map_position == Vector2(61, 61) or _map_position == Vector2(61,62) or _map_position == Vector2(62,61) or _map_position == Vector2(62,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 35)
			35:
#					print("wood floor level 1 gold")
				if HAS_GOLD:
					match player_id:
						1:
							if _map_position == Vector2(1,1) or _map_position == Vector2(1,2) or _map_position == Vector2(2,1) or _map_position == Vector2(2,2):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 15)
						2:
							if _map_position == Vector2(61,1) or _map_position == Vector2(61,2) or _map_position == Vector2(62,1) or _map_position == Vector2(62,2):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 15)
						3:
							if _map_position == Vector2(1, 61) or _map_position == Vector2(1,62) or _map_position == Vector2(2,61) or _map_position == Vector2(2,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 15)
						4:
							if _map_position == Vector2(61, 61) or _map_position == Vector2(61,62) or _map_position == Vector2(62,61) or _map_position == Vector2(62,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 15)
			15:
#					print("wood floor level 2 gold")
				if HAS_GOLD:
					match player_id:
						1:
							if _map_position == Vector2(1,1) or _map_position == Vector2(1,2) or _map_position == Vector2(2,1) or _map_position == Vector2(2,2):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 14)
						2:
							if _map_position == Vector2(61,1) or _map_position == Vector2(61,2) or _map_position == Vector2(62,1) or _map_position == Vector2(62,2):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 14)
						3:
							if _map_position == Vector2(1, 61) or _map_position == Vector2(1,62) or _map_position == Vector2(2,61) or _map_position == Vector2(2,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 14)
						4:
							if _map_position == Vector2(61, 61) or _map_position == Vector2(61,62) or _map_position == Vector2(62,61) or _map_position == Vector2(62,62):
								add_gold_to_player()
								MainTileMap.set_cellv(_map_position, 14)
#				14:
#					print("wood floor level 3 gold")
#					# no more gold can be added
#				11:
#					print("warning tile")
#				4:
#					print("speckled snow")
	
		prev_map_position = _map_position
			
func add_gold_to_player():
	HAS_GOLD = false
	$Gold.visible = false
	match player_id:
		1:
			GameManager.PLAYER_GOLD_1 += 1
		2:
			GameManager.PLAYER_GOLD_2 += 1
		3:
			GameManager.PLAYER_GOLD_3 += 1
		4:
			GameManager.PLAYER_GOLD_4 += 1
		
func take_gold_from_center():
	HAS_GOLD = true
	$Gold.visible = true
	GameManager.GOLD_IN_CENTER -= 1

