extends CharacterBody3D
@onready var mesh = $MeshInstance3D
@onready var twist = $Twist
@onready var HitMarker = $HitMarker
#@onready var direct = $Direct
var target : Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const ROT_SPEED = 0.1


func _physics_process(delta):
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	#if twist.global_position != nav_agent.get_next_path_position():
		#var wtransform = twist.global_transform.looking_at(Vector3(nav_agent.get_next_path_position().x,twist.global_position.y,nav_agent.get_next_path_position().z))
		#var wrotation = Quaternion(twist.basis).slerp(Quaternion(wtransform.basis), ROT_SPEED)
		#twist.global_transform = Transform3D(Basis(wrotation), global_transform.origin)

	
