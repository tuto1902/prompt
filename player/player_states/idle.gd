class_name PlayerStateIdle extends PlayerState

@onready var run: PlayerStateRun = %Run
@onready var fall: PlayerStateFall = %Fall
@onready var jump: PlayerStateJump = %Jump


func enter() -> void:
	player.animation_player.play("idle")

func exit() -> void:
	pass


func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump") and player.is_on_floor():
		player.shape_cast_one_way_platform.force_shapecast_update()
		if player.is_looking_down and player.shape_cast_one_way_platform.is_colliding():
			player.position.y += 2
			return self
		return jump
	return self


func process(_delta: float) -> PlayerState:
	player.update_direction()
	if player.direction != 0:
		return run
	return self


func physics_process(_delta: float) -> PlayerState:
	if not player.is_on_floor():
		return fall
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	return self
