extends Node

const default_start_scene_uid: String = "uid://faf3rgagi7tt" # Playground
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
		"abilities": player.abilities
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))


func load_game(slot: int = -1) -> void:
	current_slot = slot if slot != -1 else current_slot
	if not FileAccess.file_exists(get_file_name(current_slot)):
		return
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	var scene_path: String = save_data.get("scene_path", default_start_scene_uid)
	SceneManager.transition_to_scene(scene_path, "", Vector2.ZERO, 1, Enums.FADE_DIRECTION.RIGHT)
	await SceneManager.scene_ready
	setup_player()


func setup_player() -> void:
	var player: Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.global_position.x = save_data.get("x", 96)
	player.global_position.y = save_data.get("y", 352)
	player.abilities = save_data.get("abilities", {"double jump": false, "wall jump": false, "dash": false, "upward dash": false})
	


func create_new_game_save(slot: int) -> SaveManager:
	var new_game_scene: String = default_start_scene_uid
	current_slot = slot
	save_data = {
		"scene_path": new_game_scene,
		"x": 96,
		"y": 352,
		"abilities": {
			"double jump": false,
			"wall jump": false,
			"dash": false,
			"upward dash": false
		}
	}
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	return self


func get_file_name(slot: int) -> String:
	return "user://" + SLOTS[slot] + ".sav"


func save_file_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))
