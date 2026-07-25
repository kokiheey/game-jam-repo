extends Control

@onready var MONEY_LABEL : Label       = $CountdownPanel/MoneyLabel
@onready var FUEL_BAR    : ProgressBar = $FuelBar
@onready var HEALTH_BAR  : ProgressBar = $HealthBar


func update_money(money : int) -> void:
	MONEY_LABEL.text = str(money) + "$"

func update_fuel(maxFuel : float, fuel : float) -> void:
	FUEL_BAR.value = fuel / maxFuel * 100
