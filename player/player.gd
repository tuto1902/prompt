class_name Player extends CharacterBody2D

var abilities: Dictionary = {
	"double jump": true,
	"wall jump": true,
	"dash": true,
	"upward dash": true
}

@export_category('Jump')
## The height in pixels of a fully held jump
@export var jump_height: float = 48
## The time in miliseconds to reach the peak of a fully held jump
@export var jump_time_to_peak: float = 0.3
## The distance in pixels covered in one jump
@export var jump_distance: float = 34
## The amount of extra gravity applied whebn jump button is released early
@export var jump_cut_multiplier: float = 0.5
## Allowed number of jumps before landing
@export var allowed_jumps: float = 2

@export_category('Gravity')
## Amount of extra gravity added to the base fall gravity
@export var fall_gravity_multiplier: float = 1.04
## Maximum amount of extra gravity that can be added to the base fall gravity
@export var max_fall_gravity_multiplier: float = 1.1
## Amount of reduced gravity while sliding on a wall
@export var max_wall_slide_gravity_multiplier: float = 0.050

@export_category('Jump Feel')
## Allowed time in seconds to perform a jump after falling 
@export var coyote_time: float = 0.06
## Allowed time in seconds to perform a jump before landing
@export var jump_buffer_time: float = 0.1

@export_category('Wall Jump')
## Time in seconds before regaining control after a wall jump
@export var wall_jump_time: float = 0.15
## Time it takes in seconds to release the wall slide
@export var wall_release_time: float = 0.3
## Reduced amount of horizontal speed applied after releaseing a wall slide
## Required to move the player slightly away from the wall and avoid
## triggering the wall slide again 
@export var wall_release_speed_multiplier: float = 0.5

@export_category('Dash')
## Speed added to the base player speed while dashing
@export var dash_speed_multiplier: float = 2.6
## Time of the dash in seconds
@export var dash_time: float = 0.3
## Time of the upward dash in seconds
@export var up_dash_time: float = 0.4
## Dash trail spawn interval
@export var dash_visual_spawn_time: float = 0.01
## Dash cooldown time in miliseconds
@export var dash_cooldown_time: float = 0.3

@onready var player_states: Node = %PlayerStates
@onready var sprite: Sprite2D = $Sprite2D
@onready var qbit: Sprite2D = $Qbit
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_wall_right: ShapeCast2D = %ShapeCastWallRight
@onready var shape_cast_wall_left: ShapeCast2D = %ShapeCastWallLeft
@onready var shape_cast_one_way_platform: ShapeCast2D = %ShapeCastOneWayPlatform
@onready var dash_cooldown: Timer = %DashCooldown

@onready var jump: PlayerStateJump = %Jump
@onready var dash: PlayerStateDash = %Dash
@onready var pickup_anchor: Marker2D = %PickupAnchor
@onready var eye_line: Marker2D = $Sprite2D/EyeLine


var states: Array[PlayerState]
var current_state: PlayerState:
	get:
		return states.front()
var previous_state: PlayerState:
	get:
		return states[1]

var speed: float
var direction: float
var facing_direction: float: 
	get:
		return sprite.scale.x
var is_looking_down: bool
var jump_velocity: float
var jump_gravity: float
var jump_count: float
var fall_gravity: float
var max_fall_gravity: float
var max_wall_slide_gravity: float


func _ready() -> void:
	speed = jump_distance / jump_time_to_peak
	jump_velocity = -(2.0 * jump_height) / jump_time_to_peak
	jump_gravity = (2.0 * jump_height) / pow(jump_time_to_peak, 2)
	jump_count = 0
	fall_gravity = jump_gravity * fall_gravity_multiplier
	max_fall_gravity = jump_gravity * max_fall_gravity_multiplier
	max_wall_slide_gravity = jump_gravity * max_wall_slide_gravity_multiplier
	MessageBus.player_ability_unlocked.connect(_on_ability_unlocked)
	MessageBus.player_ability_locked.connect(_on_ability_locked)
	initialize_states()


func _on_ability_unlocked(ability: String) -> void:
	if abilities.has(ability):
		abilities[ability] = true
	if ability == "double jump":
		allowed_jumps = 2


func _on_ability_locked(ability: String) -> void:
	if abilities.has(ability):
		abilities[ability] = false
	if ability == "double jump":
		allowed_jumps = 1


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		MessageBus.player_interacted.emit(self)
		get_viewport().set_input_as_handled()
	
	transition_to_state(current_state.handle_input(event))
	if event is InputEventKey:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and dash_cooldown.time_left == 0:
		if abilities["dash"]:
			if not is_on_wall_only():
			# Optional: only dash while on the floor
			# if is_on_floor():
				transition_to_state(dash)


func _process(delta: float) -> void:
	transition_to_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	transition_to_state(current_state.physics_process(delta))
	move_and_slide()


func update_direction() -> void:
	direction = Input.get_axis("left", "right")
	is_looking_down = true if Input.get_axis("up", "down") > 0 else false


func flip_sprite() -> void:
	if direction > 0:
		sprite.scale.x = 1.0
		qbit.scale.x = 1.0
	elif direction < 0:
		sprite.scale.x = -1.0
		qbit.scale.x = -1.0


func initialize_states() -> void:
	for state in player_states.get_children():
		if state is PlayerState:
			state.player = self
			state.init()
			states.append(state)
	
	current_state.enter()


func transition_to_state(new_state: PlayerState) -> void:
	if new_state == null:
		return
	
	if new_state == current_state:
		return
	
	current_state.exit()
	states.push_front(new_state)
	current_state.enter()
	
	states.resize(3)
	
