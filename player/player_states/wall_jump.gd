class_name PlayerStateWallJump extends PlayerState

@onready var fall: PlayerStateFall = %Fall

var wall_jump_timer: float

func enter() -> void:
	player.animation_player.play("wall_jump")
	player.velocity.x = player.direction * player.speed * 0.8
	player.velocity.y = player.jump_velocity * 0.6
	wall_jump_timer = player.wall_jump_time


func exit() -> void:
	wall_jump_timer = 0
	pass


func process(delta: float) -> PlayerState:
	wall_jump_timer -= delta
	if wall_jump_timer <= 0:
		return fall
	return self
