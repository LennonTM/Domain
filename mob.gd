extends CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var label = $HealthBar/SubViewport/HealthBar3D
@onready var mesh = $MeshInstance3D
@onready var walking = $Walking
@onready var HitMarker = $HitMarker
@onready var HPcomp = $HPComp
var target : Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const ROT_SPEED = 0.1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	#twist.look_at(Vector3(nav_agent.get_next_path_position().x, twist.global_position.y, nav_agent.get_next_path_position().z))
	if global_position != nav_agent.get_next_path_position():
		var wtransform = global_transform.looking_at(Vector3(nav_agent.get_next_path_position().x,global_position.y,nav_agent.get_next_path_position().z))
		var wrotation = Quaternion(basis).slerp(Quaternion(wtransform.basis), ROT_SPEED)
		global_transform = Transform3D(Basis(wrotation), global_transform.origin)
		#wtransform = direct.global_transform.looking_at(target)
		#wrotation = Quaternion(direct.basis).slerp(Quaternion(wtransform.basis), ROT_SPEED)
		#direct.global_transform = Transform3D(Basis(wrotation), global_transform.origin)
