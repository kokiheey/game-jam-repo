extends Node2D
class_name InteractionManager


@onready var player: CharacterBody2D = get_tree().get_node("Player")
@onready var label: Label = $InteractLabel
var active_areas: Array[InteractableArea]
var can_interact: bool = true

const base_text: String = "[E] to "

func register_area(area: InteractableArea):
	active_areas.push_back(area)

func unregister_area(area: InteractableArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas[index] = area.back()
		active_areas.pop_back()

func _process(delta: float) -> void:
	if active_areas.size() > 0 and can_interact:
		active_areas.sort_custom(func(a:Area2D, b:Area2D): return a.distance_squared_to(player.global_position) < \
		b.distance_squared_to(player.global_position))

		var currentArea: InteractableArea = active_areas[0]
		label.text = base_text + currentArea.action_name
		label.global_position = currentArea.global_position
		label.global_position.y -= 20
		label.global_position.x = label.size.x / 2
		label.show()
	else:
		label.hide()

func _input(event):
	if event.is_action_pressed("interact"):
		if can_interact and not active_areas.is_empty():
			can_interact = false
			label.hide()
			await active_areas[0].interact.call()
			label.show()

