class_name PlayerStateDash extends PlayerState

const dash_visual_spawn_interval: float = 0.03

@onready var idle: PlayerStateIdle = %Idle
@onready var wall_slide: PlayerStateWallSlide = %WallSlide
@onready var fall: PlayerStateFall = %Fall

var dash_visual_scene = load("uid://1onmyypwb4lc")

var dash_timer: float
var visual_spawn_timer: float
var dash_speed

func enter() -> void:
	player.animation_player.play("dash")
	dash_speed = player.speed * player.dash_speed_multiplier
	dash_timer = player.dash_time
	visual_spawn_timer = 0.0



func exit() -> void:
	dash_timer = 0.0
	player.dash_cooldown.start(player.dash_cooldown_time)


func process(delta: float) -> PlayerState:
	dash_timer -= delta
	visual_spawn_timer += delta
	
	if dash_timer <= 0:
		if player.is_on_floor():
			return idle
		return fall
	
	if visual_spawn_timer >= dash_visual_spawn_interval:
		visual_spawn_timer = 0.0
		var dash_visual = dash_visual_scene.instantiate() as DashVisual
		dash_visual.global_position = player.global_position
		dash_visual.scale.x = player.facing_direction
		get_tree().root.add_child(dash_visual)
	
	return self


func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.facing_direction * dash_speed
	player.velocity.y = 0
	
	if player.is_on_wall_only():
		if player.abilities["wall jump"]:
			return wall_slide
	
	if player.is_on_wall():
		if player.is_on_floor():
			return idle
		return fall
	return self
