extends CharacterBody3D

@export var SPEED: float = 200
@export var ROTATION_SPEED: float = 7
@export var JUMP_FORCE: float = 5
@export var JUMPS: int = 2
@export var CAMERA_FOLLOW_SPEED: float = 2.5

var ACCELERATION: float = 0.3
var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var DIRECTION = Vector3.FORWARD
var JUMPS_LEFT: int = JUMPS
var FACING_DIRECTION: Vector2

@onready var cam_x: Node3D = $CamRoot/CamX
@onready var cam_y: Node3D = $CamRoot/CamX/CamY
@onready var player_mesh: Node3D = $Armature
@onready var cam_root: Node3D = $CamRoot
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var coyote_timer: Timer = $CoyoteTimer
#@onready var vfx: GPUParticles3D = $VFX/GPUParticles3D


func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func _apply_gravity(delta):
	if !is_on_floor():
		velocity.y -= GRAVITY * delta * 1.2
	else:
		velocity.y = 0
		

func _set_direction() -> void:
	var rotation_x = cam_x.global_transform.basis.get_euler().y
	DIRECTION = Vector3(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		0,
		Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
		).rotated(Vector3.UP, rotation_x).normalized()
	
	if DIRECTION != Vector3.ZERO:
		FACING_DIRECTION = Vector2(DIRECTION.x, DIRECTION.z)


func _set_velocity(delta) -> void:
	velocity.x = DIRECTION.x * SPEED * delta
	velocity.z = DIRECTION.z * SPEED * delta


func _set_rotation(delta) -> void:
	player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(FACING_DIRECTION.x, FACING_DIRECTION.y), delta * ROTATION_SPEED)


func movement_handler(delta) -> void:
	_set_direction()
	_set_velocity(delta)
	_set_rotation(delta)
	_apply_falling_animation()
	_apply_gravity(delta)


func stretch() -> void:
	var stretch_tween = create_tween()
	stretch_tween.tween_property(player_mesh, "scale", Vector3(.7, 1.3, .7), .1).set_ease(Tween.EASE_IN)
	stretch_tween.tween_property(player_mesh, "scale", Vector3(1, 1, 1), .2).set_ease(Tween.EASE_OUT)


func squatch() -> void:
	var squach_tween = create_tween()
	squach_tween.tween_property(player_mesh, "scale", Vector3(1.3, .7, .7), .05).set_ease(Tween.EASE_OUT)
	squach_tween.tween_property(player_mesh, "scale", Vector3(1, 1, 1), .1).set_ease(Tween.EASE_OUT)


func _apply_falling_animation() -> void:
	if velocity.y < 0:
		var fall_blend: float = animation_tree.get("parameters/falling/blend_amount")
		animation_tree.set("parameters/falling/blend_amount", lerp(fall_blend, 1.0, 0.1))
	else:
		animation_tree.set("parameters/falling/blend_amount", 0)