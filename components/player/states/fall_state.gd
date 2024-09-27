class_name FallState extends State

@onready var character = get_parent().character
@onready var animator = get_parent().animator

func enter(_args):
    pass


func update(_delta):
    pass
    

func physics_update(_delta):
    character.movement_handler(_delta)

    if character.is_on_floor():
        transitioned.emit(self, "GroundedState")

    character.move_and_slide()


func exit():
   character.squatch()