extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ammo_area= $Area3D
	ammo_area.body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(body):
	var enemy = body

func _process(delta: float) -> void:
	pass
