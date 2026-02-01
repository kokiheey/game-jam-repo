extends TileMapLayer
@export var height:int = 40
@export var width:int = 60
var tiles := []
var weights := [0.9, 0.02, 0.03, 0.05]
var rng : RandomNumberGenerator
func pickTile():
	var r := rng.randf()
	for i in tiles.size():
		r -= weights[i]
		if r <= 0:
			return tiles[i]
func generate():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	for y in range(-height/2, height/2):
		for x in range(-width/2, width/2):
			var t = pickTile()
			set_cell(Vector2i(x,y),
			t.source,
			t.atlas,
			t.alt)

func _ready() -> void:
	for source_id in range(0, tile_set.get_source_count()):
		var source := tile_set.get_source(source_id)
		for coord in source.get_tiles_count():
			var atlas_coords := source.get_tile_id(coord)
			tiles.append({
				"source": source_id,
				"atlas": atlas_coords,
				"alt": 0
			})
	generate()
