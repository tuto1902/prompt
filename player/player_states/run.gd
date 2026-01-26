class_name PlayerStateRun extends PlayerState

@onready var idle: PlayerStateIdle = %Idle
@onready var fall: PlayerStateFall = %Fall
@onready var jump: PlayerStateJump = %Jump
@onready var up_dash: PlayerStateUpDash = %UpDash

@export var footsteps_sound: AudioStream


func enter() -> void:
	player.sfx_player.stream = footsteps_sound
	player.animation_player.play("run")


func exit() -> void:
	if player.animation_player.animation_finished.is_connected(_on_animation_finished):
		player.animation_player.animation_finished.disconnect(_on_animation_finished)


func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump
	if event.is_action_pressed("ability") and player.is_on_floor():
		if player.abilities["upward dash"]:
			return up_dash
	return self


func process(_delta: float) -> PlayerState:
	player.update_direction()
	player.flip_sprite()
	if player.direction == 0:
		return idle
	return self


func play_footstep_sound() -> void:
	randomize()
	var pitch_scale = randf_range(0.8, 1.2)
	player.sfx_player.pitch_scale = pitch_scale
	player.sfx_player.play()


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "run_turn":
		player.animation_player.play("run")


func physics_process(_delta: float) -> PlayerState:
	if not player.is_on_floor():
		return fall
	player.velocity.x = player.direction * player.speed
	return self
