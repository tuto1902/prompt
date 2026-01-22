class_name InputHint extends Node2D

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
var current_hint: String = ""
var current_verb: String = ""

@onready var verb_label: Label = %Verb
@onready var input_texture: TextureRect = %Input
@onready var hint_label: Label = %Hint
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	MessageBus.input_hint_changed.connect(_on_input_hint_changed)


func _on_input_hint_changed(action: String, hint: String) -> void:
	current_hint = hint
	current_verb = action
	toggle_hint()


func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		controller_type = "keyboard"
	elif event is InputEventJoypadButton:
		controller_type = get_controller_type(event.device)
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.2:
		controller_type = get_controller_type(event.device)
	update_input_texture()


func update_input_texture() -> void:
	if current_hint == "":
		return
	input_texture.texture.region = HINT_MAP[controller_type][current_hint]


func toggle_hint() -> void:
	if current_hint == "":
		animation_player.play("hide_hint")
		return
	
	verb_label.text = current_verb
	hint_label.text = current_hint
	update_input_texture()
	animation_player.play("show_hint")


func get_controller_type(device_id: int) -> String:
	var joypad_name: String = Input.get_joy_name(device_id).to_lower()
	if "xbox" in joypad_name or "xinput" in joypad_name:
		return "xbox"
	elif "playstation" in joypad_name or "ps" in joypad_name or "dualsense" in joypad_name:
		return "playstation"
	elif "nintendo" in joypad_name or "switch" in joypad_name:
		return "nintendo"
	else:
		return "unknown"
