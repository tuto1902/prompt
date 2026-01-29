class_name TitleScreen extends CanvasLayer

@export var music_track: AudioStream

@onready var main_menu: VBoxContainer = %MainMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu
@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton
@onready var settings_button: Button = %SettingsButton
@onready var exit_button: Button = %ExitButton
@onready var back_to_menu_button: Button = %BackToMenuButton


func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	back_to_menu_button.pressed.connect(_on_back_to_menu_button_pressed)
	Audio.play_music(music_track)
	show_main_menu()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not main_menu.visible:
		show_main_menu()


func show_main_menu() -> void:
	main_menu.visible = true
	settings_menu.visible = false
	if SaveManager.save_file_exists(0):
		continue_button.grab_focus()
	else:
		new_game_button.grab_focus()
		continue_button.disabled = true


func show_settings_menu() -> void:
	main_menu.visible = false
	settings_menu.visible = true
	back_to_menu_button.grab_focus()


func _on_new_game_button_pressed() -> void:
	SaveManager.create_new_game_save(0).load_game(0)


func _on_continue_button_pressed() -> void:
	SaveManager.load_game(0)


func _on_settings_button_pressed() -> void:
	show_settings_menu()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_to_menu_button_pressed() -> void:
	show_main_menu()
