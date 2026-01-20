class_name UpDashVisual extends Node2D

@onready var sprite: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var position_tween = create_tween()
	position_tween.tween_property(sprite, "offset:y", -4, 0.17).set_trans(Tween.TRANS_SINE)
	
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, "modulate:a", 0.0, 0.18).set_trans(Tween.TRANS_SINE)
	await modulate_tween.finished
	queue_free()
