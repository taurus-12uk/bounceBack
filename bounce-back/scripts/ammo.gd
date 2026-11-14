extends RigidBody3D

@export var speed := 20.0
@export var base_damage := 10
@export var max_bounces := 5

@onready var area = $Area3D

var bounce_count := 0
var hit_enemies := []

var current_target = null
var player = null

var can_hit_player := false


func _ready():

	print("AMMO SPAWNED")

	player = get_tree().get_first_node_in_group("player")

	gravity_scale = 0.0
	linear_damp = 0.0
	angular_damp = 0.0

	lock_rotation = true

	contact_monitor = true
	max_contacts_reported = 32

	if area:
		area.body_entered.connect(_on_body_entered)

	linear_velocity = (
		-global_transform.basis.z
		* speed
	)

	await get_tree().create_timer(0.25).timeout

	can_hit_player = true


func _physics_process(_delta):

	if area:

		var bodies = area.get_overlapping_bodies()

		if bodies.size() > 0:

			for body in bodies:

				print("OVERLAPPING: ", body.name)

	if current_target != null:

		if is_instance_valid(current_target):

			var direction = global_position.direction_to(
				current_target.global_position
			)

			linear_velocity = (
				direction.normalized()
				* speed
			)


func _integrate_forces(state):

	for i in range(state.get_contact_count()):

		var normal = state.get_contact_local_normal(i)

		linear_velocity = (
			linear_velocity.bounce(normal).normalized()
			* speed
		)


func _on_body_entered(body):

	print("===================")
	print("TOUCHED: ", body.name)
	print("GROUPS: ", body.get_groups())

	if body.is_in_group("enemy"):

		print("ENEMY DETECTED")

		if body in hit_enemies:
			return

		hit_enemy(body)

	elif body == player:

		print("PLAYER DETECTED")


func hit_enemy(enemy):

	print("HIT ENEMY: ", enemy.name)

	hit_enemies.append(enemy)

	var damage := base_damage

	if bounce_count >= 4:
		damage = enemy.health

	enemy.take_damage(damage)

	bounce_count += 1

	print("BOUNCE COUNT: ", bounce_count)

	speed *= 1.25

	find_next_target()

	if bounce_count >= max_bounces:
		queue_free()

func find_next_target():

	var candidates := []

	for body in area.get_overlapping_bodies():

		if body.is_in_group("enemy"):

			if body not in hit_enemies:

				candidates.append(body)

	if candidates.is_empty():

		print("NO ENEMIES FOUND")

		current_target = player

		return

	print("ENEMIES FOUND: ", candidates.size())

	if randi_range(1, 3) == 1:

		print("TARGETING PLAYER")

		current_target = player

	else:

		current_target = candidates[0]

		print("TARGETING: ", current_target.name)
