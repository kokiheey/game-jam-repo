extends Node
class_name StateMachine


var states: Dictionary = {}
var current_state: State
@export var initial_state: State
func _ready():
	for child in get_children():
		if child is State:
			print("Dodajem state " + child.name)
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
	if current_state.name != state_name:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	print("Prelazim u " + new_state_name)
	if current_state: current_state.Exit()
	current_state = new_state
	current_state.Enter()
