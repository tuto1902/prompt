@tool
class_name LevelTransition extends Node2D

@export_range(2, 16, 1, "or_greater") var size: int = 2:
	set(value):
		size = value
		apply_area_settings()

@export var location: Enums.ENTER_SIDE = Enums.ENTER_SIDE.LEFT:
	set(value):
		location = value
		apply_area_settings()

@export_file("*.tscn") var target_scene: String = ''
@export var target_area_name: String = 'LevelTransition'

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	apply_area_settings()
	SceneManager.scene_ready.connect(_on_new_scene_ready)
	SceneManager.load_scene_finished.connect(_on_load_scene_finished)


func apply_area_settings() -> void:
	area_2d = get_node_or_null("Area2D")
	if not area_2d:
		return
	
	match location:
		Enums.ENTER_SIDE.LEFT:
			area_2d.scale.x = -1
			area_2d.scale.y = size
		Enums.ENTER_SIDE.RIGTH:
			area_2d.scale.x = 1
			area_2d.scale.y = size
		Enums.ENTER_SIDE.TOP:
			area_2d.scale.x = size
			area_2d.scale.y = 1
		Enums.ENTER_SIDE.BOTTOM:
			area_2d.scale.x = size
			area_2d.scale.y = -1


func _on_player_entered(player: Node2D) -> void:
	var offset: Vector2 = Vector2.ZERO
	var fade_direction: Enums.FADE_DIRECTION
	match location:
		Enums.ENTER_SIDE.LEFT:
			offset.x = -16
			offset.y = player.global_position.y - global_position.y
			fade_direction = Enums.FADE_DIRECTION.LEFT
		Enums.ENTER_SIDE.RIGTH:
			offset.x = 16
			offset.y = player.global_position.y - global_position.y
			fade_direction = Enums.FADE_DIRECTION.RIGHT
		Enums.ENTER_SIDE.TOP:
			offset.x = player.global_position.x - global_position.x
			offset.y = -16
			fade_direction = Enums.FADE_DIRECTION.UP
		Enums.ENTER_SIDE.BOTTOM:
			offset.x = player.global_position.x - global_position.x
			offset.y = 21
			fade_direction = Enums.FADE_DIRECTION.DOWN
	
	var player_direction: float = player.sprite.scale.x
	SceneManager.transition_to_scene(target_scene, target_area_name, offset, player_direction, fade_direction)


func _on_new_scene_ready(target_area: String, offset: Vector2, player_direction: float) -> void:
	if target_area != name:
		return
	
	var player := get_tree().get_first_node_in_group("Player")
	player.global_position = global_position + offset
	player.sprite.scale.x = player_direction


func _on_load_scene_finished() -> void:
	area_2d.monitoring = false
	area_2d.body_entered.connect(_on_player_entered)
	await get_tree().physics_frame
	await get_tree().physics_frame
	area_2d.monitoring = true
