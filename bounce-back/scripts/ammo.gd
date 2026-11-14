extends Node3D

@export var base_damage := 10
@export var speed := 20.0
@export var max_bounces := 5

var bounce_count := 0
var hit_enemies := []
var current_target = null
var player = null

func _ready():

	player = get_tree().get_first_node_in_group("player")

	$Area3D.body_entered.connect(_on_body_entered)

	if bounce_count >= max_bounces:
		drop_ammo()
	else:
		find_next_target()

func _process(delta):

	if current_target == null:
		return

	if !is_instance_valid(current_target):
		find_next_target()
		return

	var dir = global_position.direction_to(current_target.global_position)

	global_position += dir * speed * delta


func _on_body_entered(body):

	if current_target != null and body != current_target:
		return

	if body.is_in_group("enemy"):

		if body in hit_enemies:
			return

		hit_enemy(body)
		return

	if body == player:

		player.take_damage(base_damage)

		if bounce_count >= max_bounces:
			drop_ammo()
		else:
			find_next_target()


func hit_enemy(enemy):

	hit_enemies.append(enemy)

	var damage = base_damage

	if bounce_count == 4:
		damage = 99999

	enemy.take_damage(damage)

	bounce_count += 1

	speed *= 1.25

	if bounce_count >= max_bounces:
		drop_ammo()
	else:
		find_next_target()


func find_next_target():

	var candidates = []

	for body in $Area3D.get_overlapping_bodies():

		if body.is_in_group("enemy"):

			if body not in hit_enemies:

				candidates.append(body)

	if candidates.is_empty():

		current_target = player
		return

	var roll = randi_range(1, 3)

	if roll == 1:
		current_target = player
	else:
		current_target = candidates[0]


func drop_ammo():

	var pickup = preload("res://ammo_pickup.tscn").instantiate()

	get_parent().add_child(pickup)

	pickup.global_position = global_position

	pickup.linear_velocity = Vector3(
		randf_range(-2, 2),
		3,
		randf_range(-2, 2)
	)

	queue_free()
