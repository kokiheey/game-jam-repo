extends Control

signal bought_fuel(amount)

signal moneyChanged(newMoney : int)
signal boughtSpeed
signal boughtWaypointDistance
signal boughtPickupSpeed
signal boughtPackagePrice

var money : int
@export var fuelPrice : float = 1
@export var speedUpgradeCost : int = 10
@export var speedCostIncrease : int = 10
@export var pickupSpeedCost  : int = 30
@export var pickupCostIncrease  : int = 20
@export var packagePriceCost : int = 20
@export var packageCostIncrease : int = 25
var MAX_FUEL : float = 100.0
var current_fuel : float = 0
var upgrades : Array = []
var new_fuel_ammount : float = 0.0 

@onready var pump : VSlider = $MarginContainer/HBoxContainer/PumpBorder/MarginContainer/VBoxContainer/FuelSlider
@onready var fuellabel : Label = $MarginContainer/HBoxContainer/PumpBorder/MarginContainer/VBoxContainer/VBoxContainer/Label2
@onready var buyFuel : Button = $MarginContainer/HBoxContainer/PumpBorder/MarginContainer/VBoxContainer/VBoxContainer/Button

@onready var BuySpeedButton : Button = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/SpeedUpgradeLayout2/HBoxContainer/SpeedButton
@onready var BuyPickupButton : Button =$MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PickupUpgardeLayout/HBoxContainer/CollectionSpeed
@onready var BuyPackageButton : Button = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PackageUpgardeLayout/HBoxContainer/Buy

@onready var SpeedPriceLabel : Label = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/SpeedUpgradeLayout2/HBoxContainer/Cost
@onready var PickupPriceLabel : Label = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PickupUpgardeLayout/HBoxContainer/Cost
@onready var PackagePriceLabel : Label = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PackageUpgardeLayout/HBoxContainer/Cost

@onready var SpeedProgress : ProgressBar = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/SpeedUpgradeLayout2/HBoxContainer/ProgressBar
@onready var PickpuProgress : ProgressBar = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PickupUpgardeLayout/HBoxContainer/ProgressBar
@onready var PackageProgress : ProgressBar = $MarginContainer/HBoxContainer/ShopBorder/MarginContainer/VBoxContainer/VBoxContainer/PackageUpgardeLayout/HBoxContainer/ProgressBar

func try_purchase(index : int):
	var upgrade = upgrades[index]
	if money >= upgrade["cost"]:
		money -= upgrade["cost"]
		upgrade["bar"].value += 1
		upgrade["cost"] += upgrade["inc"]
		upgrade["label"].text = "Cost : " + str(upgrade["cost"]) + "$"
		upgrade["signal"].emit()
		moneyChanged.emit(money)

func _ready():
	pump.value = current_fuel
	upgrades = [
		{ "cost": speedUpgradeCost, "inc": speedCostIncrease, "signal": boughtSpeed, "label": SpeedPriceLabel, "bar": SpeedProgress},
		{ "cost": pickupSpeedCost, "inc": pickupCostIncrease, "signal": boughtPickupSpeed, "label": PickupPriceLabel, "bar": PickpuProgress },
		{ "cost": packagePriceCost, "inc": packageCostIncrease, "signal": boughtPackagePrice, "label": PackagePriceLabel, "bar": PackageProgress },
	]
	BuySpeedButton.pressed.connect(try_purchase.bind(0))
	BuyPickupButton.pressed.connect(try_purchase.bind(1))
	BuyPackageButton.pressed.connect(try_purchase.bind(2))

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
	#var maxAfford = (float(money) / fuelPrice) * 100 / MAX_FUEL
	#pump.value = max(current_fuel, min(value * MAX_FUEL / 100, min(MAX_FUEL, maxAfford + current_fuel))) / MAX_FUEL * 100
	pump.value = max(current_fuel, min(value * MAX_FUEL / 100, MAX_FUEL)) / MAX_FUEL * 100
	
	#new_fuel_ammount = max(current_fuel, min(value * MAX_FUEL / 100, min(MAX_FUEL, maxAfford + current_fuel)))
	new_fuel_ammount = max(current_fuel, min(value * MAX_FUEL / 100, MAX_FUEL))
	update_fuel_shop()


func _on_button_pressed() -> void:
	print(new_fuel_ammount)
	var price = (new_fuel_ammount - current_fuel) * fuelPrice
	money -= price
	bought_fuel.emit(new_fuel_ammount - current_fuel)
	moneyChanged.emit(money)
	current_fuel = new_fuel_ammount
	update_fuel_shop()
