extends Node3D

enum TargetState {Grounded, Jump, Fall}

@onready var cam_x: Node3D = $CamX
@onready var cam_y: Node3D = $CamX/CamY
#@onready var spring_arm: SpringArm3D = $CamX/CamY/SpringArm3D
@onready var camera_3d: Camera3D = $CamX/CamY/SpringArm3D/Camera3D
@onready var target: CharacterBody3D = get_parent()

var CAMERA_OFFSET: Vector3 = Vector3(0, 1.5, 0)
var INITIAL_CAMERA_Y_POSITION: float
var CAMERA_FOLLOW_SPEED: float = 3

var xYaw: float = 0
var YPitch: float = 0

var x_sens: float = 0.07
var y_sens: float = 0.07

var x_accel: float = 15
var y_accel: float = 15

var y_max: float = 75
var y_min: float = -55

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#if target:
	#	spring_arm.add_excluded_object(target.get_rid())
	pass

func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		xYaw += -event.relative.x * x_sens
		YPitch += event.relative.y * y_sens

func _physics_process(delta: float) -> void:
	YPitch = clamp(YPitch, y_min, y_max)
	cam_x.rotation_degrees.y = lerp(cam_x.rotation_degrees.y, xYaw, x_accel * delta)
	cam_y.rotation_degrees.x = lerp(cam_y.rotation_degrees.x, YPitch, y_accel * delta)
	#_calculate_and_apply_camera_y_position()


func _calculate_and_apply_camera_y_position() -> void:
	match _get_state_from_velocity():
		TargetState.Jump:
			cam_y.global_transform.origin.y = INITIAL_CAMERA_Y_POSITION
		TargetState.Fall:
			_adjust_camera_y_position()
		TargetState.Grounded:
			_adjust_camera_y_position()
			_update_camera_position()


func _get_state_from_velocity() -> TargetState:
	if target.velocity.y > 0:
		return TargetState.Jump
	elif target.velocity.y < 0:
		return TargetState.Fall
	else:
		return TargetState.Grounded


func _adjust_camera_y_position() -> void:
	INITIAL_CAMERA_Y_POSITION = cam_y.global_transform.origin.y


func _update_camera_position():
	var camera_tween = create_tween()
	camera_tween.tween_method(
		func(_value): cam_y.global_transform.origin.y = _value,
		INITIAL_CAMERA_Y_POSITION,
		target.global_transform.origin.y + CAMERA_OFFSET.y,
		CAMERA_FOLLOW_SPEED
	).set_ease(Tween.EASE_IN_OUT)
