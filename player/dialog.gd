class_name PlayerStateDialog extends PlayerState

func enter() -> void:
	MessageBus.prompt_requested.connect(_on_prompt_requested)


func exit() -> void:
	MessageBus.prompt_requested.disconnect(_on_prompt_requested)


func _on_prompt_requested() -> void:
	player.transition_to_state(player.previous_state)
