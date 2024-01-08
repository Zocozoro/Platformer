extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var DOUBLE_JUMPED = true
var DOUBLE_JUMP_READY = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_on_floor() and DOUBLE_JUMPED:
		DOUBLE_JUMPED = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or (DOUBLE_JUMP_READY and not DOUBLE_JUMPED)):
		velocity.y = JUMP_VELOCITY
		if DOUBLE_JUMP_READY:
			DOUBLE_JUMPED = true
			DOUBLE_JUMP_READY = false
		if not DOUBLE_JUMP_READY and not DOUBLE_JUMPED:
			DOUBLE_JUMP_READY = true
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
