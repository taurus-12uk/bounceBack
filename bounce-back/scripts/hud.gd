extends Control

@onready var health_bar = $HealthBar

@export var player: CharacterBody2D

@onready var ammo_label = $AmmoContainer/AmmoLabel

func _ready():
	player.ammo_changed.connect(update_ammo)
	update_ammo(player.current_ammo, player.max_ammo)

func update_ammo(current, maximum):
	ammo_label.text = str(current) + "/" + str(maximum)
func _process(_delta):
	health_bar.max_value = player.max_health
	health_bar.value = player.health
