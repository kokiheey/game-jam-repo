extends CanvasLayer

@export_file("*.json") var scene_text_file: String

var scene_text : Dictionary = {}
var selected_text : Array = []
var in_progress : bool = false
var json_parser : JSON
var next_node_id : String
var caller : Node

@onready var background : TextureRect = $Background
@onready var text_label : Label = $TextLabel 

func _ready():
	json_parser = JSON.new()
	background.visible = false
	scene_text = load_scene_text()
	print(scene_text)
	SignalBus.connect("display_dialogue", Callable(self, "on_display_dialogue"))

func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		
		var err = json_parser.parse(content)
		if err != OK:
			push_error("Failed to parse JSON: ", json_parser.get_error_message())
			return null
		return json_parser.get_data()
	else:
		push_error("Failed to open file: ", scene_text_file)
		return null

func show_text():
	if selected_text.size() > 0:
		text_label.text = selected_text[0]
		selected_text.remove_at(0)

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
	SignalBus.emit_signal("dialogue_finish", caller, next_node_id)

func on_display_dialogue(text_key: String, node_id: String, caller: Node) -> void:
	if in_progress:
		next_line()
		return
	
	next_node_id = ""
	self.caller = caller
	
	if not scene_text.has(text_key):
		push_error("No dialogue under key: ", text_key)
		return
	
	var dialogue_data = scene_text[text_key]
	
	if not dialogue_data.has("start") or not dialogue_data.has("nodes"):
		push_error("Brt popravi JSON fali ti start ili nodes: ", text_key)
		return
	
	if node_id == "":
		node_id = dialogue_data["start"]
	
	in_progress = true
	background.visible = true
	get_tree().paused = true
	start_node(dialogue_data["nodes"], node_id)

func start_node(dialogue_data: Dictionary, node_id : String):
	# Za sada napravicu 2 choice system ako treba jos idk moramo da provalimo kasnije
	if dialogue_data[node_id].has("choices"):
		print("TODO: show choices")
		finish()
		return
	
	if dialogue_data[node_id].has("line"):
		selected_text = dialogue_data[node_id]["line"].duplicate()
		next_node_id = dialogue_data[node_id]["next_id"]
		show_text()
