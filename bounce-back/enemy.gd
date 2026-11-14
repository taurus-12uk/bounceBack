extends CharacterBody3D

@export var speed := 5.0

var health := 50
var player

@onready var navigation_agent = $NavigationAgent3D


func _ready():

	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):

	if player == null:
		return

	navigation_agent.target_position = player.global_position

	var next_position = navigation_agent.get_next_path_position()

	var direction = global_position.direction_to(next_position)

	velocity = direction * speed

	move_and_slide()


func take_damage(amount):

	health -= amount

	print(name, " HP: ", health)

	if health <= 0:
		queue_free()
