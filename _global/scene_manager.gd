extends CanvasLayer

signal load_scene_started
signal load_scene_finished
signal scene_entered(scene_uid: String)
signal scene_ready(door_name: String, player_offset: Vector2, player_direction: float)

@onready var texture_rect: TextureRect = %TextureRect
@onready var fade: Control = $Fade

var current_scene_uid: String = ""


func _ready() -> void:
	fade.visible = false
	await get_tree().process_frame
	load_scene_finished.emit()


func transition_to_scene(target_scene: String, door_name: String, player_offset: Vector2, player_direction: float, fade_direction: Enums.FADE_DIRECTION) -> void:
	var fade_position = get_fade_position(fade_direction)
	
	fade.visible = true
	load_scene_started.emit()
	
	await fade_screen(fade_position, Vector2.ZERO)
	get_tree().paused = true
	
	get_tree().change_scene_to_file(target_scene)
	current_scene_uid = ResourceUID.path_to_uid(target_scene)
	scene_entered.emit(current_scene_uid)
	
	await get_tree().scene_changed
	scene_ready.emit(door_name, player_offset, player_direction)
	
	get_tree().paused = false
	load_scene_finished.emit()
	await fade_screen(Vector2.ZERO, -fade_position)
	fade.visible = false


func get_fade_position(direction: Enums.FADE_DIRECTION) -> Vector2:
	var width = texture_rect.texture.get_width()
	var height = texture_rect.texture.get_height()
	var position: Vector2 = Vector2(width, height)
	match direction:
		Enums.FADE_DIRECTION.LEFT:
			position *= Vector2.LEFT
		Enums.FADE_DIRECTION.RIGHT:
			position *= Vector2.RIGHT
		Enums.FADE_DIRECTION.UP:
			position *= Vector2.UP
		Enums.FADE_DIRECTION.DOWN:
			position *= Vector2.DOWN
	return position


func fade_screen(from: Vector2, to: Vector2) -> Signal:
	fade.position = from
	var tween = create_tween()
	tween.tween_property(fade, "position", to, 0.3)
	return tween.finished
