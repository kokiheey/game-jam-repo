extends CanvasLayer

@export_file("*.json") var scene_text_file: String

var scene_text := {}
var selected_text := []
var in_progress : bool = false

@onready var background : TextureRect = $Background
@onready var text_label : Label = $TextLabel 

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	SignalBus.connect("display_dialogue", Callable(self, "on_display_dialogue"))

func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var json_parser = JSON.new()
		var err = json_parser.parse(content)
		if err != OK:
			push_error("Failed to parse JSON: %s" % json_parser.get_error_message())
			return null
		return json_parser.get_data()
	else:
		push_error("Failed to open file: %s" % scene_text_file)
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
	text_label.text       = ""
	background.visible    = false
	in_progress           = false
	get_tree().paused     = false

func on_display_dialogue(text_key:String) -> void:
	if in_progress:
		next_line()
		return

	if not scene_text.has(text_key):
		push_error("No dialogue for key '%s'" % text_key)
		return

	# Pull out the raw data:
	var raw = scene_text[text_key]

	var lines: Array
	match typeof(raw):
		TYPE_ARRAY:
			lines = raw.duplicate()
		TYPE_STRING:
			lines = [ raw ]
		_:
			push_error("Dialogue for key '%s' is not a String or Array!" % text_key)
			return
	get_tree().paused  = true
	background.visible = true
	in_progress        = true
	selected_text      = lines
	show_text()
