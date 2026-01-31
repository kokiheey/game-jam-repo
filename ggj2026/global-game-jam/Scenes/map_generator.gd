extends TileMapLayer

var tiles := []
func generate():
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	


func _ready() -> void:
	for source_id in range(0, tile_set.get_source_count()-1):
		var source := tile_set.get_source(source_id)
		for coord in source.get_tiles_count():
			var atlas_coords := source.get_tile_id(coord)
			tiles.append({
				"source": source_id,
				"atlas": atlas_coords,
				"alt": 0
			})

func _process(delta: float) -> void:
	pass
