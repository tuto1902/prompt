extends CanvasLayer

@onready var continue_button: Button = %ContinueButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _on_dialogic_signal(argument: String) -> void:
	if argument == "show_tutorial":
		get_tree().paused = true
		animation_player.play("show_hint")


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	animation_player.play("hide_hint")
