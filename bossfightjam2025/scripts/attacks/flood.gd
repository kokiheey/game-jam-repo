extends Node2D
class_name Flood

@export var scale_up_time := 1.5
@export var hold_time := 10.0
@export var scale_down_time := 0.5
@export var target_scale := Vector2(1, -8)
@export var minAttacks: int = 3
@export var maxAttacks: int = 6
@export var minCooldownAttack: float = 2
@export var maxCooldownAttack: float = 4
@export var damage: int = 1
@export var normalColor: Color = Color8(255, 0, 0, 170)
@export var invertedColor: Color = Color8(38, 88, 140, 170)

@onready var inbetweenAttackTimer := Timer.new()
@onready var hurt_box: Area2D = $Hurtbox
@onready var flood_spirte: Sprite2D = $FloodSprite

var attackCount : int
var attacksDone : int = 0
var inverted: bool
var pillar_attack = preload("res://scenes/boss/pillar.tscn")

signal attack_end

func _ready() -> void:
	randomize()
	inverted = randi_range(0, 1)
	if inverted:
		flood_spirte.modulate = invertedColor
	else:
		flood_spirte.modulate = normalColor
	hurt_box.body_entered.connect(try_damage)
	add_child(inbetweenAttackTimer)
	inbetweenAttackTimer.one_shot = true
	attacksDone = 0
	global_position = Vector2(0, get_viewport().size.y)
	scale = Vector2(1, 0)
	var rise_tween  = create_tween()
	rise_tween .tween_property(self, "scale", target_scale, scale_up_time)\
	 .set_trans(Tween.TRANS_BACK)\
	 .set_ease(Tween.EASE_OUT_IN)
	rise_tween .tween_callback(Callable(self, "StartAttack"))

func StartAttack():
	print("Pillar attack started")
	attackCount = randi_range(minAttacks, maxAttacks)
	print("Number of attacks ",attackCount)
	for i in range(attackCount):
		inbetweenAttackTimer.wait_time = randf_range(minCooldownAttack, maxCooldownAttack)
		inbetweenAttackTimer.start()
		await inbetweenAttackTimer.timeout
		DoAttack()

func DoAttack():
	var pillar = pillar_attack.instantiate()
	pillar.connect("destroyed", CountAttacks)
	pillar.position = Vector2(0, 0)
	pillar.top_level = true
	add_child(pillar)
	print("Flood scale:", scale)
	print("Pillar scale:", pillar.scale)
	print("Pillar global_scale:", pillar.global_scale)

func CountAttacks():
	attacksDone += 1
	if attacksDone >= attackCount:
		EndAttack()

func EndAttack():
	print("Flood attack finished")
	var down_tween = create_tween()
	down_tween.tween_property(self, "scale", Vector2(1, 0), scale_down_time) \
			  .set_trans(Tween.TRANS_SINE) \
			  .set_ease(Tween.EASE_IN)
	down_tween.tween_callback(Callable(self, "queue_free"))
	attack_end.emit()
	
#Poboljsati damage taking jer ce sada ako jednom bude hitan moci samo da cami u "vodi" ili sta je vec ovo
#mozda dodati check da svaki put dok je tu primi damage i onda ima neke iframes i onda opet nez mozda sa timerom
func try_damage(body: Node2D):
	if body is CharacterBody2D and body.inverted != inverted:
		body.take_damage(damage)
