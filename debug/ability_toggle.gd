extends CanvasLayer

@onready var double_jump_toggle: CheckButton = %DoubleJumpToggle
@onready var wall_jump_toggle: CheckButton = %WallJumpToggle
@onready var dash_toggle: CheckButton = %DashToggle
@onready var up_dash_toggle: CheckButton = %UpDashToggle

#
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
#
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
		var player = get_tree().get_first_node_in_group("Player")
		if not player:
			return
		double_jump_toggle.button_pressed = player.abilities.get("double jump", false)
		wall_jump_toggle.button_pressed = player.abilities.get("wall jump", false)
		dash_toggle.button_pressed = player.abilities.get("dash", false)
		up_dash_toggle.button_pressed = player.abilities.get("upward dash", false)
		visible = not visible
	
		if visible:
			double_jump_toggle.toggled.connect(_on_double_jump_toggled)
			wall_jump_toggle.toggled.connect(_on_wall_jump_toggled)
			dash_toggle.toggled.connect(_on_dash_toggled)
			up_dash_toggle.toggled.connect(_on_up_dash_toggled)
		else:
			double_jump_toggle.toggled.disconnect(_on_double_jump_toggled)
			wall_jump_toggle.toggled.disconnect(_on_wall_jump_toggled)
			dash_toggle.toggled.disconnect(_on_dash_toggled)
			up_dash_toggle.toggled.disconnect(_on_up_dash_toggled)


func _on_double_jump_toggled(toggle_on: bool) -> void:
	if toggle_on:
		MessageBus.player_ability_unlocked.emit(Enums.ABILITIES.DOUBLE_JUMP)
	else:
		MessageBus.player_ability_locked.emit(Enums.ABILITIES.DOUBLE_JUMP)


func _on_wall_jump_toggled(toggle_on: bool) -> void:
	if toggle_on:
		MessageBus.player_ability_unlocked.emit(Enums.ABILITIES.WALL_JUMP)
	else:
		MessageBus.player_ability_locked.emit(Enums.ABILITIES.WALL_JUMP)


func _on_dash_toggled(toggle_on: bool) -> void:
	if toggle_on:
		MessageBus.player_ability_unlocked.emit(Enums.ABILITIES.DASH)
	else:
		MessageBus.player_ability_locked.emit(Enums.ABILITIES.DASH)


func _on_up_dash_toggled(toggle_on: bool) -> void:
	if toggle_on:
		MessageBus.player_ability_unlocked.emit(Enums.ABILITIES.UP_DASH)
	else:
		MessageBus.player_ability_locked.emit(Enums.ABILITIES.UP_DASH)
