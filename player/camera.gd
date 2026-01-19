extends Camera2D

@export var lookahead_distance: float = 8.0
@export var lookahead_speed: float = 1.8

var player: Player
var target_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	SceneManager.scene_entered.connect(_on_scene_entered)
	player = get_parent()
	


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var max_offset_left = limit_left - player.global_position.x
	var max_offset_right = limit_right - player.global_position.x
	if player.direction != 0:
		target_offset.x = lookahead_distance * player.direction
		target_offset.x = clamp(offset.x, max_offset_left, max_offset_right)
		offset = offset.lerp(target_offset, lookahead_speed * delta)
	#else:
		#target_offset.x = 0
	
	


func _on_scene_entered(_scene_uid: String) -> void:
	offset.x = 0
	target_offset.x = 0
