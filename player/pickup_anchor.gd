class_name PickupAnchor extends Marker2D


func _ready() -> void:
	MessageBus.prompt_response_collected.connect(_on_prompt_response_collected)


func _on_prompt_response_collected(terminal_id: Enums.TERMINALS, _save_game: bool) -> void:
	var current_pickup = get_tree().get_first_node_in_group("Pickup")
	if current_pickup:
		return
	var pickup: Pickup = load(GameManager.pickup_terminals[terminal_id]["pickup_scene"]).instantiate() as Pickup
	pickup.global_position = global_position
	pickup.anchor = self
	get_tree().root.add_child(pickup)
	
