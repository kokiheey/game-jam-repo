extends Node
class_name StateMachine

@export var idle_state_script: Script
@export var move_state_script: Script
@export var attack_state_script: Script
@export var stun_state_script: Script
@export var dash_state_script: Script

var idle_state
var move_state
var attack_state
var stun_state
var dash_state

var current_state = null

func _ready():
	idle_state = idle_state_script.new() if idle_state_script else null
	move_state = move_state_script.new() if move_state_script else null
	attack_state = attack_state_script.new() if attack_state_script else null
	stun_state = stun_state_script.new() if stun_state_script else null
	dash_state = dash_state_script.new() if dash_state_script else null

	if idle_state:
		add_child(idle_state)
	if move_state:
		add_child(move_state)
	if attack_state:
		add_child(attack_state)
	if stun_state:
		add_child(stun_state)
	if dash_state:
		add_child(dash_state)

	change_state(idle_state)

func change_state(new_state) -> void:
	if current_state == new_state:
		return
	if current_state and current_state.has_method("exit"):
		current_state.exit()
	current_state = new_state
	print("Now in state %s" % current_state.get_script().get_global_name())
	if current_state and current_state.has_method("enter"):
		current_state.enter()

func can_move() -> bool:
	return current_state and current_state.has_method("can_move") and current_state.can_move()

func can_dash() -> bool:
	return current_state and current_state.has_method("can_dash") and current_state.can_dash()

func can_attack() -> bool:
	return current_state and current_state.has_method("can_attack") and current_state.can_attack()

func on_dash_finished() -> void:
	change_state(move_state)
