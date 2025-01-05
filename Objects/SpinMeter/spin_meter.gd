@tool
extends Node2D
class_name SpinMeter
@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var _progress_ratio: float = 0.0
@export var progress_ratio: float:
	get:
		return _progress_ratio
	set(value):
		_progress_ratio = value
		_set_progress_ratio()

func _set_progress_ratio() -> void:
	if path_follow_2d != null:
		path_follow_2d.progress_ratio = _smooth_path(_progress_ratio)
	

func _smooth_path(old_path: float) -> float:
	if old_path <= 0.0:
		return 0.0
	if old_path >= 1.0:
		return 1.0
	# Use this to skew the progress however makes sense, for now return input
	return (3.9284 * pow(old_path - 0.5389, 3.0) + 0.616) * 0.65 + (0.35 * old_path)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_progress_ratio()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
