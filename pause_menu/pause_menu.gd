extends CanvasLayer

@onready var exit_to_menu_button: Button = %ExitToMenuButton
@onready var quit_game_button: Button = %QuitGameButton
@onready var resume_button: Button = %ResumeButton
@onready var music_volume: HSlider = %MusicVolume
@onready var sfx_volume: HSlider = %SfxVolume
@onready var control: Control = $Control


func _ready() -> void:
	MessageBus.game_paused.connect(_on_game_paused)
	music_volume.value_changed.connect(_on_music_volume_value_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_value_changed)
	exit_to_menu_button.pressed.connect(_on_exit_to_menu_button_pressed)
	quit_game_button.pressed.connect(_on_quit_game_button_pressed)
	resume_button.pressed.connect(_on_resume_button_pressed)


func _on_game_paused() -> void:
	visible = true
	resume_button.grab_focus()
	music_volume.value = Audio.music.volume_linear
	sfx_volume.value = Audio.sfx.volume_linear
	get_tree().paused = true
	

func _on_exit_to_menu_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	SceneManager.transition_to_scene("uid://dk1h5p6kr3ddo", "", Vector2(999, 999), 1.0, Enums.FADE_DIRECTION.LEFT)


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	


func _on_music_volume_value_changed(value: float) -> void:
	Audio.music.volume_linear = value


func _on_sfx_volume_value_changed(value: float) -> void:
	Audio.sfx.volume_linear = value
