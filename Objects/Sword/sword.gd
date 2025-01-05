extends RigidBody2D
class_name Sword

@onready var instant_cooldown: Timer = %InstantCooldown
@onready var sword_sprite: Sprite2D = %SwordSprite
@onready var sheeth_sprite: Sprite2D = %SheethSprite
@onready var sword_collision: CollisionShape2D = %SwordCollision

var _is_swinging: bool = false
var _swing_direction: Vector2 = Vector2.ZERO
var _local_swing_direction: Vector2 = Vector2.ZERO
var swing_speed: float = 200
var instant_swing_speed: float = 80000
var swing_input: float = 0.0
var _is_full_swing_speed: bool = false

func _input(event: InputEvent) -> void:
	if !instant_cooldown.is_stopped():
		return
	if event.is_action_pressed("instant_swing_right"):
		instant_cooldown.start()
		instant_swing(-1.0)
	if event.is_action_pressed("instant_swing_left"):
		instant_cooldown.start()
		instant_swing(1.0)
	pass
	
func get_input():
	swing_input = Input.get_axis("swing_right", "swing_left")

func _physics_process(delta):
	var rot_speed = abs(angular_velocity)
	print(rot_speed)
	if !_is_full_swing_speed and rot_speed > 7.5:
		collision_layer = 2
		collision_mask = 2
		sword_sprite.self_modulate = Color.ORANGE_RED
		_is_full_swing_speed = true
	elif _is_full_swing_speed and rot_speed <= 7.5:
		collision_layer = 1
		collision_mask = 1
		sword_sprite.self_modulate = Color.WHITE
		_is_full_swing_speed = false
	get_input()
	swing(swing_input)

func instant_swing(direction: float):
	# Exit early for deadzone values
	if direction <= 0.5 and direction >= -0.5:
		return
	var impulse: Vector2 = Vector2(direction, 0)
		
	var global_impulse = to_global(Vector2.ZERO) - to_global(impulse)
	apply_central_impulse(global_impulse * swing_speed)

func swing(direction: float):
	# Exit early for deadzone values
	var normalized_direction = Vector2.ZERO
	if direction <= 0.5 and direction >= -0.5:
		_is_swinging = false
		_local_swing_direction = normalized_direction
		return
	
	# If swinging left
	if direction < 0:
		_is_swinging = true
		normalized_direction.x = -1
	# If swinging right
	else:
		_is_swinging = true
		normalized_direction.x = 1
	# If swinging left
	# swing_direction = to_global(Vector2.ZERO) - to_global(normalized_direction)
	_local_swing_direction = normalized_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _is_swinging:
		_swing_direction = to_global(Vector2.ZERO) - to_global(_local_swing_direction)
		apply_force(_swing_direction * swing_speed)
	pass
