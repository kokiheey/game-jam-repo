extends Node
class_name StateMachine


var states: Dictionary = {}
var current_state: State
@export var initial_state: State
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.StateTransitioned.connect(on_state_changed)
			if child == initial_state: 
				current_state = child
				current_state.Enter()

func _physics_process(delta: float) -> void:
	Update()

func AddStates(state : State):
	states[state.name] = state

func Update():
	if current_state: current_state.Update()

func on_state_changed(state_name: String, new_state_name: String):
	if state_name != new_state_name:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state: current_state.Exit()
	current_state = new_state
	current_state.Enter()
