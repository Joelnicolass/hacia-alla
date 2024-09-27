class_name GroundedState extends State

@onready var character = get_parent().character
@onready var animator = get_parent().animator


func enter(_args):
	if character.coyote_timer && !character.coyote_timer.is_connected('timeout', _on_coyote_timer_timeout):
		character.coyote_timer.connect("timeout", _on_coyote_timer_timeout)
		

func update(_delta):
	_animations_handler()


func physics_update(delta):
	character.movement_handler(delta)

	if !character.is_on_floor() && character.coyote_timer.is_stopped():
		character.coyote_timer.start()

	if Input.is_action_just_pressed("Jump"):
		transitioned.emit(self, "JumpState")

	character.move_and_slide()


func _animations_handler():
	if character.velocity.length() != 0 && character.is_on_floor():
		animator.set("parameters/Transition/transition_request", "walk")
	else:
		animator.set("parameters/Transition/transition_request", "idle")


func _on_coyote_timer_timeout():
	character.coyote_timer.stop()

	if !character.is_on_floor():
		transitioned.emit(self, "FallState")
