class_name PlayerStateFall extends PlayerState

@onready var idle: PlayerStateIdle = %Idle
@onready var jump: PlayerStateJump = %Jump
@onready var wall_slide: PlayerStateWallSlide = %WallSlide

var coyote_timer: float
var jump_buffer_timer: float

func enter() -> void:
	if player.previous_state != jump:
		player.jump_count += 1
	player.animation_player.play("fall")
	coyote_timer = player.coyote_time

func exit() -> void:
	coyote_timer = 0.0


func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		if coyote_timer > 0 and player.previous_state != jump:
			# Refund a jump since the player jump within the coyote frames
			# without going lower than zero
			player.jump_count -= 1
			player.jump_count = max(player.jump_count, 0)
			return jump
		if player.jump_count < player.allowed_jumps:
			return jump
		jump_buffer_timer = player.jump_buffer_time
	return self


func process(delta: float) -> PlayerState:
	player.update_direction()
	player.flip_sprite()
	coyote_timer -= delta
	jump_buffer_timer -= delta
	return self


func physics_process(delta: float) -> PlayerState:
	if player.is_on_floor():
		if jump_buffer_timer > 0:
			return jump
		return idle
	
	if player.is_on_wall():
		return wall_slide
	
	
	
	player.velocity.x = player.direction * player.speed
	player.velocity.y += player.fall_gravity * delta
	player.velocity.y = min(player.velocity.y, player.max_fall_gravity)
	return self
