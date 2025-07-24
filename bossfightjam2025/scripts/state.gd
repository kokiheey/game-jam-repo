extends Node
class_name State

signal StateTransitioned(current_state: String, new_state: String)

func Enter(): pass
func Exit(): pass
func Update(): pass
