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
		a.label_text
	if can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			current_interactions[0].interaction_label.show()
	else:
		current_interactions[0].interaction_label.hide()

func _sort_by_nearest(area1: Area2D, area2: Area2D) -> bool:
	var area1_dist = global_position.direction_to(area1.global_position)
	var area2_dist = global_position.direction_to(area2.global_position)
	return area1_dist < area2_dist

func _on_area_2d_area_entered(area: Area2D) -> void:
	current_interactions.push_back(area)


func _on_area_2d_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
