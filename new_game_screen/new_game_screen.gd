extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start_game() -> void:
	SaveManager.create_new_game_save(0).load_game(0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		animation_player.seek(25)
