extends Panel

onready var score_value = $CenterContainer/VBoxContainer/HBoxContainer2/ScoreValue

func _ready():
	score_value.text = str(round(GameManager.time)) + ' seconds'

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayAgainButton_pressed():
	GameManager.time = 0
	get_tree().reload_current_scene()
