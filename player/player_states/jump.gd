class_name PlayerStateJump extends PlayerState

@onready var fall: PlayerStateFall = %Fall


func enter() -> void:
	player.velocity.y = player.jump_velocity
	player.animation_player.play("jump")


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
