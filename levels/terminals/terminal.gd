class_name Terminal extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var input_hint: InputHint = $InputHint

@export var terminal_id: Enums.TERMINALS
 
@export var pickup_sound: AudioStream


func _ready() -> void:
	if GameManager.pickup_terminals[terminal_id]["enabled"]:
		animation_player.play("blinking")
		area_2d.body_entered.connect(_on_player_entered)
		area_2d.body_exited.connect(_on_player_exited)
	else:
		animation_player.play("idle")
		area_2d.monitoring = false
	


func _on_player_entered(_player: Node2D) -> void:
	MessageBus.player_interacted.connect(_on_player_interacted)
	MessageBus.input_hint_changed.connect(input_hint._on_input_hint_changed)
	MessageBus.input_hint_changed.emit("Press","interact")


func _on_player_exited(_player: Node2D) -> void:
	MessageBus.player_interacted.disconnect(_on_player_interacted)
	MessageBus.input_hint_changed.disconnect(input_hint._on_input_hint_changed)
	input_hint.hide_hint()


func _on_player_interacted(_player: Player) -> void:
	MessageBus.prompt_response_collected.emit(terminal_id, true)
	Audio.play_sound_effect(pickup_sound)
	animation_player.play("idle")
	input_hint.hide_hint()
	area_2d.monitoring = false
