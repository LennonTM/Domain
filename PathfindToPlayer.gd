extends Node3D
var targetPos : Vector3
@export var nav_agent : NavigationAgent3D
@export var SPEED : float

func _ready():
	nav_agent.velocity_computed.connect(_on_navigation_agent_3d_velocity_computed)

func _process(delta):
	targetPos = Vector3(1.79769e308,1.79769e308,1.79769e308)
	for player in get_tree().get_nodes_in_group("player"):
		if (player.global_position-get_parent().global_position).length() < (targetPos-get_parent().global_position).length():
			targetPos = player.global_position
	nav_agent.set_target_position(targetPos)

func _physics_process(delta):
	var nav_velocity = Vector3(0,0,0)
	if get_parent().is_on_floor():
		nav_velocity = nav_agent.get_next_path_position() - get_parent().global_position
		nav_velocity.y = 0
		nav_velocity = nav_velocity.normalized()*SPEED
	nav_agent.set_velocity(nav_velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	get_parent().velocity.x = safe_velocity.x
	get_parent().velocity.z = safe_velocity.z
	get_parent().move_and_slide()
	
