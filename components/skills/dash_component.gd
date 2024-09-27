extends Node
class_name DashComponent

@export var force: float = 1000.0

var character: CharacterBody3D
var cooldown: float = 5.0
var duration: float = 0.5
var IS_DASHING: bool = false
var CAN_DASH: bool = true

var timer_duration: Timer
var timer_cooldown: Timer

func _ready() -> void:
	character = get_parent()
	
	timer_duration = Timer.new()
	timer_duration.set_wait_time(duration)
	timer_duration.set_one_shot(true)
	timer_duration.connect("timeout", _on_timer_duration_timeout)

	timer_cooldown = Timer.new()
	timer_cooldown.set_wait_time(cooldown)
	timer_cooldown.set_one_shot(true)
	timer_cooldown.connect("timeout", _on_timer_cooldown_timeout)
	
	add_child(timer_duration)


func _physics_process(delta: float) -> void:
	if IS_DASHING:
		_dash(delta)
		character.move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("Dash") and CAN_DASH:
			timer_duration.start()
			timer_cooldown.start()
			IS_DASHING = true
			CAN_DASH = false


func _dash(_delta):
	var direction = character.get_global_transform().basis.z
	character.velocity.x = direction.x * force
	character.move_and_slide()


func _on_timer_duration_timeout():
	IS_DASHING = false


func _on_timer_cooldown_timeout():
	CAN_DASH = true


# UTILS
func _create_timer(duration: float, parent: Node, connect: ) -> Timer:
	var timer = Timer.new()
	timer.set_wait_time(duration)
	timer.set_one_shot(true)
	parent.add_child(timer)
	return timer