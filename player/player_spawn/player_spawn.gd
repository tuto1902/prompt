class_name PlayerSpawn extends Node2D

@export_file("*.tscn") var player_scene: String = ""

func _ready() -> void:
	visible = false
	await get_tree().process_frame
	if get_tree().get_first_node_in_group("Player"):
		return
	var player_instance: Player =  load(player_scene).instantiate()
	player_instance.global_position = global_position
	get_tree().root.add_child(player_instance)
