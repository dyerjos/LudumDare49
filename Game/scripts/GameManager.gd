extends Node2D

export (int) var TOTAL_HUMAN_PLAYERS = 4
export (int) var CURRENT_PLAYER_COUNT = 4
export (int) var ELAPSED_SECONDS = 0
export (int) var GOLD_IN_CENTER = 12
export (int) var PLAYER_GOLD_1 = 0
export (int) var PLAYER_GOLD_2 = 0
export (int) var PLAYER_GOLD_3 = 0
export (int) var PLAYER_GOLD_4 = 0
export (int) var NUMBER_OF_BOTS = 0
export (int) var GOLD_IN_HOUSES = 0
export (int) var LOST_GOLD = 0
export (bool) var PERMA_DEATH = false
export (bool) var FRIENDLY_FIRE = false
export (bool) var CAN_STEAL = false

var EndGame = load('res://EndGame.tscn')

func _ready() -> void:
	get_tree().paused = true

func _process(delta: float):
	ELAPSED_SECONDS += delta
	GOLD_IN_HOUSES = PLAYER_GOLD_1 + PLAYER_GOLD_2 + PLAYER_GOLD_3 + PLAYER_GOLD_4
	game_over_check()

func game_over_check():
	if 12 - GOLD_IN_HOUSES - LOST_GOLD == 0:
		get_tree().paused = true
		var end_game = EndGame.instance()
		get_tree().get_root().add_child(end_game)
	if PERMA_DEATH == true and CURRENT_PLAYER_COUNT == 0:
		get_tree().paused = true
		var end_game = EndGame.instance()
		get_tree().get_root().add_child(end_game)
