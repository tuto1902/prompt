class_name Computer extends Node2D

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.body_entered.connect(_on_player_entered)
	area_2d.body_exited.connect(_on_player_exited)


func _on_player_entered(_player: Node2D) -> void:
	MessageBus.player_interacted.connect(_on_player_interacted)
	MessageBus.input_hint_changed.emit("Press","interact")
	pass


func _on_player_exited(_player: Node2D) -> void:
	MessageBus.player_interacted.disconnect(_on_player_interacted)
	MessageBus.input_hint_changed.emit("","")
	pass


func _on_player_interacted(_player: Player) -> void:
	SaveManager.save_game()
	# check if a dialog is already running
	if Dialogic.current_timeline != null:
		return

	Dialogic.start('chapter_one')
