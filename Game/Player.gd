extends KinematicBody2D

export(int, 1, 4) var player_id = 1
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 100
export (float) var FRICTION = 0.25

func _ready() -> void:

func _physics_process(delta):
	var input_vector = get_input_vector()
	move()

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right_player" + str(player_id)) - Input.get_action_strength("move_left_player" + str(player_id))
	direction = input_vector.x
	return input_vector

func move():
