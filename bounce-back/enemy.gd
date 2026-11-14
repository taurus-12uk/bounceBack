extends CharacterBody3D

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var health = 50

func take_damage(amount):

	health -= amount

	print(name, " Health: ", health)

	if health <= 0:
		queue_free()

func _ready() -> void:
	# Set the target position in world space
	navigation_agent.target_position = Vector3(10, 0, 10)

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_transform.origin
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	velocity = new_velocity
	move_and_slide()
