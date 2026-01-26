class_name PickupAnchor extends Marker2D


func _ready() -> void:
	MessageBus.prompt_response_collected.connect(_on_prompt_response_collected)



func _on_prompt_response_collected(_terminal_id: Enums.TERMINALS, pickup_scene: String) -> void:
	var pickup: Pickup = load(pickup_scene).instantiate() as Pickup
	pickup.global_position = global_position
	pickup.anchor = self
	get_tree().root.add_child(pickup)
	
