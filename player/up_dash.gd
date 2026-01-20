class_name PlayerStateUpDash extends PlayerState

const dash_visual_spawn_interval: float = 0.03

@onready var idle: PlayerStateIdle = %Idle
@onready var wall_slide: PlayerStateWallSlide = %WallSlide
@onready var fall: PlayerStateFall = %Fall

var dash_visual_scene = load("uid://cxjiy2fo6qabo")

var dash_timer: float
var visual_spawn_timer: float
var dash_speed: float = 0.0
var dashing: bool


func enter() -> void:
	#dash_speed = player.speed * 0.08
	dashing = false
	dash_timer = player.up_dash_time
	visual_spawn_timer = 0.0
	player.animation_player.play("up_dash")


func exit() -> void:
	dash_speed = 0.0
	dash_timer = 0.0
	dashing = false
	player.dash_cooldown.start(player.dash_cooldown_time)


func process(delta: float) -> PlayerState:
	
	if dashing:
		dash_timer -= delta
		visual_spawn_timer += delta
	
	if dash_timer <= 0:
		if player.is_on_ceiling():
			return idle
		return fall
	
	if visual_spawn_timer >= dash_visual_spawn_interval:
		visual_spawn_timer = 0.0
		var dash_visual = dash_visual_scene.instantiate() as UpDashVisual
		dash_visual.global_position = player.global_position
		dash_visual.scale.x = player.facing_direction
		get_tree().root.add_child(dash_visual)
	
	return self


func physics_process(_delta: float) -> PlayerState:
	player.velocity.y = -dash_speed
	player.velocity.x = 0
	
	return self


func update_up_dash_speed() -> void:
	dashing = true
	dash_speed = player.speed * player.dash_speed_multiplier
	visual_spawn_timer = 0.0
