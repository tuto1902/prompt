class_name PlayerStateJump extends PlayerState

@onready var fall: PlayerStateFall = %Fall

@export var jump_sound: AudioStream


func enter() -> void:
	player.player_just_jumped = false
	player.sfx_player.stream = jump_sound
	player.sfx_player.pitch_scale = 1.0
	if player.jump_count >= player.allowed_jumps:
		player.transition_to_state(player.previous_state)
		return
	player.jump_count += 1
	player.velocity.y = player.jump_velocity
	player.animation_player.play("jump")
	player.sfx_player.play()


func process(_delta: float) -> PlayerState:
	player.update_direction()
	player.flip_sprite()
	return self


func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_multiplier 
	return self


func physics_process(delta: float) -> PlayerState:
	if player.velocity.y > 0:
		return fall
	
	player.velocity.x = player.direction * player.speed
	player.velocity.y += player.jump_gravity * delta
	return self
