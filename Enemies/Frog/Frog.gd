extends CharacterBody2D

# Configuration
var _proximity_to_spawn_range = 50
const SPEED = 100
var bounty = 1

# Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Base logic
var DYING = false
var CHASE = false
var NEAR_SPAWN = true
var CURRENT_STATE = states.Idle

# Possible TODO: Fuse these states with bools above
enum states { Idle, Moving, Dying, Dead }

# References
@onready var player = get_node("../../Player/Player")
@onready var animSprite = get_node("AnimatedSprite2D")
@onready var initial_position = self.get_position()

# Magic String
var mg_anim_jump = "Jump"
var mg_anim_idle = "Idle"
var mg_anim_death = "Death"


func _physics_process(delta):
	process_movement(delta)
	process_animation()
	move_and_slide()
	
func process_movement(delta):
	velocity.y += gravity * delta # Apply gravity
	
	if CHASE:
		move_towards_player()
	elif not NEAR_SPAWN:
		return_to_initial_position()
	else:
		wander_around()
	
	if CURRENT_STATE == states.Dead:
		death() # Feels wrong to be here, but don't have a 'process_state()' method
	if CURRENT_STATE == states.Dying:
		self.velocity.x = 0
	else:
		if self.velocity.x == 0:
			CURRENT_STATE = states.Idle
		else:
			CURRENT_STATE = states.Moving
		
	if not CHASE:
		var distance = initial_position.distance_to(self.position)
		if distance > _proximity_to_spawn_range:
			NEAR_SPAWN = false
			
func process_animation():
	match CURRENT_STATE:
		states.Dying:
			animSprite.play(mg_anim_death)
			await animSprite.animation_finished
			CURRENT_STATE = states.Dead
		states.Moving:
			animSprite.play(mg_anim_jump)
		states.Idle:
			animSprite.play(mg_anim_idle)

func move_towards_player():
	var direction = (player.position - self.position).normalized()
	self.velocity.x = direction.x * SPEED
		
	if direction.x > 0:
		animSprite.flip_h = true
	else:
		animSprite.flip_h = false
		
func return_to_initial_position():		
	var direction = (initial_position - self.position).normalized()
	self.velocity.x = direction.x * SPEED
	
	if direction.x > 0:
		animSprite.flip_h = true
	else:
		animSprite.flip_h = false
		
	var distance = initial_position.distance_to(self.position)
	if distance < _proximity_to_spawn_range:
		NEAR_SPAWN = true
		
func death():
	self.queue_free()
	Game.gold += self.bounty
	Utils.saveGame()
		
func wander_around():
	# Just stop for now
	self.velocity.x = 0

func _on_player_detection_body_entered(body):
	if body.name == Utils.mg_playerName:
		CHASE = true;
		
func _on_player_detection_body_exited(body):
	if body.name == Utils.mg_playerName: 
		CHASE = false;

func _on_player_death_body_entered(body):
	if body.name == Utils.mg_playerName:
		CURRENT_STATE = states.Dying

func _on_player_collision_body_entered(body):
	if body.name == Utils.mg_playerName:
		Game.playerHP -= 1
		CURRENT_STATE = states.Dying
