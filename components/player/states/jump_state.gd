class_name JumpState extends State

@onready var character = get_parent().character
@onready var animator = get_parent().animator


func enter(_args):
    _jump()


func update(_delta):
    pass
    

func physics_update(delta):

    character.movement_handler(delta)

    if Input.is_action_just_pressed("Jump") and character.JUMPS_LEFT > 0:
        _jump()
    
    if character.is_on_floor():
        transitioned.emit(self, "GroundedState")

    character.move_and_slide()


func _jump():
    character.stretch()
    character.velocity.y = character.JUMP_FORCE
    animator.set("parameters/jump_shot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    if character.JUMPS_LEFT != character.JUMPS:
        pass


    character.JUMPS_LEFT -= 1


func exit():
    character.JUMPS_LEFT = character.JUMPS
    character.squatch()