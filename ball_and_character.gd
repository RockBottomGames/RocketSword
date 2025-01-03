extends Node2D

@onready var character: RigidBody2D = %Character
@onready var ball: RigidBody2D = %Ball
@onready var reverse_rotation_timer: Timer = %ReverseRotationTimer

func _ready() -> void:
	character

@export var char_speed = 1000

var _reverse_rotation: bool = false

var _char_rotation_input: float = 0.0
var char_rotation_input: float:
	get:
		return _char_rotation_input
	set(value):
		if value != _char_rotation_input:
			_reverse_rotation = false
		_char_rotation_input = value

var _char_rotation_velocity: float = 0.0
var char_rotation_velocity: float:
	get:
		return _char_rotation_velocity
	set(value):
		_char_rotation_velocity = value

var _char_velocity: Vector2 = Vector2.ZERO
var char_velocity: Vector2:
	get:
		return _char_velocity
	set(value):
		_char_velocity = value

@export var ball_speed = 20000

var _ball_velocity: Vector2 = Vector2.ZERO
var ball_velocity: Vector2:
	get:
		return _ball_velocity
	set(value):
		_ball_velocity = value
		
func get_input():
	var ball_input_direction: Vector2 = Input.get_vector("ball_left", "ball_right", "ball_up", "ball_down")
	ball_velocity = ball_input_direction * ball_speed
	
	char_rotation_input = Input.get_axis("char_left", "char_right")
	char_rotation_velocity = char_rotation_input * char_speed

func _physics_process(delta):
	get_input()
	if char_velocity.length() > 1:
		character.apply_force(char_velocity)
	if ball_velocity.length() > 1:
		ball.apply_force(ball_velocity)
	if abs(char_rotation_velocity) > 1:
		var ball_diff: Vector2 =  ball.position - character.position
		var ball_orth: Vector2 = ball_diff.normalized().orthogonal()
		if _reverse_rotation:
			ball_orth = -ball_orth
		character.apply_force(ball_orth * char_rotation_velocity)
	ball.linear_velocity


func _on_ball_body_entered(body: Node) -> void:
	print("entered!")
	if body == character:
		return
	_reverse_rotation = true
	reverse_rotation_timer.stop()
	reverse_rotation_timer.start()
	
	ball.linear_velocity = Vector2((2 * character.linear_velocity.x) - ball.linear_velocity.x,(2 * character.linear_velocity.y) - ball.linear_velocity.y)


func _on_timer_timeout() -> void:
	_reverse_rotation = false
