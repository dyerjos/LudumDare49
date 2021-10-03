extends Panel

onready var time = $CenterContainer/VBoxContainer/HBoxContainer6/ScoreValue
onready var P1_Score = $CenterContainer/VBoxContainer/HBoxContainer2/ScoreValue
onready var P2_Score = $CenterContainer/VBoxContainer/HBoxContainer3/ScoreValue
onready var P3_Score = $CenterContainer/VBoxContainer/HBoxContainer4/ScoreValue
onready var P4_Score = $CenterContainer/VBoxContainer/HBoxContainer5/ScoreValue

func _ready():
	time.text = str(round(GameManager.ELAPSED_SECONDS)) + ' seconds'
	P1_Score.text = str(GameManager.PLAYER_GOLD_1)
	P2_Score.text = str(GameManager.PLAYER_GOLD_2)
	P3_Score.text = str(GameManager.PLAYER_GOLD_3)
	P4_Score.text = str(GameManager.PLAYER_GOLD_4)

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_PlayAgainButton_pressed():
	GameManager.ELAPSED_SECONDS = 0
	GameManager.CURRENT_PLAYER_COUNT = 4
	GameManager.TOTAL_HUMAN_PLAYERS = 4
	GameManager.GOLD_IN_CENTER = 12
	GameManager.PLAYER_GOLD_1 = 0
	GameManager.PLAYER_GOLD_2 = 0
	GameManager.PLAYER_GOLD_3 = 0
	GameManager.PLAYER_GOLD_4 = 0
	GameManager.NUMBER_OF_BOTS = 0
	GameManager.GOLD_IN_HOUSES = 0
	GameManager.LOST_GOLD = 0
	GameManager.TOTAL_HUMAN_PLAYERS = 0
	GameManager.PERMA_DEATH = false
	GameManager.FRIENDLY_FIRE = false
	GameManager.CAN_STEAL = false
	get_tree().reload_current_scene()
	queue_free()
