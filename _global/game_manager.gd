extends Node

var pickup_terminals: Dictionary = {
	Enums.TERMINALS.COLLAPSING_STATION_01: {
		"enabled": true,
	},
	Enums.TERMINALS.ABANDONED_RAILTRACKS_01: {
		"enabled": true,
	},
	Enums.TERMINALS.ABANDONED_RAILTRACKS_02: {
		"enabled": true,
	},
	Enums.TERMINALS.ABANDONED_RAILWAY_01: {
		"enabled": false,
	},
	Enums.TERMINALS.ABANDONED_RAILWAY_02: {
		"enabled": false,
	},
	Enums.TERMINALS.ABANDONED_RAILWAY_03: {
		"enabled": false,
	}
}

var pickup_scene = "uid://cr3rwf4iek5as"

var doors: Dictionary = {
	Enums.DOORS.HUB_DOOR: {
		"is_opened": false
	},
	Enums.DOORS.ABANDONED_RAILWAY_LEFT: {
		"is_opened": false
	},
	Enums.DOORS.ABANDONED_RAILWAY_BOTTOM: {
		"is_opened": false
	}
}

# TO-DO: Move all these to a dictionary
var prompt_request_active: bool = false
var player_has_response: bool = false
var hub_terminal_active: bool = true
var current_terminal: Enums.TERMINALS

var current_level: float = 1.0

var responses_delivered: float = 0.0



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
	if terminal_id == Enums.TERMINALS.ABANDONED_RAILWAY_02:
		open_door(Enums.DOORS.ABANDONED_RAILWAY_LEFT)
	if terminal_id == Enums.TERMINALS.ABANDONED_RAILWAY_03:
		open_door(Enums.DOORS.ABANDONED_RAILWAY_BOTTOM)
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
	SaveManager.save_game()
	MessageBus.prompt_requested.emit()


func response_delivered() -> void:
	MessageBus.prompt_response_delivered.emit()
	player_has_response = false
	prompt_request_active = false
	responses_delivered += 1
	if responses_delivered == 3:
		current_level += 1
		responses_delivered = 0
		
		if current_level == 2:
			pickup_terminals[Enums.TERMINALS.ABANDONED_RAILWAY_01]["enabled"] = true
			pickup_terminals[Enums.TERMINALS.ABANDONED_RAILWAY_02]["enabled"] = true
			pickup_terminals[Enums.TERMINALS.ABANDONED_RAILWAY_03]["enabled"] = true
	SaveManager.save_game(0)


func unlock_ability(ability: Enums.ABILITIES) -> void:
	MessageBus.player_ability_unlocked.emit(ability)
	SaveManager.save_game(0)
