class_name ObjectSpawner
extends Node

@export var spawnableObject   : PackedScene
@export var randomDistance    : float
@export var minSpawnTime      : float
@export var maxSpawnTime      : float
@export var minObjectsToSpawn : int
@export var maxObjectsToSpawn : int
@export var _active : bool = false
var targetLocation : Vector2
var spawnTimer : Timer

signal objectCreated(object: Node)

func Activate():
	_active = true
	spawnTimer.start(randf_range(minSpawnTime,  maxSpawnTime))

func Deactivate():
	_active = false
	spawnTimer.stop()

func spawnObjects():
	var objectsToSpawn : int = randi_range(minObjectsToSpawn, maxObjectsToSpawn)
	for i in range(objectsToSpawn):
		var object = spawnableObject.instantiate() as Node
		object.global_position = targetLocation + \
		Vector2.RIGHT.rotated(randf_range(-PI, PI)) * randf_range(0, randomDistance)
		objectCreated.emit(object)
	if _active:
		spawnTimer.start(randf_range(minSpawnTime, maxSpawnTime))

func _ready():
	spawnTimer = Timer.new()
	spawnTimer.one_shot = true
	spawnTimer.timeout.connect(spawnObjects)
	call_deferred("add_child", spawnTimer)
	if _active:
		spawnTimer.start()
