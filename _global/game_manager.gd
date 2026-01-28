extends Node

var pickup_terminals: Dictionary = {
	Enums.TERMINALS.COLLAPSING_STATION_01: {
		"enabled": true,
		"pickup_scene": "uid://cr3rwf4iek5as"
	},
	Enums.TERMINALS.ABANDONED_RAILTRACKS_01: {
		"enabled": true,
		"pickup_scene": "uid://cr3rwf4iek5as"
	},
	Enums.TERMINALS.ABANDONED_RAILTRACKS_02: {
		"enabled": true,
		"pickup_scene": "uid://cr3rwf4iek5as"
	}
}

var prompts: Dictionary = {
	"current_level": 1.0,
	"responses_delivered": 0
}

var doors: Dictionary = {
	Enums.DOORS.HUB_DOOR: {
		"is_opened": false
	}
}

# TO-DO: Move all these to a dictionary
var prompt_request_active: bool = false
var player_has_response: bool = false
var hub_terminal_active: bool = true
var current_terminal: Enums.TERMINALS

var current_level: float:
	get:
		return prompts["current_level"]
var responses_delivered: float:
	get:
		return prompts["responses_delivered"]


func _ready() -> void:
	#Engine.time_scale = 0.25
	MessageBus.prompt_response_collected.connect(_on_prompt_response_collected)
	MessageBus.player_died.connect(_on_player_died)


func _on_player_died() -> void:
	pickup_terminals[current_terminal]["enabled"] = true
	SaveManager.load_game(0)


func _on_prompt_response_collected(terminal_id: Enums.TERMINALS, save_game: bool) -> void:
	current_terminal = terminal_id
	pickup_terminals[terminal_id]["enabled"] = false
	player_has_response = true
	hub_terminal_active = true
	if save_game:
		SaveManager.save_game()


func open_door(door_name: Enums.DOORS) -> void:
	doors[door_name]["is_opened"] = true
	MessageBus.open_door.emit(door_name)


func close_door(door_name: Enums.DOORS) -> void:
	doors[door_name]["is_opened"] = false
	MessageBus.close_door.emit(door_name)


func prompt_requested():
	prompt_request_active = true
	hub_terminal_active = false
	MessageBus.prompt_requested.emit()


func response_delivered() -> void:
	MessageBus.prompt_response_delivered.emit()
	player_has_response = false
	prompt_request_active = false
	prompts["responses_delivered"] += 1
	if prompts["responses_delivered"] == 3:
		prompts["current_level"] += 1
		prompts["responses_delivered"] = 0
		
	# Unlock abilities based on current level
	# Enable current level terminals
	SaveManager.save_game()
