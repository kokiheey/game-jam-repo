extends Control

signal moneyChanged(newMoney : int)
signal boughtSpeed
signal boughtWaypointDistance
signal boughtPickupSpeed

var money : int
@export var fuelPrice : float = 1
@export var speedUpgradeCost     : int = 1
@export var waypointDistanceCost : int = 1
@export var pickupSpeedCost  : int = 1
var MAX_FUEL : float = 100.0
var current_fuel : float = 0
var upgrades : Array = []
var new_fuel_ammount : float = 0.0 

@onready var pump : VSlider = $MarginContainer/BoxContainer/PumpBorder/MarginContainer/VBoxContainer/FuelSlider
@onready var fuellabel : Label = $MarginContainer/BoxContainer/PumpBorder/MarginContainer/VBoxContainer/VBoxContainer/Label2
@onready var buyFuel : Button = $MarginContainer/BoxContainer/PumpBorder/MarginContainer/VBoxContainer/VBoxContainer/Button

func try_purchase(index : int):
	var upgrade = upgrades[index]
	if money >= upgrade["cost"]:
		money -= upgrade["cost"]
		upgrade["signal"].emit()
		moneyChanged.emit(money)

func _ready():
	pump.value = current_fuel
	upgrades = [
		{ "cost": speedUpgradeCost    , "signal": boughtSpeed},
		{ "cost": pickupSpeedCost     , "signal": boughtPickupSpeed },
	]
	$MarginContainer/BoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/SpeedButton.pressed.connect(try_purchase.bind(0))
	$MarginContainer/BoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/CollectionSpeed.pressed.connect(try_purchase.bind(1))

func open(mxfuel : float, fuel : float):
	MAX_FUEL = mxfuel
	current_fuel = fuel
	pump.value = current_fuel / MAX_FUEL * 100
	self.show()

func update_fuel_shop():
	var price = (new_fuel_ammount - current_fuel) * fuelPrice
	
	fuellabel.text = "Total : " + str(ceil(price))
	
	if price > money:
		buyFuel.text = "Cannot afford"
		buyFuel.disabled = true
	elif price > 0:
		buyFuel.text = "Buy"
		buyFuel.disabled = false
	else:
		buyFuel.text = "Buy"
		buyFuel.disabled = true

func _on_fuel_slider_value_changed(value: float) -> void:
	pump.value = max(current_fuel, min(value * MAX_FUEL / 100, MAX_FUEL)) / MAX_FUEL * 100
	new_fuel_ammount = max(current_fuel, min(value * MAX_FUEL / 100, MAX_FUEL))
	update_fuel_shop()
