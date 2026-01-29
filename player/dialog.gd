class_name PlayerStateDialog extends PlayerState

@onready var idle: PlayerStateIdle = %Idle

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.animation_player.play("idle")
	MessageBus.prompt_requested.connect(_on_prompt_requested)


func exit() -> void:
	MessageBus.prompt_requested.disconnect(_on_prompt_requested)


func _on_prompt_requested() -> void:
	player.transition_to_state(idle)
