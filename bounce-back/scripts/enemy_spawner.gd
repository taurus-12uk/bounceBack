extends Node3D

@export var enemy_scene: PackedScene
@export var spawn_interval := 3.0
@export var max_enemies := 10
@export var spawn_radius := 10.0
@export var starting_enemies := 5

var timer := 0.0

func _ready():

	await get_tree().process_frame

	for i in range(starting_enemies):
		spawn_enemy()


func _process(delta):

	timer += delta

	if timer >= spawn_interval:

		timer = 0.0

		spawn_enemy()


func spawn_enemy():

	var enemies = get_tree().get_nodes_in_group("enemy")

	if enemies.size() >= max_enemies:
		return

	if enemy_scene == null:
		push_error("enemy_scene not assigned!")
		return

	var enemy = enemy_scene.instantiate()

	get_parent().add_child(enemy)

	enemy.global_position = global_position + Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0,
		randf_range(-spawn_radius, spawn_radius)
	)
