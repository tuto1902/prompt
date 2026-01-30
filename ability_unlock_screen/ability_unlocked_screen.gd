extends CanvasLayer

const HINT_MAP: Dictionary = {
	"keyboard": {
		"interact": Rect2(304, 160, 16, 16),
		"jump": Rect2(272, 192, 16, 16),
		"dash": Rect2(272, 240, 32, 16),
		"dash upwards": Rect2(272, 160, 16, 16)
	},
	"xbox": {
		"interact": Rect2(112, 0, 16, 16),
		"jump": Rect2(64, 0, 16, 16),
		"dash": Rect2(128, 272, 16, 16),
		"dash upwards": Rect2(160, 272, 16, 16)
	},
	"playstation": {
		"interact": Rect2(272, 272, 16, 16),
		"jump": Rect2(320, 272, 16, 16),
		"dash": Rect2(128, 272, 16, 16),
		"dash upwards": Rect2(160, 272, 16, 16)
	}
}

var controller_type: String = "keyboard"

@onready var jump_input: TextureRect = %JumpInput
@onready var dash_input: TextureRect = %DashInput
@onready var wall_jump_input: TextureRect = %WallJumpInput
@onready var up_dash_input: TextureRect = %UpDashInput
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = %ContinueButton
@onready var double_jump: Control = %DoubleJump
@onready var dash: Control = %Dash
@onready var wall_jump: Control = %WallJump
@onready var up_dash: Control = %UpDash


func _ready() -> void:
	jump_input.texture.region = HINT_MAP[controller_type]["jump"]
	dash_input.texture.region = HINT_MAP[controller_type]["dash"]
	wall_jump_input.texture.region = HINT_MAP[controller_type]["jump"]
	up_dash_input.texture.region = HINT_MAP[controller_type]["dash upwards"]
	continue_button.pressed.connect(_on_continue_button_pressed)
	MessageBus.player_ability_unlocked.connect(_on_player_ability_unlocked)


func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	animation_player.play("hide_hint")


func _on_player_ability_unlocked(ability: Enums.ABILITIES) -> void:
	get_tree().paused = true
	double_jump.visible = false
	dash.visible = false
	wall_jump.visible = false
	up_dash.visible = false
	match ability:
		Enums.ABILITIES.DOUBLE_JUMP:
			double_jump.visible = true
			jump_input.texture.region = HINT_MAP[controller_type]["jump"]
		Enums.ABILITIES.DASH:
			dash.visible = true
			dash_input.texture.region = HINT_MAP[controller_type]["dash"]
		Enums.ABILITIES.WALL_JUMP:
			wall_jump.visible = true
			wall_jump_input.texture.region = HINT_MAP[controller_type]["jump"]
		Enums.ABILITIES.UP_DASH:
			up_dash.visible = true
			up_dash_input.texture.region = HINT_MAP[controller_type]["dash upwards"]
	animation_player.play("show_hint")


func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		controller_type = get_controller_type(event.device)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.2:
		controller_type = get_controller_type(event.device)
	update_inputs()


func update_inputs() -> void:
	jump_input.texture.region = HINT_MAP[controller_type]["jump"]
	dash_input.texture.region = HINT_MAP[controller_type]["dash"]
	wall_jump_input.texture.region = HINT_MAP[controller_type]["jump"]
	up_dash_input.texture.region = HINT_MAP[controller_type]["dash upwards"]


func get_controller_type(device_id: int) -> String:
	var joypad_name: String = Input.get_joy_name(device_id).to_lower()
	if "xbox" in joypad_name or "xinput" in joypad_name:
		return "xbox"
	elif "playstation" in joypad_name or "ps" in joypad_name or "dualsense" in joypad_name:
		return "playstation"
	elif "nintendo" in joypad_name or "switch" in joypad_name:
		return "nintendo"
	else:
		return "keyboard"
