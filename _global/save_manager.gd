extends Node

const default_start_scene_uid: String = "uid://b28w77vt64l63" # Hub
const SLOTS: Array[String] = [
	"data_0",
]
var current_slot: int = 0
var save_data: Dictionary = {}


func _ready() -> void:
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			save_game(current_slot)
		elif event.keycode == KEY_F7:
			load_game(current_slot)


func save_game(slot: int = -1) -> void:
	var scene_uid = SceneManager.current_scene_uid
	if scene_uid == "":
		scene_uid = default_start_scene_uid
	var player: Player = get_tree().get_first_node_in_group("Player")
	current_slot = slot if slot != -1 else current_slot
	save_data = {
		"scene_path": scene_uid,
		"x": player.global_position.x,
		"y": player.global_position.y,
		"double jump": player.abilities[Enums.ABILITIES.DOUBLE_JUMP],
		"wall jump":player.abilities[Enums.ABILITIES.WALL_JUMP],
		"dash": player.abilities[Enums.ABILITIES.DASH],
		"up dash": player.abilities[Enums.ABILITIES.UP_DASH],
		"pickup_terminals": GameManager.pickup_terminals.values(),
		"doors": GameManager.doors.values(),
		"current_level": GameManager.current_level,
		"responses_delivered": GameManager.responses_delivered,
		"prompt_request_active": GameManager.prompt_request_active,
		"player_has_response": GameManager.player_has_response,
		"hub_terminal_active": GameManager.hub_terminal_active,
		"current_terminal": int(GameManager.current_terminal)
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))


func load_game(slot: int = -1) -> void:
	current_slot = slot if slot != -1 else current_slot
	if not FileAccess.file_exists(get_file_name(current_slot)):
		return
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	setup_game()
	var scene_path: String = save_data.get("scene_path", default_start_scene_uid)
	SceneManager.transition_to_scene(scene_path, "", Vector2.ZERO, 1, Enums.FADE_DIRECTION.RIGHT)
	await SceneManager.scene_ready
	setup_player()


func setup_game() -> void:
	var pickup_terminals: Array = save_data.get("pickup_terminals")
	var doors: Array = save_data.get("doors")
	
	GameManager.prompt_request_active = save_data.get("prompt_request_active", false)
	GameManager.player_has_response = save_data.get("player_has_response", false)
	GameManager.hub_terminal_active = save_data.get("hub_terminal_active", true)
	GameManager.current_terminal = save_data.get("current_terminal") as Enums.TERMINALS
	GameManager.current_level = save_data.get("current_level", 0)
	GameManager.responses_delivered = save_data.get("responses_delivered", 0)
	
	if pickup_terminals:
		for i in pickup_terminals.size():
			GameManager.pickup_terminals[i] = pickup_terminals[i]
	if doors:
		for i in doors.size():
			GameManager.doors[i] = doors[i]



func setup_player() -> void:
	var player: Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.global_position.x = save_data.get("x", 96)
	player.global_position.y = save_data.get("y", 352)
	player.abilities[Enums.ABILITIES.DOUBLE_JUMP] = save_data.get("double jump", false)
	if player.abilities[Enums.ABILITIES.DOUBLE_JUMP] == true:
		player.allowed_jumps = 2
	player.abilities[Enums.ABILITIES.DASH] = save_data.get("dash", false)
	player.abilities[Enums.ABILITIES.WALL_JUMP] = save_data.get("wall jump", false)
	player.abilities[Enums.ABILITIES.UP_DASH] = save_data.get("up dash", false)
	if GameManager.player_has_response:
		GameManager.doors[Enums.DOORS.HUB_DOOR]["is_opened"] = true
		MessageBus.prompt_response_collected.emit(GameManager.current_terminal, false)
	


func create_new_game_save(slot: int) -> SaveManager:
	var new_game_scene: String = default_start_scene_uid
	current_slot = slot
	save_data = {
		"scene_path": new_game_scene,
		"x": 92,
		"y": 80,
		"double jump": false,
		"wall jump": false,
		"dash": false,
		"up dash": false,
		"pickup_terminals": GameManager.pickup_terminals.values(),
		"doors": GameManager.doors.values(),
		"current_level": GameManager.current_level,
		"responses_delivered": GameManager.responses_delivered,
		"prompt_request_active": GameManager.prompt_request_active,
		"player_has_response": GameManager.player_has_response,
		"hub_terminal_active": GameManager.hub_terminal_active,
		"current_terminal": int(GameManager.current_terminal)
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	return self


func get_file_name(slot: int) -> String:
	return "user://" + SLOTS[slot] + ".sav"


func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))
