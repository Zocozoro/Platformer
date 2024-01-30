extends CharacterBody2D

# Godot imports
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Configuration
const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const MAP_BOTTOM = 650 # Shouldn't belong in Player script

# Internal
var DOUBLE_JUMPED = true
var DOUBLE_JUMP_READY = false

# References
@onready var anim = get_node("AnimationPlayer")
@onready var animSprite = get_node("AnimatedSprite2D")

# Magic Strings
var mg_anim_run = "Run"
var mg_anim_jump = "Jump"
var mg_anim_fall = "Fall"
var mg_anim_idle = "Idle"
var mg_anim_death = "Death"

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	process_jump()
	process_animation()
	move_and_slide()
	check_if_dead()

func check_if_dead():
	if Game.playerHP == 0:
		kill_player()
	if global_position.y > MAP_BOTTOM:
		kill_player()
		
func kill_player():
	self.queue_free()
	get_tree().change_scene_to_file("res://world.tscn")

func process_jump():
	# Handle jump.
	if is_on_floor() and DOUBLE_JUMPED:
		DOUBLE_JUMPED = false
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or (DOUBLE_JUMP_READY and not DOUBLE_JUMPED)):
		velocity.y = JUMP_VELOCITY
		anim.play(mg_anim_jump)
		if DOUBLE_JUMP_READY:
			DOUBLE_JUMPED = true
			DOUBLE_JUMP_READY = false
		if not DOUBLE_JUMP_READY and not DOUBLE_JUMPED:
			DOUBLE_JUMP_READY = true

func process_animation():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		animSprite.flip_h = true
	elif direction == 1:
		animSprite.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play(mg_anim_run)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play(mg_anim_idle)

	if velocity.y > 0:
		anim.play(mg_anim_fall)
