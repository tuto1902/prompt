class_name Pickup extends Node2D

var anchor: Marker2D = null


func _ready() -> void:
	MessageBus.player_died.connect(_on_player_died)
	MessageBus.prompt_response_delivered.connect(_on_prompt_response_delivered)


func _on_player_died() -> void:
	queue_free()


func _on_prompt_response_delivered() -> void:
	queue_free()


func _physics_process(_delta: float) -> void:
	if not anchor:
		return
	
	global_position = global_position.lerp(anchor.global_position, 0.08)
