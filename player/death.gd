class_name PlayerStateDeath extends PlayerState

@onready var idle: PlayerStateIdle = %Idle

func enter() -> void:
	player.animation_player.play("death")

func exit() -> void:
	player.animation_player.play("RESET")
