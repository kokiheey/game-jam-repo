extends Node2D

var current_interactions := []
var can_interact: bool = true

func process_interaction() -> void:
	can_interact = false;
	await current_interactions[0].interact.call()
	can_interact = true;

func _process(_delta: float) -> void:
	if not current_interactions: return
	for a in current_interactions:
		a.interaction_label.hide()
	if can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			current_interactions[0].interaction_label.show()
	else:
		current_interactions[0].interaction_label.hide()

func _sort_by_nearest(area1: Area2D, area2: Area2D) -> bool:
	var d1 := global_position.distance_squared_to(area1.global_position)
	var d2 := global_position.distance_squared_to(area2.global_position)
	return d1 < d2

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Interactable:
		current_interactions.push_back(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Interactable:
		area.interaction_label.hide()
		current_interactions.erase(area)
