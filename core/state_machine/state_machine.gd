extends Node

@export var character: CharacterBody3D
@export var animator: AnimationTree
@export var initial_state: State

var current_state: State
var states: Dictionary

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_transitioned)

	if initial_state:
		initial_state.enter(null)
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func _input(event):
	if current_state:
		current_state.input(event)

func _unhandled_input(event):
	if current_state:
		current_state.unhandled_input(event)

func _on_transitioned(state, new_state_name, args = null):
	if state != current_state: return

	var new_state = states[new_state_name.to_lower()]
	if !new_state: return

	if current_state: current_state.exit()
	
	new_state.enter(args)
	current_state = new_state
