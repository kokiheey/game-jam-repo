extends Node2D

@export var player : Node2D
@export var chunk_size : int
@export var world_scale : float
@export var LOGICAL_PIXEL_SIZE := 2
@export var fog_bounds : Rect2 = Rect2(Vector2.ZERO, Vector2(4096, 4096)) 
class FogChunk:
	var coord: Vector2i
	var buffer: PackedByteArray
	var image: Image
	var texture: ImageTexture
	var sprite: Sprite2D
	var dirty := false
	
var chunks := {}

func rect_to_chunk_bounds(r: Rect2) -> Rect2i:
	var min_cx : int = floor(r.position.x / 
	(chunk_size * world_scale))
	var min_cy : int = floor(r.position.y /
	(chunk_size * world_scale))
	
	var max_cx : int = floor((r.position.x + 
	r.size.x) / (chunk_size * world_scale))
	var max_cy : int = floor((r.position.y + 
	r.size.y) / (chunk_size * world_scale))
	
	return Rect2i(
		Vector2i(min_cx, min_cy),
		Vector2i(max_cx - min_cx + 1,
				 max_cy - min_cy + 1)
	)

func generate_chunks_from_rect():
	var bounds : Rect2i = rect_to_chunk_bounds(fog_bounds)
	for y in range(bounds.position.y,
	bounds.position.y + bounds.size.y):
		for x in range(bounds.position.x,
		bounds.position.x + bounds.size.x):
			var coord := Vector2i(x, y)
			chunks[coord] = create_chunk(coord)
		

func create_chunk(coord: Vector2i) -> FogChunk:
		var c := FogChunk.new()
		c.coord = coord
		c.buffer = PackedByteArray()
		c.buffer.resize(chunk_size * chunk_size) #fix
		c.buffer.fill(0)
		c.image = Image.create(
			chunk_size,
			chunk_size,
			false,
			Image.FORMAT_RGBA8
		)
		c.image.fill(Color.BLACK)
		
		c.texture = ImageTexture.create_from_image(c.image)
		c.sprite = Sprite2D.new()
		c.sprite.texture = c.texture
		c.sprite.position = Vector2(
			coord.x * chunk_size,
			coord.y * chunk_size,
		) * world_scale
		c.sprite.z_index = 5
		add_child(c.sprite)
		return c
		
func get_chunk(coord: Vector2i) -> FogChunk:
	if not chunks.has(coord): 
		chunks[coord] = create_chunk(coord)
	return chunks[coord]

func world_to_fog_pixel(pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(pos.x / world_scale),
		floor(pos.y / world_scale)
	)

func pixel_to_chunk(p: Vector2i) -> Vector2i:
	return Vector2i(
		floor(float(p.x) / chunk_size),
		floor(float(p.y) / chunk_size)
	)

func pos_mod(a:int, m:int) -> int:
	return ((a % m) + m) % m
func pixel_in_chunk(p: Vector2i) -> Vector2i:
	return Vector2i(
		pos_mod(p.x,  chunk_size),
		pos_mod(p.y, chunk_size)
	)
	
func tile_in_chunk(p: Vector2i) -> Vector2i:
	return Vector2i(
		p.x / LOGICAL_PIXEL_SIZE,
		p.y / LOGICAL_PIXEL_SIZE
	)
	
func reveal_pixel_world(pos: Vector2):
	var p := world_to_fog_pixel(pos)
	var ccoord := pixel_to_chunk(p)
	var local := pixel_in_chunk(p)
	#print_debug("lc ", ccoord, " ", local)
	var chunk := get_chunk(ccoord)
	
	var tile := tile_in_chunk(local)
#	var idx := local.y * chunk_size + local.x
#	if chunk.buffer[idx] == 1: return
#	chunk.buffer[idx] = 1
#	chunk.dirty = true
	for x in range(tile.x * LOGICAL_PIXEL_SIZE, (tile.x+1)*LOGICAL_PIXEL_SIZE):
		for y in range(tile.y * LOGICAL_PIXEL_SIZE, (tile.y+1) * LOGICAL_PIXEL_SIZE):
			var idx := y * chunk_size + x
			if chunk.buffer[idx] == 1: return
			chunk.buffer[idx] = 1
			chunk.dirty = true


func reveal_disk_world(pos: Vector2, radius: int):
	var c := world_to_fog_pixel(pos)
	for y in range(-radius, radius + 1):
		for x in range(-radius, radius + 1):
			if x*x + y*y <= radius*radius:
				var px := (c.x + x)
				var py := (c.y + y)
				reveal_pixel_world(Vector2i(px, py))
func splatter(origin: Vector2, dir: Vector2):
	var forward : Vector2 = dir.normalized()
	var right := Vector2(-forward.y, forward.x)
	
	var rng := RandomNumberGenerator.new()
	rng.seed = 120
	const MAX_R := 15
	const MIN_R := 7
	const SAMPLES := 100
	
	for i in SAMPLES:
		var u := rng.randf()
		var theta := rng.randf_range(-PI * 0.125, PI * 0.125)
		var dist := 128.0 * (1.0 - pow(u, 1.6))
		var bias : float = lerp(0.5, 1.0, u)
		
		var x := dist * bias * cos(theta)
		var y := dist * sin(theta)
		
		var offset := forward * x + right * y
		var center := origin + offset
		
		var r := int(lerp(MAX_R, MIN_R, u))
		reveal_disk_world(center, r)
	
func _ready() -> void:
	generate_chunks_from_rect()
	splatter(Vector2(0,0), Vector2(-2, 0.5))
	reveal_disk_world(Vector2(player.global_position.x, player.global_position.y), 200)

func _process(delta: float) -> void:
	for chunk in chunks.values():
		if not chunk.dirty:
			continue
		
		for y in range(chunk_size):
			for x in range(chunk_size):
				var i := y * chunk_size + x
				if chunk.buffer[i] == 1:
					chunk.image.set_pixel(x, y, Color(
						x/float(chunk_size), y/float(chunk_size), 0, 0.6
					))
		chunk.texture.update(chunk.image)
		chunk.dirty = false
	
