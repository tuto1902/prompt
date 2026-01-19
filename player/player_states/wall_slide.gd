class_name PlayerStateWallSlide extends PlayerState

@onready var idle: PlayerStateIdle = %Idle
@onready var fall: PlayerStateFall = %Fall
@onready var wall_jump: PlayerStateWallJump = %WallJump

var max_wall_slide_velocity_multiplier: float
var wall_release_timer: float
var wall_release_speed: float

func enter() -> void:
	player.jump_count = 0
	wall_release_speed = player.speed * player.wall_release_speed_multiplier
	player.animation_player.play("wall_slide")
	player.sprite.offset.x = -4
	if player.shape_cast_wall_right.is_colliding():
		player.sprite.scale.x = -1
		player.direction = -1
	elif player.shape_cast_wall_left.is_colliding():
		player.sprite.scale.x = 1
		player.direction = 1


func exit() -> void:
	player.sprite.offset.x = 0

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		return wall_jump
	return self


func process(delta: float) -> PlayerState:
	if Input.is_action_pressed("left") and player.shape_cast_wall_right.is_colliding():
		wall_release_timer += delta
	elif Input.is_action_pressed("right") and player.shape_cast_wall_left.is_colliding():
		wall_release_timer += delta
	else:
		wall_release_timer = 0
	
	if wall_release_timer >= player.wall_release_time:
		player.velocity.x = player.direction * wall_release_speed
		return fall
	
	return self


func physics_process(_delta: float) -> PlayerState:
	if not player.is_on_wall():
		if player.is_on_floor():
			return idle
		return fall
	
	player.velocity.y = player.max_wall_slide_gravity
	return self
