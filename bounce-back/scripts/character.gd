extends CharacterBody3D

@onready var head = $Head

@export var ammo_scene: PackedScene

const SPEED = 5.0
const JUMP_VELOCITY = 3.0
const MOUSE_SENSITIVITY = 0.002
const CONTROLLER_SENSITIVITY = 2.5

var health := 100
var ammo := 1
var kill_count := 0

func _physics_process(delta: float) -> void:

	# Shoot
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# Controller look
	var look_input := Input.get_vector(
		"look_left",
		"look_right",
		"look_up",
		"look_down"
	)

	if look_input.length() > 0.05:
		rotate_y(-look_input.x * CONTROLLER_SENSITIVITY * delta)

		head.rotate_x(
			-look_input.y * CONTROLLER_SENSITIVITY * delta
		)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-90),
			deg_to_rad(90)
		)

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if (
		Input.is_action_just_pressed("ui_accept")
		or Input.is_action_just_pressed("jump")
	) and is_on_floor():

		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir := Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	var direction := (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			SPEED
		)

		velocity.z = move_toward(
			velocity.z,
			0,
			SPEED
		)

	move_and_slide()


func shoot():

	if ammo_scene == null:
		print("Ammo scene not assigned!")
		return

	var new_ammo = ammo_scene.instantiate()

	get_tree().current_scene.add_child(new_ammo)

	# Spawn slightly in front of the player
	new_ammo.global_position = (
		head.global_position
		+ (-head.global_transform.basis.z * 2.0)
	)

	# Match where the camera/head is looking
	new_ammo.global_transform.basis = head.global_transform.basis

	# Tell the ammo its initial direction
	new_ammo.linear_velocity = (
		-head.global_transform.basis.z
		* new_ammo.speed
	)

	print("Shot fired!")


func take_damage(amount):

	health -= amount

	print("Player HP: ", health)

	if health <= 0:
		queue_free()
