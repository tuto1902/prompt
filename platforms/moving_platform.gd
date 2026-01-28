extends AnimatableBody2D

enum directions {LEFT, RIGHT}

@onready var ray_cast_right: RayCast2D = %RayCastRight
@onready var ray_cast_left: RayCast2D = %RayCastLeft

@export var speed: float = 10
@export var starting_direction: directions

var move_direction = Vector2.LEFT


func _ready() -> void:
	match starting_direction:
		directions.LEFT: move_direction = Vector2.LEFT
		directions.RIGHT: move_direction = Vector2.RIGHT


func _process(_delta: float) -> void:
	if ray_cast_left.is_colliding():
		move_direction = Vector2.RIGHT
	if ray_cast_right.is_colliding():
		move_direction = Vector2.LEFT


func _physics_process(_delta: float) -> void:
	move_and_collide(move_direction * speed)
