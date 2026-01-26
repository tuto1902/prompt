@tool
class_name Door extends Node2D

@export var door_name: Enums.DOORS
@export var requires_switch: bool = true
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var door_is_open: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	# listen for open/close door events
	MessageBus.open_door.connect(_on_open_door)
	MessageBus.close_door.connect(_on_close_door)
	# check with the game manager if this door is opened or closed
	if GameManager.doors[door_name]["is_opened"]:
		door_is_open = true
		animation_player.play("opened")
	else:
		door_is_open = false
		animation_player.play("closed")



func _on_open_door(door: Enums.DOORS) -> void:
	if door_name == door and door_is_open == false:
		door_is_open = true
		animation_player.play("open")


func _on_close_door(door: Enums.DOORS) -> void:
	if door_name == door and door_is_open == true:
		door_is_open = false
		animation_player.play("close")


func _on_switch_activated() -> void:
	if door_is_open:
		animation_player.play("close")
		door_is_open = false
	else:
		animation_player.play("open")
		door_is_open = true


func _on_door_is_opened() -> void:
	animation_player.play("opened")


func _get_configuration_warnings() -> PackedStringArray:
	if requires_switch and _check_for_switch() == false:
		return ["This door requires a Switch"]
	return []


func _check_for_switch() -> bool:
	for child in get_children():
		if child is Switch: 
			return true
	return false
