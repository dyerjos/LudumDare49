extends KinematicBody2D

export(int, 1, 4) var player_id = 1
export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 100
export (float) var FRICTION = 0.25

var velocity = Vector2.ZERO

func _physics_process(delta):
	move(delta)

func move(delta):
	var input_vector = Vector2.ZERO
	input_vector.y = -Input.get_action_strength("move_up_player" + str(player_id))
	input_vector.y += Input.get_action_strength("move_down_player" + str(player_id))
	input_vector.x = -Input.get_action_strength("move_left_player" + str(player_id))
	input_vector.x +=  Input.get_action_strength("move_right_player" + str(player_id))
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.y >= 0.707:
			get_node("Sprite" + str(player_id)).play("Down")
		elif input_vector.y <= -0.707:
			get_node("Sprite" + str(player_id)).play("Up")
		elif input_vector.x <= -0.707:
			get_node("Sprite" + str(player_id)).play("Right")
			get_node("Sprite" + str(player_id)).flip_h = true
		elif input_vector.x >= 0.707:
			get_node("Sprite" + str(player_id)).play("Right")
			get_node("Sprite" + str(player_id)).flip_h = false
#		return "down"
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/Run/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)
#		animationTree.set("parameters/Roll/blend_position", input_vector)
#		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
