extends CharacterBody3D

@export var speed := 4.0
@export var max_health := 50

var health := 50
var player

func _ready():

	add_to_group("enemy")

	health = max_health

	player = get_tree().get_first_node_in_group("player")

	print(name, " spawned with ", health, " health")


func _physics_process(_delta):

	if player == null:
		return

	var direction = global_position.direction_to(
		player.global_position
	)

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()


func take_damage(amount):

	health -= amount

	print(name, " took ", amount, " damage")
	print(name, " health = ", health)

	if health <= 0:
		die()


func die():

	var player_node = get_tree().get_first_node_in_group("player")

	if player_node != null:

		player_node.kill_count += 1

		print("KILLS: ", player_node.kill_count)
	queue_free()
