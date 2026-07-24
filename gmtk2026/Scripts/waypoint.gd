extends Sprite2D

@export var ON_SCREEN_OFFSET : Vector2 = Vector2(0, 0)
@export var SCREEN_MARGIN    : float   = 12.0
@export var SMOOTHING_SPEED  : float   = 50.0
@export var MIN_SCALE        : float   = 0.1
@export var MAX_SCALE        : float   = 0.2
@export var SCALING_FACTOR   : float   = 500000

var CAMERA_NODE     : Camera2D
@export var TARGET_POSITION : Vector2 = Vector2(800.0, 250.0)

func _ready() -> void:
	CAMERA_NODE = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	if not CAMERA_NODE:
		CAMERA_NODE = get_viewport().get_camera_2d()
		return
	
	var camera_position        : Vector2 = CAMERA_NODE.global_position + CAMERA_NODE.offset
	var viewport_dimensions    : Vector2 = get_viewport().get_visible_rect().size
	var screen_coordinates     : Vector2 = (TARGET_POSITION - camera_position) * CAMERA_NODE.zoom + viewport_dimensions * 0.5
	var screen_inset_rectangle : Rect2   = Rect2(Vector2.ZERO, viewport_dimensions).grow(-SCREEN_MARGIN)
	
	var target_display_position : Vector2
	var target_display_rotation : float
	
	
	if screen_inset_rectangle.has_point(screen_coordinates):
		target_display_position = TARGET_POSITION + ON_SCREEN_OFFSET
		
		var vector_to_target : Vector2 = TARGET_POSITION - camera_position
		target_display_rotation = vector_to_target.angle() - PI * 0.5
		
		scale = Vector2(MAX_SCALE, MAX_SCALE)
	else:
		var clamped_x = clamp(screen_coordinates.x, SCREEN_MARGIN, viewport_dimensions.x - SCREEN_MARGIN)
		var clamped_y = clamp(screen_coordinates.y, SCREEN_MARGIN, viewport_dimensions.y - SCREEN_MARGIN)
		var clamped_screen_coords : Vector2 = Vector2(clamped_x, clamped_y)
		
		target_display_position = camera_position + (clamped_screen_coords - viewport_dimensions * 0.5) / CAMERA_NODE.zoom
		
		var vector_to_target : Vector2 = TARGET_POSITION - target_display_position
		target_display_rotation = vector_to_target.angle() - PI * 0.5
		
		var scale_value : float = max(MIN_SCALE, MAX_SCALE - (camera_position.distance_to(TARGET_POSITION) * (1 / SCALING_FACTOR)))
		scale = Vector2(scale_value, scale_value)
	
	global_position = lerp(global_position, target_display_position, delta * SMOOTHING_SPEED)
	rotation = lerp_angle(rotation, target_display_rotation, delta * SMOOTHING_SPEED)
