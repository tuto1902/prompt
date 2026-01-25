class_name Beholder extends Node2D

@onready var pivot: Node2D = $Sprite2D/Pivot

@export var max_distance: float = 10.0
@export var player: Player = null

var look_at_player: float = true


func _ready() -> void:
	pass
	#detection_area.body_entered.connect(_on_body_entered)
	#detection_area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		look_at_player = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		look_at_player = false


func _process(_delta: float) -> void:
	while not player:
		player = get_tree().get_first_node_in_group("Player")
	if look_at_player:
		var direction_to_player: Vector2 = pivot.global_position.direction_to(player.eye_line.global_position)
		pivot.position = lerp(pivot.position, direction_to_player * max_distance, 0.06)
	else:
		pivot.position = lerp(pivot.position, Vector2.ZERO, 0.06)
