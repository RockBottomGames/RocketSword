extends CharacterBody2D

@onready var swing_area: Area2D = %SwingArea
@onready var swing_area_collision: CollisionShape2D = %SwingAreaCollision
@onready var spin_meter: SpinMeter = %SpinMeter

@export var run_speed = 400


var _intended_direction: Vector2 = Vector2.ZERO
var intended_direction: Vector2:
	get:
		return _intended_direction
	set(value):
		_intended_direction = value

var _intended_spin_direction: int = 0
var _right_spin_progress: float = 0.0
var _left_spin_progress: float = 0.0

var _spin_rate: float = 1
var _med_spin_rate: float = _spin_rate
var _slow_spin_rate: float = _spin_rate / 2.0
var _spin_hill: float = 0.7 # 0.616

func get_input():
	var player_input_direction: Vector2 = Input.get_vector("player_left", "player_right", "player_up", "player_down")
	intended_direction = player_input_direction
	
	var player_input_swing_direction: float = Input.get_axis("swing_left", "swing_right")
	if player_input_swing_direction <= -0.5:
		_intended_spin_direction = -1
	elif player_input_swing_direction >= 0.5:
		_intended_spin_direction = 1
	else:
		_intended_spin_direction = 0

func _reduce_right_progress(delta, rate):
	if _right_spin_progress < 0.0:
		_right_spin_progress = 0.0
		return
	if _right_spin_progress == 0.0:
		return
	_right_spin_progress = _compute_reduce_progress(_right_spin_progress, delta, rate)
	
func _reduce_left_progress(delta, rate):
	if _left_spin_progress < 0.0:
		_left_spin_progress = 0.0
		return
	if _left_spin_progress == 0.0:
		return
	_left_spin_progress = _compute_reduce_progress(_left_spin_progress, delta, rate)

func _compute_reduce_progress(progress, delta, rate) -> float:
	return 0.0 if progress <= 0.0 else progress - (delta * rate)

func _increase_right_progress(delta, rate):
	_right_spin_progress = _compute_increase_progress(_right_spin_progress, delta, rate)
	
func _increase_left_progress(delta, rate):
	_left_spin_progress = _compute_increase_progress(_left_spin_progress, delta, rate)

func _compute_increase_progress(progress, delta, rate) -> float:
	return 0.0 if progress >= 1.0 else progress + (delta * rate)

func handle_spin_calculations(delta):
	if _intended_spin_direction > 0:
		if _left_spin_progress > 0:
			_reduce_left_progress(delta, _spin_rate)
			return
		_increase_right_progress(delta, _spin_rate)
		return
	if _intended_spin_direction < 0:
		if _right_spin_progress > 0:
			_reduce_right_progress(delta, _spin_rate)
			return
		_increase_left_progress(delta, _spin_rate)
		return
	if _left_spin_progress < _spin_hill:
		_reduce_left_progress(delta, _slow_spin_rate)
	else:
		_increase_left_progress(delta, _med_spin_rate)
	if _right_spin_progress < _spin_hill:
		_reduce_right_progress(delta, _slow_spin_rate)
	else:
		_increase_right_progress(delta, _med_spin_rate)

func _show_spin():
	swing_area.show()
	swing_area_collision.set_deferred("disabled", false)

func _hide_spin():
	swing_area.hide()
	swing_area_collision.set_deferred("disabled", true)
	
func _physics_process(delta):
	get_input()
	handle_spin_calculations(delta)
	velocity = intended_direction.normalized() * run_speed
	if _right_spin_progress > 0.0:
		swing_area.scale.x = 1
		spin_meter.progress_ratio = _right_spin_progress
		_show_spin()
	elif _left_spin_progress > 0.0:
		swing_area.scale.x = -1
		spin_meter.progress_ratio = _left_spin_progress
		_show_spin()
	else:
		_hide_spin()
	move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hide_spin()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
