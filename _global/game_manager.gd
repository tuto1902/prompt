extends Node

var pickup_terminals: Dictionary = {
	Enums.TERMINALS.COLLAPSING_STATION_01: {
		"enabled": true
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

var player_has_response: bool = false
var current_level: float:
	get:
		return prompts["current_level"]
var responses_delivered: float:
	get:
		return prompts["responses_delivered"]


func _ready() -> void:
	MessageBus.prompt_response_collected.connect(_on_prompt_response_collected)


func _on_prompt_response_collected(terminal_id: Enums.TERMINALS, _pickup_scene: String) -> void:
	pickup_terminals[terminal_id]["enabled"] = false
	player_has_response = true


func open_door(door_name: Enums.DOORS) -> void:
	doors[door_name]["is_opened"] = true
	MessageBus.open_door.emit(door_name)


func close_door(door_name: Enums.DOORS) -> void:
	doors[door_name]["is_opened"] = false
	MessageBus.close_door.emit(door_name)


func prompt_requested():
	MessageBus.prompt_requested.emit()


func response_delivered() -> void:
	MessageBus.prompt_response_delivered.emit()
	player_has_response = false
	prompts["responses_delivered"] += 1
	if prompts["responses_delivered"] == 3:
		prompts["current_level"] += 1
		prompts["responses_delivered"] = 0
		
	# Unlock abilities based on current level
	# Enable current level terminals
