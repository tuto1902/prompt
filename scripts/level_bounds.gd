@tool
class_name LevelBounds extends Node2D

@export_range(320, 1920, 16, "suffix:px") var width: int = 320:
	set = _on_width_set
@export_range(180, 1080, 16, "suffix:px") var height: int = 180:
	set = _on_height_set


func _ready() -> void:
	z_index = 256
	if Engine.is_editor_hint():
		return
		
	var camera: Camera2D = null
	while not camera:
		await get_tree().process_frame
		camera = get_viewport().get_camera_2d()
	
	camera.limit_smoothed = false
	camera.position_smoothing_enabled = false
	camera.limit_left = int(global_position.x)
	camera.limit_top = int(global_position.y)
	camera.limit_right = int(global_position.x) + width
	camera.limit_bottom = int(global_position.y) + height
	await get_tree().process_frame
	camera.limit_smoothed = true
	camera.position_smoothing_enabled = true

func _draw() -> void:
	if Engine.is_editor_hint():
		var rectangle: Rect2 = Rect2(Vector2.ZERO, Vector2(width, height))
		draw_rect(rectangle, Color.PURPLE, false, 2)

func _on_width_set(value: int):
	width = value
	queue_redraw()


func _on_height_set(value: int):
	height = value
	queue_redraw()
