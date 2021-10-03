extends Control

func _process(_delta: float):
	self.text = "Time " + str(round(GameManager.ELAPSED_SECONDS))
