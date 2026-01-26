class_name HubTerminal extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var input_hint: InputHint = $InputHint

var player_interacted: bool = false

@export var prompt_delivered_sound: AudioStream

func _ready() -> void:
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)
	MessageBus.prompt_response_delivered.connect(_on_prompt_response_delivered)


func _on_player_entered(_player: Node2D) -> void:
	player_interacted = false
	MessageBus.player_interacted.connect(_on_player_interacted)
	MessageBus.input_hint_changed.connect(input_hint._on_input_hint_changed)
	MessageBus.input_hint_changed.emit("Press","interact")


func _on_player_exited(_player: Node2D) -> void:
	MessageBus.player_interacted.disconnect(_on_player_interacted)
	MessageBus.input_hint_changed.disconnect(input_hint._on_input_hint_changed)
	if player_interacted:
		return
	input_hint.hide_hint()


func _on_prompt_response_delivered() -> void:
	Audio.play_sound_effect(prompt_delivered_sound)



func _on_player_interacted(_player: Player) -> void:
	input_hint.hide_hint()
	SaveManager.save_game()
	player_interacted = true
	Dialogic.start("chapter_one")
