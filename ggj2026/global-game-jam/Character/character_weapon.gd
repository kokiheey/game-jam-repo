class_name CharacterWeapons
extends Node2D

@export var weapon_to_equip : PackedScene

var current_weapon : Weapon

@onready var character : Player = $".."

func _ready() -> void:
	if weapon_to_equip:
		equip_weapon(weapon_to_equip)
	
func equip_weapon(weapon_scene : PackedScene):
	if current_weapon:
		unequip_weapon()
		
	current_weapon = weapon_scene.instantiate()
	add_child(current_weapon)
	current_weapon.global_position = global_position
	
	current_weapon.owner_p = character
	current_weapon._equip()

func unequip_weapon():
	if not current_weapon:
		return
		
	current_weapon._unequip()
	current_weapon.queue_free()
