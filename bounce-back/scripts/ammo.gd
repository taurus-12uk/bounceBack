extends Node3D

@export var speed := 20.0
@export var base_damage := 10
@export var max_bounces := 5

@onready var area = $Area3D

var velocity := Vector3.ZERO
var bounce_count := 0
var hit_enemies := []

var current_target = null
var player = null

func _ready():

	player = get_tree().get_first_node_in_group("player")

	area.body_entered.connect(_on_body_entered)

	# initial forward shot
	velocity = -global_transform.basis.z * speed


func _process(delta):

	# If we have a target, home towards it
	if current_target != null and is_instance_valid(current_target):

		var direction = global_position.direction_to(
			current_target.global_position
		)

		velocity = direction * speed

	global_position += velocity * delta


func _on_body_entered(body):

	if body.is_in_group("enemy"):

		if body in hit_enemies:
			return

		hit_enemy(body)

	elif body == player:

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

	var candidates := []

	for body in $Area3D.get_overlapping_bodies():

		if body.is_in_group("enemy"):
			if body not in hit_enemies:
				candidates.append(body)

	if candidates.is_empty():
		current_target = player
		return

	if randi_range(1, 3) == 1:
		current_target = player
	else:
		current_target = candidates[0]


func drop_ammo():

	var pickup = preload("res://ammo_pickup.tscn").instantiate()

	get_parent().add_child(pickup)

	pickup.global_position = global_position

	queue_free()
