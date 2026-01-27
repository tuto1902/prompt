extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MessageBus.prompt_requested.connect(_on_prompt_requested)


func _on_prompt_requested() -> void:
	print("Open the door")
