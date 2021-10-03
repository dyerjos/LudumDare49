extends Node2D

#const DRUM_SOUND = preload('res://MusicAndSound/DrumSound.tscn')
#const INTENSE_MUSIC = preload('res://MusicAndSound/IntenseMusic.tscn')

func _ready():
	get_tree().paused = true
	visible = true # incase I hide for testing

func _on_SinglePlayer_pressed():
	GameManager.TOTAL_HUMAN_PLAYERS = 1
	GameManager.NUMBER_OF_BOTS = 3
	get_tree().paused = false
	play_music()
	queue_free()


func _on_TwoPlayer_pressed():
	GameManager.TOTAL_HUMAN_PLAYERS = 2
	GameManager.NUMBER_OF_BOTS = 2
	play_music()
	get_tree().paused = false
	queue_free()


func _on_ThreePlayer_pressed() -> void:
	GameManager.TOTAL_HUMAN_PLAYERS = 3
	GameManager.NUMBER_OF_BOTS = 1
	play_music()
	get_tree().paused = false
	queue_free()


func _on_FourPlayer_pressed() -> void:
	GameManager.TOTAL_HUMAN_PLAYERS = 4
	GameManager.NUMBER_OF_BOTS = 0
	play_music()
	get_tree().paused = false
	queue_free()
	
func play_music():
	print("I should be playing music now in Start Screen")
#	var intense_music = INTENSE_MUSIC.instance()
#	get_parent().add_child(intense_music)
