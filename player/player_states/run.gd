class_name PlayerStateRun extends PlayerState

@onready var idle: PlayerStateIdle = %Idle
@onready var fall: PlayerStateFall = %Fall
@onready var jump: PlayerStateJump = %Jump


func enter() -> void:
	player.animation_player.play("run")


func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	return self

func process(_delta: float) -> PlayerState:
	player.update_direction()
	player.flip_sprite()
	if player.direction == 0:
		return idle
	return self


func physics_process(_delta: float) -> PlayerState:
	if not player.is_on_floor():
		return fall
	player.velocity.x = player.direction * player.speed
	return self
