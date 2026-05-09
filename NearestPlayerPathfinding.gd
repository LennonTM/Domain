extends Node3D

@onready var agent = $NavigationAgent3D

var targetPos

func _ready():
	pass


func _process(delta):
	targetPos = Vector3(1.79769e308,1.79769e308,1.79769e308)
	for player in get_tree().get_nodes_in_group("player"):
		if (player.global_position-global_position).length() < (targetPos-global_position).length():
			targetPos = player.global_position
	agent.set_target_position(targetPos)

func _physics_process(delta):
	var nav_velocity = Vector3(0,0,0)
	if(get_parent().is_on_floor()):
		#nav_velocity = (agent.get_next_path_position() - get_parent()global_position).normalized()*SPEED
	agent.set_velocity(nav_velocity)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	get_parent().velocity.x = safe_velocity.x
	get_parent().velocity.z = safe_velocity.z
	get_parent().move_and_slide()
