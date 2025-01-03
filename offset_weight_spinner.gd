extends Node2D

@onready var reverse_rotation_timer: Timer = %ReverseRotationTimer
@onready var character: RigidBody2D = %Character
@onready var sword: RigidBody2D = %Sword

func _ready() -> void:
	pass

@export var char_speed = 400
@export var char_rotation_speed = 40000

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
		
func get_input():
	var char_input_direction: Vector2 = Input.get_vector("char_left", "char_right", "char_up", "char_down")
	char_velocity = char_input_direction * char_speed
	
	char_rotation_input = Input.get_axis("char_rotate_left", "char_rotate_right")
	char_rotation_velocity = char_rotation_input * char_rotation_speed

func _physics_process(delta):
	get_input()
	if char_velocity.length() > 1:
		character.apply_force(char_velocity)
	if abs(char_rotation_velocity) > 1:
		var new_rotation_velocity = char_rotation_velocity
		if _reverse_rotation:
			new_rotation_velocity = -new_rotation_velocity
		character.apply_torque(new_rotation_velocity)


func _on_ball_body_entered(body: Node) -> void:
	_reverse_rotation = true
	reverse_rotation_timer.stop()
	reverse_rotation_timer.start()


func _on_timer_timeout() -> void:
	_reverse_rotation = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
