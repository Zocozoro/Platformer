extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var DOUBLE_JUMPED = true
var DOUBLE_JUMP_READY = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")


#func _ready():
	#anim.play("Idle")

func _physics_process(delta):
	if is_on_floor() and DOUBLE_JUMPED:
		DOUBLE_JUMPED = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or (DOUBLE_JUMP_READY and not DOUBLE_JUMPED)):
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		if DOUBLE_JUMP_READY:
			DOUBLE_JUMPED = true
			DOUBLE_JUMP_READY = false
		if not DOUBLE_JUMP_READY and not DOUBLE_JUMPED:
			DOUBLE_JUMP_READY = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	#print(direction)
	if direction == -1:
		animSprite.flip_h = true
	elif direction == 1:
		animSprite.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")

	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
