extends Node
class_name State

signal StateTransitioned

var on_enter: Callable
var on_exit: Callable
var on_update: Callable

func enter(): if on_enter: on_enter.call()
func exit(): if on_exit: on_exit.call()
func update(): if on_update: on_update.call()
