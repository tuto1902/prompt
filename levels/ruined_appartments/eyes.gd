extends Node2D

@onready var eyes_area: Area2D = %eyes_area
@onready var node_2d: Node2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eyes_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if GameManager.current_level == 5:
			node_2d.visible = true
