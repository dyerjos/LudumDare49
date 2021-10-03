extends Node2D

export (int) var TOTAL_HUMAN_PLAYERS = 4
export (int) var CURRENT_PLAYER_COUNT = 4
export (int) var ELAPSED_SECONDS = 0
export (int) var GOLD_IN_CENTER = 8
export (int) var PLAYER_GOLD_1 = 0
export (int) var PLAYER_GOLD_2 = 0
export (int) var PLAYER_GOLD_3 = 0
export (int) var PLAYER_GOLD_4 = 0
export (int) var NUMBER_OF_BOTS = 0

#var EndGame = load('res://Levels/EndGame.tscn')

#func _ready() -> void:
#	get_tree().paused = true

func _process(delta: float):
	ELAPSED_SECONDS += delta
#	if CURRENT_PLAYER_COUNT <= 0:
#		get_tree().paused = true
#		var end_game = EndGame.instance()
#		get_tree().get_root().add_child(end_game)

