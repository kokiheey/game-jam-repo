extends CharacterBody2D
class_name Player

@onready var input_component = $Input
@onready var movement_component = $Movement
#@onready var attack_component = $Attack
@onready var state_machine = $StateMachine

func _ready() -> void:
	movement_component.dash_finished.connect(state_machine.on_dash_finished)
	input_component.dash_requested.connect(self._on_dash_requested)




func _physics_process(delta):
	
	var direction : Vector2 = input_component.direction
	if state_machine.can_move():
		if direction.length() > 0 and state_machine.current_state == state_machine.idle_state:
			state_machine.change_state(state_machine.move_state)
		elif direction.length() == 0 and state_machine.current_state == state_machine.move_state:
			state_machine.change_state(state_machine.idle_state)
		
		movement_component.set_input_vector(direction)
	else:
		movement_component.set_input_vector(Vector2.ZERO)
	
	movement_component.process_movement(self, delta)

func _on_dash_requested():
	if not state_machine.can_dash():
		return
	if movement_component.can_dash:
		movement_component.dash()
		state_machine.change_state(state_machine.dash_state)
